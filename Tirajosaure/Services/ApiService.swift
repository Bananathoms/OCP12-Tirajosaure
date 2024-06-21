//
//  ApiService.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import Foundation
import ParseSwift
import SwiftUI
import Alamofire

/// A service class responsible for handling API requests.
class ApiService {
    static var current = ApiService()
    
    private init() {}
    
    /// Registers a new user with the provided details.
    /// - Parameters:
    ///   - user: The `User` object containing the registration details.
    ///   - onResult: A closure to handle the result of the registration, returning a `Result` with either a `User` or an `AppError`.
    func signUp(user: User, onResult: @escaping (Result<User, AppError>) -> Void) {
        let parameters: [String: Any] = [
            APIConstants.Parameters.username: user.username ?? DefaultValues.emptyString,
            APIConstants.Parameters.email: user.email ?? DefaultValues.emptyString,
            APIConstants.Parameters.password: user.password ?? DefaultValues.emptyString,
            APIConstants.Parameters.firstName: user.firstName ?? DefaultValues.emptyString,
            APIConstants.Parameters.lastName: user.lastName ?? DefaultValues.emptyString
        ]
        AF.request(ParseConfig.serverURL + APIConstants.Endpoints.signUp, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders())
            .validate()
            .responseData { response in
                self.handleAlamofireResponse(response, ofType: User.self, originalUser: user, onResult: onResult)
            }
    }
    
    /// Logs in a user with the provided email and password.
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - password: The password of the user.
    ///   - onResult: A closure to handle the result of the login, returning a `Result` with either a `User` or an `AppError`.
    func logIn(email: String, password: String, onResult: @escaping (Result<User, AppError>) -> Void) {
        let parameters: [String: Any] = [
            APIConstants.Parameters.username: email,
            APIConstants.Parameters.password: password
        ]
        AF.request(ParseConfig.serverURL + APIConstants.Endpoints.logIn, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: getHeaders())
            .validate()
            .responseData { response in
                self.handleAlamofireResponse(response, ofType: User.self, originalUser: User(username: email, email: email, password: password), onResult: onResult)
            }
    }
    
    /// Requests a password reset for the user with the provided email.
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - onResult: A closure to handle the result of the request, returning a `Result` with either `Void` or an `AppError`.
    func requestPasswordReset(email: String, onResult: @escaping (Result<Void, AppError>) -> Void) {
        let parameters: [String: Any] = [APIConstants.Parameters.email: email]
        
        AF.request(ParseConfig.serverURL + APIConstants.Endpoints.requestPasswordReset, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders())
            .validate()
            .responseData { response in
                switch response.result {
                case .success:
                    onResult(.success(()))
                case .failure(let error):
                    if let data = response.data, let responseDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let errorMessage = responseDict[DefaultValues.error] as? String {
                        onResult(.failure(.networkError("\(ErrorMessage.failedToRequestPasswordReset.localized): \(errorMessage)")))
                    } else {
                        onResult(.failure(.networkError("\(ErrorMessage.failedToRequestPasswordReset.localized): \(error.localizedDescription)")))
                    }
                }
            }
    }
    
    /// Fetches questions associated with a specific user from the Parse server.
    /// - Parameters:
    ///   - userId: The ID of the user whose questions are to be fetched.
    ///   - completion: A closure to handle the result of the fetch operation.
    func fetchQuestions(for userId: String, completion: @escaping (Result<[Question], AppError>) -> Void) {
        let url = "\(ParseConfig.serverURL)/classes/Question"
        let parameters: Parameters = [
            "where": "{\"user\":{\"__type\":\"Pointer\",\"className\":\"_User\",\"objectId\":\"\(userId)\"}}"
        ]
        let headers = getHeaders()
        
        AF.request(url, parameters: parameters, headers: headers).validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: ParseResponse<Question>.self) { result in
                switch result {
                case .success(let parseResponse):
                    completion(.success(parseResponse.results))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    /// Saves a `Question` object to the Parse server.
    /// - Parameters:
    ///   - question: The `Question` object to be saved.
    ///   - completion: A closure to handle the result of the save operation.
    func saveQuestion(_ question: Question, completion: @escaping (Result<Question, AppError>) -> Void) {
        let url = "\(ParseConfig.serverURL)/classes/Question"
        let headers = getHeaders()
        var parameters: [String: Any] = [
            "title": question.title,
            "options": question.options,
            "user": ["__type": "Pointer", "className": "_User", "objectId": question.user.objectId]
        ]
        if let objectId = question.objectId {
            parameters["objectId"] = objectId
        }
        
        let request: DataRequest
        if question.objectId != nil {
            request = AF.request("\(url)/\(question.objectId!)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        } else {
            request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        }
        
        request.validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: Question.self, onResult: completion)
        }
    }
    
    /// Deletes a `Question` object from the Parse server.
    /// - Parameters:
    ///   - question: The `Question` object to be deleted.
    ///   - completion: A closure to handle the result of the delete operation.
    func deleteQuestion(_ question: Question, completion: @escaping (Result<Void, AppError>) -> Void) {
        guard let objectId = question.objectId else {
            completion(.failure(.validationError("Invalid Question ID")))
            return
        }
        let url = "\(ParseConfig.serverURL)/classes/Question/\(objectId)"
        let headers = getHeaders()
        
        AF.request(url, method: .delete, headers: headers).validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: VoidResponse.self) { result in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    /// Handles the response from an Alamofire request.
    /// - Parameters:
    ///   - response: The `AFDataResponse<Data>` object containing the response data.
    ///   - ofType: The type of the expected response.
    ///   - originalUser: The original `User` object passed to the request (optional).
    ///   - onResult: A closure to handle the result of the response.
    func handleAlamofireResponse<T: Decodable>(_ response: AFDataResponse<Data>, ofType: T.Type, originalUser: User? = nil, onResult: @escaping (Result<T, AppError>) -> Void) {
        switch response.result {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let result = try decoder.decode(T.self, from: data)
                if let user = result as? User, let originalUser = originalUser {
                    var updatedUser = user
                    updatedUser.firstName = user.firstName ?? originalUser.firstName
                    updatedUser.lastName = user.lastName ?? originalUser.lastName
                    onResult(.success(updatedUser as! T))
                } else {
                    onResult(.success(result))
                }
            } catch {
                let responseString = String(data: data, encoding: .utf8)
                onResult(.failure(.networkError("Une erreur réseau s'est produite : \(error.localizedDescription) : \(responseString ?? "No response data")")))
            }
        case .failure(let error):
            if let data = response.data {
                let responseString = String(data: data, encoding: .utf8)
                onResult(.failure(.networkError("Une erreur réseau s'est produite : \(error.localizedDescription) : \(responseString ?? "No response data")")))
            } else {
                onResult(.failure(.networkError("Une erreur réseau s'est produite : \(error.localizedDescription)")))
            }
        }
    }
    
    /// Returns the headers required for the API requests.
    /// - Returns: A `HTTPHeaders` object containing the necessary headers.
    private func getHeaders() -> HTTPHeaders {
        return [
            APIConstants.Headers.applicationID: ParseConfig.applicationID,
            APIConstants.Headers.clientKey: ParseConfig.clientKey,
            APIConstants.Headers.contentType: "application/json"
        ]
    }
    
    /// Saves a draw result to Back4App.
    /// - Parameters:
    ///   - drawResult: The `DrawResult` to save.
    ///   - completion: A closure to handle the result of the save operation.
    func saveDrawResult(_ drawResult: DrawResult, completion: @escaping (Result<DrawResult, AppError>) -> Void) {
        drawResult.save { result in
            switch result {
            case .success(let savedResult):
                completion(.success(savedResult))
            case .failure(let error):
                completion(.failure(.networkError(error.localizedDescription)))
            }
        }
    }

    /// Loads draw results from Back4App filtered by question.
    /// - Parameters:
    ///   - question: The `Pointer<Question>` representing the current question.
    ///   - completion: A closure to handle the result of the load operation.
    func loadDrawResults(for question: Pointer<Question>, completion: @escaping (Result<[DrawResult], AppError>) -> Void) {
        var query = DrawResult.query(QueryKey.question == question)
        query = query.order([.descending(QueryKey.createdAt)])
        query.find { result in
            switch result {
            case .success(let results):
                completion(.success(results))
            case .failure(let error):
                completion(.failure(.networkError(error.localizedDescription)))
            }
        }
    }
}

