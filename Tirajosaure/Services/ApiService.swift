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
    
    init() {}
    
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
        let url = ParseConfig.serverURL + APIConstants.Endpoints.questionsBase
        let parameters = wherePointer(type: APIConstants.Parameters.UserPointer(), objectId: userId)
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
            self.handleAlamofireResponse(response, ofType: SaveResponse.self) { result in
                switch result {
                case .success(let saveResponse):
                    var savedQuestion = question
                    savedQuestion.objectId = saveResponse.objectId
                    savedQuestion.createdAt = DateFormatter.iso8601Full.date(from: saveResponse.createdAt)
                    savedQuestion.updatedAt = saveResponse.updatedAt != nil ? DateFormatter.iso8601Full.date(from: saveResponse.updatedAt!) : nil
                    completion(.success(savedQuestion))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
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
            if response.data?.isEmpty ?? true {
                completion(.success(()))
                return
            }
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
            self.handleAlamofireResponse(response, ofType: ParseResponse<DrawResult>.self) { result in
                switch result {
                case .success(let parseResponse):
                    completion(.success(parseResponse.results))
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
            if data.isEmpty, T.self == VoidResponse.self {
                onResult(.success(VoidResponse() as! T))
                return
            }
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
            APIConstants.Headers.contentType: ParseConfig.contentType
        ]
    }
    
    private func handleDeleteResponse(_ response: AFDataResponse<Data>, onResult: @escaping (Result<Void, AppError>) -> Void) {
        switch response.result {
        case .success:
            onResult(.success(()))
        case .failure(let error):
            onResult(.failure(.networkError(error.localizedDescription)))
        }
    }
    
    // MARK: - Event Methods
    
    func saveEvent(_ event: Event, completion: @escaping (Result<Event, AppError>) -> Void) {
        let url = ParseConfig.serverURL + APIConstants.Endpoints.eventBase
        let headers = getHeaders()

        let parameters: [String: Any] = [
            APIConstants.Parameters.title: event.title,
            APIConstants.Parameters.equitableDistribution: event.equitableDistribution,
            APIConstants.Parameters.user: APIConstants.Parameters.pointerParams(className: "_User", objectId: event.user.objectId)
        ]

        let request: DataRequest
        if let objectId = event.objectId {
            request = AF.request("\(url)/\(objectId)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        } else {
            request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        }

        request.validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: SaveResponse.self) { result in
                switch result {
                case .success(let saveResponse):
                    var savedEvent = event
                    savedEvent.objectId = saveResponse.objectId
                    savedEvent.createdAt = DateFormatter.iso8601Full.date(from: saveResponse.createdAt)
                    completion(.success(savedEvent))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchEvents(for userPointer: Pointer<User>, completion: @escaping (Result<[Event], AppError>) -> Void) {
        let parameters = APIConstants.Parameters.wherePointer(type: APIConstants.Parameters.UserPointer(), objectId: userPointer.objectId)
        let url = ParseConfig.serverURL + APIConstants.Endpoints.eventBase
        
        AF.request(url, parameters: parameters, headers: getHeaders()).validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: ParseResponse<Event>.self) { result in
                switch result {
                case .success(let parseResponse):
                    completion(.success(parseResponse.results))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
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
    
    // MARK: - Team Methods
    
    func saveTeam(_ team: Team, completion: @escaping (Result<Team, AppError>) -> Void) {
        let url = ParseConfig.serverURL + APIConstants.Endpoints.teamBase
        let headers = getHeaders()

        let parameters: [String: Any] = [
            APIConstants.Parameters.name: team.name,
            APIConstants.Parameters.event: APIConstants.Parameters.pointerParams(className: "Event", objectId: team.event.objectId)
        ]

        let request: DataRequest
        if let objectId = team.objectId {
            request = AF.request("\(url)/\(objectId)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        } else {
            request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        }

        request.validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: Team.self, onResult: completion)
        }
    }
    

    func fetchTeams(for eventPointer: Pointer<Event>, completion: @escaping (Result<[Team], AppError>) -> Void) {
        let parameters = APIConstants.Parameters.wherePointer(type: APIConstants.Parameters.EventPointer(), objectId: eventPointer.objectId)
        let url = ParseConfig.serverURL + APIConstants.Endpoints.teamBase
        
        AF.request(url, parameters: parameters, headers: getHeaders()).validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: ParseResponse<Team>.self) { result in
                switch result {
                case .success(let parseResponse):
                    completion(.success(parseResponse.results))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func deleteTeam(_ team: Team, completion: @escaping (Result<Void, AppError>) -> Void) {
        guard let objectId = team.objectId else {
            completion(.failure(.validationError("Invalid team ID")))
            return
        }
        let url = ParseConfig.serverURL + APIConstants.Endpoints.teamById.replacingOccurrences(of: "{id}", with: objectId)
        let headers = getHeaders()

        AF.request(url, method: .delete, headers: headers).validate().responseData { response in
            self.handleDeleteResponse(response, onResult: completion)
        }
    }
    
    // MARK: - Member Methods
    
    func saveMember(_ member: Member, completion: @escaping (Result<Member, AppError>) -> Void) {
        let url = ParseConfig.serverURL + APIConstants.Endpoints.memberBase
        let headers = getHeaders()

        var parameters: [String: Any] = [
            APIConstants.Parameters.name: member.name,
            APIConstants.Parameters.event: APIConstants.Parameters.pointerParams(className: "Event", objectId: member.event.objectId)
        ]

        if let team = member.team {
            parameters[APIConstants.Parameters.team] = APIConstants.Parameters.pointerParams(className: "Team", objectId: team.objectId)
        }

        let request: DataRequest
        if let objectId = member.objectId {
            request = AF.request("\(url)/\(objectId)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        } else {
            request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        }

        request.validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: Member.self, onResult: completion)
        }
    }
    
    /// Fetches members associated with a specific event from the Parse server.
    /// - Parameters:
    ///   - event: The `Pointer<Event>` object whose members are to be fetched.
    ///   - completion: A closure to handle the result of the fetch operation.
    func fetchMembers(for event: Pointer<Event>, completion: @escaping (Result<[Member], AppError>) -> Void) {
        let parameters = APIConstants.Parameters.wherePointer(type: APIConstants.Parameters.EventPointer(), objectId: event.objectId)
        let headers = getHeaders()

        AF.request(ParseConfig.serverURL + APIConstants.Endpoints.memberBase, parameters: parameters, headers: headers).validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: ParseResponse<Member>.self) { result in
                switch result {
                case .success(let parseResponse):
                    completion(.success(parseResponse.results))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func deleteMember(_ member: Member, completion: @escaping (Result<Void, AppError>) -> Void) {
        guard let objectId = member.objectId else {
            completion(.failure(.validationError("Invalid member ID")))
            return
        }
        let url = ParseConfig.serverURL + APIConstants.Endpoints.memberById.replacingOccurrences(of: "{id}", with: objectId)
        let headers = getHeaders()

        AF.request(url, method: .delete, headers: headers).validate().responseData { response in
            self.handleDeleteResponse(response, onResult: completion)
        }
    }
}
