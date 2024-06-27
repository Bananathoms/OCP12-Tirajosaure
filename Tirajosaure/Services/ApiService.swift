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
import Foundation
import ParseSwift
import SwiftUI
import Alamofire

/// A service class responsible for handling API requests.
class ApiService {
    static var current = ApiService()
    
    init() {}

    // MARK: - User Methods
    
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
                self.handleAlamofireResponse(response, ofType: User.self, onResult: onResult)
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
                self.handleAlamofireResponse(response, ofType: User.self, onResult: onResult)
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
    
    // MARK: - Question Methods
    
    /// Fetches questions associated with a specific user from the Parse server.
    /// - Parameters:
    ///   - userId: The ID of the user whose questions are to be fetched.
    ///   - completion: A closure to handle the result of the fetch operation.
    func fetchQuestions(for userId: String, completion: @escaping (Result<[Question], AppError>) -> Void) {
        let url = ParseConfig.serverURL + APIConstants.Endpoints.questionsBase
        let parameters = wherePointer(type: APIConstants.Parameters.UserPointer(), objectId: userId)
        let headers = getHeaders()
        
        AF.request(url, parameters: parameters, headers: headers).validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: ParseResponse<Question>.self, transform: { $0.results }, onResult: completion)
        }
    }
    
    /// Saves a `Question` object to the Parse server.
    /// - Parameters:
    ///   - question: The `Question` object to be saved.
    ///   - completion: A closure to handle the result of the save operation.
    func saveQuestion(_ question: Question, completion: @escaping (Result<Question, AppError>) -> Void) {
        let url = ParseConfig.serverURL + APIConstants.Endpoints.questionsBase
        let headers = getHeaders()
        
        var parameters: [String: Any] = [
            APIConstants.Parameters.title: question.title,
            APIConstants.Parameters.options: question.options,
            APIConstants.Parameters.user: pointerParams(className: APIConstants.Parameters.UserPointer().className, objectId: question.user.objectId)
        ]
        
        if let objectId = question.objectId {
            parameters[DefaultValues.objectId] = objectId
        }
        
        let request: DataRequest
        if let objectId = question.objectId {
            request = AF.request("\(url)/\(objectId)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        } else {
            request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        }
        
        request.validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: SaveResponse.self, transform: { saveResponse in
                var savedQuestion = question
                savedQuestion.objectId = saveResponse.objectId ?? question.objectId
                savedQuestion.createdAt = saveResponse.createdAt != nil ? DateFormatter.iso8601Full.date(from: saveResponse.createdAt!) : question.createdAt
                savedQuestion.updatedAt = saveResponse.updatedAt != nil ? DateFormatter.iso8601Full.date(from: saveResponse.updatedAt!) : question.updatedAt
                return savedQuestion
            }, onResult: completion)
        }
    }


    
    /// Deletes a `Question` object from the Parse server.
    /// - Parameters:
    ///   - question: The `Question` object to be deleted.
    ///   - completion: A closure to handle the result of the delete operation.
    func deleteQuestion(_ question: Question, completion: @escaping (Result<Void, AppError>) -> Void) {
        guard let objectId = question.objectId else {
            completion(.failure(.validationError(ErrorMessage.invalidQuestionID.localized)))
            return
        }
        let url = ParseConfig.serverURL + APIConstants.Endpoints.questionById.replacingOccurrences(of: FormatConstants.objectIdPlaceholder, with: objectId)
        let headers = getHeaders()
        
        AF.request(url, method: .delete, headers: headers).validate().responseData { response in
            self.handleDeleteResponse(response, onResult: completion)
        }
    }
    
    /// Saves a draw result to the Parse server.
    /// - Parameters:
    ///   - drawResult: The `DrawResult` object to be saved.
    ///   - completion: A closure to handle the result of the save operation.
    func saveDrawResult(_ drawResult: DrawResult, completion: @escaping (Result<DrawResult, AppError>) -> Void) {
        let url = ParseConfig.serverURL + APIConstants.Endpoints.drawResultBase
        let headers = getHeaders()
        let parameters: [String: Any] = [
            APIConstants.Parameters.option: drawResult.option,
            APIConstants.Parameters.date: dateParameter(from: drawResult.date),
            APIConstants.Parameters.question: pointerParams(className: APIConstants.Parameters.QuestionPointer().className, objectId: drawResult.question.objectId)
         ]
        
        let request: DataRequest
        if let objectId = drawResult.objectId {
            request = AF.request("\(url)/\(objectId)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        } else {
            request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        }
        
        request.validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: DrawResult.self, onResult: completion)
        }
    }
    
    /// Loads draw results from the Parse server filtered by question.
    /// - Parameters:
    ///   - question: The `Pointer<Question>` representing the current question.
    ///   - completion: A closure to handle the result of the load operation.
    func loadDrawResults(for question: Pointer<Question>, completion: @escaping (Result<[DrawResult], AppError>) -> Void) {
        let url = ParseConfig.serverURL + APIConstants.Endpoints.drawResultBase
        let parameters = wherePointer(type: APIConstants.Parameters.QuestionPointer(), objectId: question.objectId)
        let headers = getHeaders()
        
        AF.request(url, parameters: parameters, headers: headers).validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: ParseResponse<DrawResult>.self, transform: { $0.results }, onResult: completion)
        }
    }

    
    // MARK: - Event Methods
    
    func saveEvent(_ event: Event, originalObject: Event? = nil, completion: @escaping (Result<Event, AppError>) -> Void) {
        let url = ParseConfig.serverURL + APIConstants.Endpoints.eventBase
        let headers = getHeaders()

        var parameters: [String: Any] = [
            APIConstants.Parameters.title: event.title,
            APIConstants.Parameters.equitableDistribution: event.equitableDistribution,
            APIConstants.Parameters.user: pointerParams(className: "_User", objectId: event.user.objectId),
            APIConstants.Parameters.teams: event.teams,
            APIConstants.Parameters.members: event.members
        ]

        if let objectId = event.objectId {
            parameters[DefaultValues.objectId] = objectId
        }

        let request: DataRequest
        if let objectId = event.objectId {
            request = AF.request("\(url)/\(objectId)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        } else {
            request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        }

        print("Sending request to URL: \(request)")
        request.validate().responseData { response in
            print("Received response: \(response)")
            self.handleAlamofireResponse(response, ofType: SaveResponse.self, originalObject: event, onResult: completion)
        }
    }
    
    func fetchEvents(for userPointer: Pointer<User>, completion: @escaping (Result<[Event], AppError>) -> Void) {
        let parameters = wherePointer(type: APIConstants.Parameters.UserPointer(), objectId: userPointer.objectId)
        let url = ParseConfig.serverURL + APIConstants.Endpoints.eventBase
        
        AF.request(url, parameters: parameters, headers: getHeaders()).validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: ParseResponse<Event>.self, transform: { $0.results }, onResult: completion)
        }
    }
    
    func deleteEvent(_ event: Event, completion: @escaping (Result<Void, AppError>) -> Void) {
        guard let objectId = event.objectId else {
            completion(.failure(.validationError("Invalid event ID")))
            return
        }
        let url = ParseConfig.serverURL + APIConstants.Endpoints.eventById.replacingOccurrences(of: "{id}", with: objectId)
        let headers = getHeaders()

        AF.request(url, method: .delete, headers: headers).validate().responseData { response in
            self.handleDeleteResponse(response, onResult: completion)
        }
    }
    
    // MARK: - Response Handling
    

    private func handleAlamofireResponse<T: Decodable, U>(_ response: AFDataResponse<Data>, ofType: T.Type, originalObject: Any? = nil, transform: ((T) -> U)? = nil, onResult: @escaping (Result<U, AppError>) -> Void) {
        print("Handling Alamofire response...")

        switch response.result {
        case .success(let data):
            print("Response data received: \(data)")

            if data.isEmpty, T.self == VoidResponse.self {
                print("Empty data and expecting VoidResponse")
                onResult(.success(VoidResponse() as! U))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                print("Starting to decode response data...")

                if T.self == SaveResponse.self, var event = originalObject as? Event {
                    print("Decoding SaveResponse...")
                    let saveResponse = try? decoder.decode(SaveResponse.self, from: data)
                    if let saveResponse = saveResponse {
                        print("Successfully decoded SaveResponse: \(saveResponse)")
                        event.updatedAt = DateFormatter.iso8601Full.date(from: saveResponse.updatedAt ?? "")
                        onResult(.success(event as! U))
                        return
                    } else {
                        let responseString = String(data: data, encoding: .utf8)
                        print("SaveResponse Decoding error: Les données n’ont pas pu être lues car elles sont introuvables.")
                        print("Response data: \(responseString ?? "No response data")")
                        onResult(.failure(.networkError("Une erreur réseau s'est produite : Les données n’ont pas pu être lues car elles sont introuvables.")))
                        return
                    }
                }

                let result = try decoder.decode(T.self, from: data)
                print("Successfully decoded data: \(result)")

                if let transform = transform {
                    onResult(.success(transform(result)))
                } else {
                    onResult(.success(result as! U))
                }
            } catch {
                let responseString = String(data: data, encoding: .utf8)
                print("Decoding error: \(error.localizedDescription)")
                print("Response data: \(responseString ?? "No response data")")
                onResult(.failure(.networkError("Une erreur réseau s'est produite : \(error.localizedDescription) : \(responseString ?? "No response data")")))
            }
        case .failure(let error):
            print("Network error: \(error.localizedDescription)")
            if let data = response.data {
                let responseString = String(data: data, encoding: .utf8)
                print("Response data: \(responseString ?? "No response data")")
                onResult(.failure(.networkError("Une erreur réseau s'est produite : \(error.localizedDescription) : \(responseString ?? "No response data")")))
            } else {
                onResult(.failure(.networkError("Une erreur réseau s'est produite : \(error.localizedDescription)")))
            }
        }
    }


    private func handleDeleteResponse(_ response: AFDataResponse<Data>, onResult: @escaping (Result<Void, AppError>) -> Void) {
        switch response.result {
        case .success:
            onResult(.success(()))
        case .failure(let error):
            onResult(.failure(.networkError(error.localizedDescription)))
        }
    }

    // MARK: - Utility Methods
    
    private func getHeaders() -> HTTPHeaders {
        return [
            APIConstants.Headers.applicationID: ParseConfig.applicationID,
            APIConstants.Headers.clientKey: ParseConfig.clientKey,
            APIConstants.Headers.contentType: ParseConfig.contentType
        ]
    }
    
    
    
}
