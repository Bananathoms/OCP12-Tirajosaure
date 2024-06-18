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

/// A service class responsible for handling API requests related to user authentication and management.
class ApiService {
    static var current = ApiService()
    
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
                self.handleAlamofireResponse(response, originalUser: user, onResult: onResult)
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
                self.handleAlamofireResponse(response, originalUser: User(username: email, email: email, password: password), onResult: onResult)
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
                        onResult(.failure(.networkError("\(ErrorMessage.failedToRequestPasswordReset.rawValue): \(errorMessage)")))
                    } else {
                        onResult(.failure(.networkError("\(ErrorMessage.failedToRequestPasswordReset.rawValue): \(error.localizedDescription)")))
                    }
                }
            }
    }
    
    /// Handles the response from an Alamofire request.
    /// - Parameters:
    ///   - response: The `AFDataResponse<Data>` object containing the response data.
    ///   - originalUser: The original `User` object passed to the request.
    ///   - onResult: A closure to handle the result of the response, returning a `Result` with either a `User` or an `AppError`.
    private func handleAlamofireResponse(_ response: AFDataResponse<Data>, originalUser: User, onResult: (Result<User, AppError>) -> Void) {
        switch response.result {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                var user = try decoder.decode(User.self, from: data)
                user.firstName = user.firstName ?? originalUser.firstName
                user.lastName = user.lastName ?? originalUser.lastName
                onResult(.success(user))
            } catch {
                let responseString = String(data: data, encoding: .utf8)
                onResult(.failure(.networkError("\(ErrorMessage.failedToDecodeJSONResponse.rawValue): \(responseString ?? ErrorMessage.defaultMessage.rawValue)")))
            }
        case .failure(let error):
            if let data = response.data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                    let parseError = try decoder.decode(ParseError.self, from: data)
                    onResult(.failure(.parseError(parseError.message)))
                } catch {
                    let responseString = String(data: data, encoding: .utf8)
                    onResult(.failure(.networkError("\(ErrorMessage.failedToDecodeJSONResponse.rawValue): \(responseString ?? ErrorMessage.defaultMessage.rawValue)")))
                }
            } else {
                onResult(.failure(.networkError(error.localizedDescription)))
            }
        }
    }

    
    /// Returns the headers required for the API requests.
    /// - Returns: A `HTTPHeaders` object containing the necessary headers.
    private func getHeaders() -> HTTPHeaders {
        return [
            APIConstants.Headers.applicationID: ParseConfig.applicationID,
            APIConstants.Headers.clientKey: ParseConfig.clientKey,
            APIConstants.Headers.contentType: ParseConfig.contentType
        ]
    }
}
