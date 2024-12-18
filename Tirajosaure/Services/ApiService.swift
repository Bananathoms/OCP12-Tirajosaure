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
                        onResult(.failure(.networkError("\(LocalizedString.failedToRequestPasswordReset.localized): \(errorMessage)")))
                    } else {
                        onResult(.failure(.networkError("\(LocalizedString.failedToRequestPasswordReset.localized): \(error.localizedDescription)")))
                    }
                }
            }
    }
    
    // MARK: - Question Methods
    
    /// Fetches questions associated with a specific user from the Parse server.
    /// - Parameters:
    ///   - userId: The ID of the user whose questions are to be fetched.
    ///   - completion: A closure to handle the result of the fetch operation.
    func fetchQuestions(for userPointer: Pointer<User>, completion: @escaping (Result<[Question], AppError>) -> Void) {
        let parameters = APIConstants.Parameters.wherePointer(type: APIConstants.Parameters.UserPointer(), objectId: userPointer.objectId)
        let url = ParseConfig.serverURL + APIConstants.Endpoints.questionsBase

        AF.request(url, parameters: parameters, headers: getHeaders()).validate().responseData { response in
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
            completion(.failure(.validationError(LocalizedString.invalidQuestionID.localized)))
            return
        }
        let url = ParseConfig.serverURL + APIConstants.Endpoints.questionById.replacingOccurrences(of: FormatConstants.idPlaceholder, with: objectId)
        let headers = getHeaders()
        
        AF.request(url, method: .delete, headers: headers).validate().responseData { response in
            self.handleDeleteResponse(response, onResult: completion)
        }
    }
    
    // MARK: - DrawResult Methods
    
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
    
    /// Deletes a `DrawResult` object from the Parse server.
    /// - Parameters:
    ///   - drawResult: The `DrawResult` object to be deleted.
    ///   - completion: A closure to handle the result of the delete operation, returning a `Result` with either `Void` ou an `AppError`.
    func deleteDrawResult(_ drawResult: DrawResult, completion: @escaping (Result<Void, AppError>) -> Void) {
        guard let objectId = drawResult.objectId else {
            completion(.failure(.validationError(ErrorMessage.invalidQuestionID.localized)))
            return
        }
        let url = ParseConfig.serverURL + APIConstants.Endpoints.drawResultById.replacingOccurrences(of: FormatConstants.idPlaceholder, with: objectId)
        let headers = getHeaders()

        AF.request(url, method: .delete, headers: headers).validate().responseData { response in
            self.handleDeleteResponse(response, onResult: completion)
        }
    }

    
    // MARK: - Event Methods
    
    /// Fetches events for a specific user.
    /// - Parameters:
    ///   - userPointer: A pointer to the user whose events are to be fetched.
    ///   - completion: A closure to handle the result of the fetch operation.
    func fetchEvents(for userPointer: Pointer<User>, completion: @escaping (Result<[Event], AppError>) -> Void) {
        let parameters = APIConstants.Parameters.wherePointer(type: APIConstants.Parameters.UserPointer(), objectId: userPointer.objectId)
        let url = ParseConfig.serverURL + APIConstants.Endpoints.eventBase
        
        AF.request(url, parameters: parameters, headers: getHeaders()).validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: ParseResponse<Event>.self, transform: { $0.results }, onResult: completion)
        }
    }
    
    /// Saves an event to the Parse server.
    /// - Parameters:
    ///   - event: The `Event` object to be saved.
    ///   - originalObject: An optional original object to compare with.
    ///   - completion: A closure to handle the result of the save operation.
    func saveEvent(_ event: Event, completion: @escaping (Result<Event, AppError>) -> Void) {
        let url = ParseConfig.serverURL + APIConstants.Endpoints.eventBase
        let headers = getHeaders()
        
        var parameters: [String: Any] = [
            APIConstants.Parameters.title: event.title,
            APIConstants.Parameters.equitableDistribution: event.equitableDistribution,
            APIConstants.Parameters.user: APIConstants.Parameters.pointerParams(className: APIConstants.Parameters.UserPointer().className, objectId: event.user.objectId),
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
        
        request.validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: SaveResponse.self, transform: { saveResponse in
                var savedEvent = event
                savedEvent.objectId = saveResponse.objectId ?? event.objectId
                savedEvent.createdAt = saveResponse.createdAt != nil ? DateFormatter.iso8601Full.date(from: saveResponse.createdAt!) : event.createdAt
                savedEvent.updatedAt = saveResponse.updatedAt != nil ? DateFormatter.iso8601Full.date(from: saveResponse.updatedAt!) : event.updatedAt
                return savedEvent
            }, onResult: completion)
        }
    }
    
    /// Deletes an event from the Parse server.
    /// - Parameters:
    ///   - event: The `Event` object to be deleted.
    ///   - completion: A closure to handle the result of the delete operation.
    func deleteEvent(_ event: Event, completion: @escaping (Result<Void, AppError>) -> Void) {
        guard let objectId = event.objectId else {
            completion(.failure(.validationError(ErrorMessage.invalidEventID.localized)))
            return
        }
        let url = ParseConfig.serverURL + APIConstants.Endpoints.eventById.replacingOccurrences(of: FormatConstants.idPlaceholder, with: objectId)
        let headers = getHeaders()
        AF.request(url, method: .delete, headers: headers).validate().responseData { response in
            self.handleDeleteResponse(response, onResult: completion)
        }
    }
    
    // MARK: - TeamsDraw Methods
    
    /// Saves a TeamsDraw to the Parse server.
    /// - Parameters:
    ///   - teamsDraw: The `TeamsDraw` object to be saved.
    ///   - completion: A closure to handle the result of the save operation.
    func saveTeamsDraw(_ teamsDraw: TeamsDraw, completion: @escaping (Result<TeamsDraw, AppError>) -> Void) {
        let url = ParseConfig.serverURL + APIConstants.Endpoints.teamsDrawBase
        let headers = getHeaders()

        var parameters: [String: Any] = [
            APIConstants.Parameters.date: APIConstants.Parameters.dateParameter(from: teamsDraw.date),
            APIConstants.Parameters.event: APIConstants.Parameters.pointerParams(className: APIConstants.Parameters.EventPointer().className, objectId: teamsDraw.event.objectId)
        ]

        var request: DataRequest
        if let objectId = teamsDraw.objectId {
            parameters[DefaultValues.objectId] = objectId
            request = AF.request("\(url)/\(objectId)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        } else {
            request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        }

        request.validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: SaveResponse.self, originalObject: teamsDraw, transform: { saveResponse in
                var savedTeamsDraw = teamsDraw
                savedTeamsDraw.objectId = saveResponse.objectId
                savedTeamsDraw.createdAt = DateFormatter.iso8601Full.date(from: saveResponse.createdAt ?? DefaultValues.emptyString) ?? Date()
                savedTeamsDraw.updatedAt = saveResponse.updatedAt != nil ? DateFormatter.iso8601Full.date(from: saveResponse.updatedAt!) : nil
                return savedTeamsDraw
            }, onResult: completion)
        }
    }
    
    /// Fetches TeamsDraw objects for a specific event.
    /// - Parameters:
    ///   - event: The `Event` object whose draws are to be fetched.
    ///   - completion: A closure to handle the result of the fetch operation.
    func fetchTeamsDraw(for eventPointer: Pointer<Event>, completion: @escaping (Result<[TeamsDraw], AppError>) -> Void) {
        let url = ParseConfig.serverURL + APIConstants.Endpoints.teamsDrawBase
        let parameters = APIConstants.Parameters.wherePointer(type: APIConstants.Parameters.EventPointer(), objectId: eventPointer.objectId)
        let headers = getHeaders()

        AF.request(url, parameters: parameters, headers: headers).validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: ParseResponse<TeamsDraw>.self, transform: { $0.results }, onResult: completion)
        }
    }
    
    func deleteTeamsDraw(_ teamsDraw: TeamsDraw, completion: @escaping (Result<Void, AppError>) -> Void) {
        guard let objectId = teamsDraw.objectId else {
            completion(.failure(.validationError(ErrorMessage.invalidTeamsDrawID.localized)))
            return
        }
        let url = ParseConfig.serverURL + APIConstants.Endpoints.teamsDrawById.replacingOccurrences(of: FormatConstants.objectIdPlaceholder, with: objectId)
        let headers = getHeaders()
        
        AF.request(url, method: .delete, headers: headers).validate().responseData { response in
            self.handleDeleteResponse(response, onResult: completion)
        }
    }

    /// Saves a TeamResult to the Parse server.
    /// - Parameters:
    ///   - teamResult: The `TeamResult` object to be saved.
    ///   - completion: A closure to handle the result of the save operation.
    func saveTeamResult(_ teamResult: TeamResult, completion: @escaping (Result<TeamResult, AppError>) -> Void) {
        let url = ParseConfig.serverURL + APIConstants.Endpoints.teamResultBase
        let headers = getHeaders()

        var parameters: [String: Any] = [
            APIConstants.Parameters.name: teamResult.name,
            APIConstants.Parameters.members: teamResult.members,
            APIConstants.Parameters.draw: APIConstants.Parameters.pointerParams(className: APIConstants.Parameters.TeamsDrawPointer().className, objectId: teamResult.draw.objectId)
        ]

        if let objectId = teamResult.objectId {
            parameters[DefaultValues.objectId] = objectId
        }

        let request: DataRequest
        if let objectId = teamResult.objectId {
            request = AF.request("\(url)/\(objectId)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        } else {
            request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        }

        request.validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: SaveResponse.self, originalObject: teamResult, transform: { saveResponse in
                var savedTeamResult = teamResult
                savedTeamResult.objectId = saveResponse.objectId
                savedTeamResult.createdAt = DateFormatter.iso8601Full.date(from: saveResponse.createdAt ?? DefaultValues.emptyString) ?? Date()
                savedTeamResult.updatedAt = saveResponse.updatedAt != nil ? DateFormatter.iso8601Full.date(from: saveResponse.updatedAt!) : nil
                return savedTeamResult
            }, onResult: completion)
        }
    }

    
    /// Fetches TeamResult objects for a specific TeamsDraw.
    /// - Parameters:
    ///   - teamsDraw: The `TeamsDraw` object whose results are to be fetched.
    ///   - completion: A closure to handle the result of the fetch operation.
    func fetchTeamResults(for teamsDraw: TeamsDraw, completion: @escaping (Result<[TeamResult], AppError>) -> Void) {
        let url = ParseConfig.serverURL + APIConstants.Endpoints.teamResultBase
        let parameters = APIConstants.Parameters.wherePointer(type: APIConstants.Parameters.TeamsDrawPointer(), objectId: teamsDraw.objectId ?? DefaultValues.emptyString)
        let headers = getHeaders()

        AF.request(url, parameters: parameters, headers: headers).validate().responseData { response in
            self.handleAlamofireResponse(response, ofType: ParseResponse<TeamResult>.self, transform: { $0.results }, onResult: completion)
        }
    }


    func deleteTeamResult(_ teamResult: TeamResult, completion: @escaping (Result<Void, AppError>) -> Void) {
        guard let objectId = teamResult.objectId else {
            completion(.failure(.validationError(ErrorMessage.invalidTeamResultID.localized)))
            return
        }
        let url = ParseConfig.serverURL + APIConstants.Endpoints.teamResultById.replacingOccurrences(of: FormatConstants.objectIdPlaceholder, with: objectId)
        let headers = getHeaders()

        AF.request(url, method: .delete, headers: headers).validate().responseData { response in
            self.handleDeleteResponse(response, onResult: completion)
        }
    }

    // MARK: - Response Handling
    
    /// Handles the Alamofire response for various types of requests.
    /// - Parameters:
    ///   - response: The response received from Alamofire.
    ///   - ofType: The type of the response object expected.
    ///   - originalObject: The original object being saved, if any.
    ///   - transform: An optional closure to transform the response object.
    ///   - onResult: A closure to handle the result of the response, returning a `Result` with either the transformed object or an `AppError`.
    private func handleAlamofireResponse<T: Decodable, U>(_ response: AFDataResponse<Data>, ofType: T.Type, originalObject: Any? = nil, transform: ((T) -> U)? = nil, onResult: @escaping (Result<U, AppError>) -> Void) {
        switch response.result {
        case .success(let data):
            if data.isEmpty, T.self == VoidResponse.self {
                onResult(.success(VoidResponse() as! U))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

                if T.self == SaveResponse.self, var event = originalObject as? Event {
                    let saveResponse = try? decoder.decode(SaveResponse.self, from: data)
                    if let saveResponse = saveResponse {
                        event.updatedAt = DateFormatter.iso8601Full.date(from: saveResponse.updatedAt ?? DefaultValues.emptyString)
                        onResult(.success(event as! U))
                        return
                    } else {
                        _ = String(data: data, encoding: .utf8)
                        onResult(.failure(.networkError("\(ErrorMessage.networkDataMissing.localized)")))
                        return
                    }
                }

                let result = try decoder.decode(T.self, from: data)

                if let transform = transform {
                    onResult(.success(transform(result)))
                } else {
                    onResult(.success(result as! U))
                }
            } catch {
                let responseString = String(data: data, encoding: .utf8)
                onResult(.failure(.networkError(String(format: ErrorMessage.networkErrorWithResponse.localized, error.localizedDescription, responseString ?? ErrorMessage.noResponseData.localized))))
            }
        case .failure(let error):
            if let data = response.data {
                let responseString = String(data: data, encoding: .utf8)
                onResult(.failure(.networkError(String(format: ErrorMessage.networkErrorWithResponse.localized, error.localizedDescription, responseString ?? ErrorMessage.noResponseData.localized))))
            } else {
                onResult(.failure(.networkError(String(format: ErrorMessage.networkErrorDescription.localized, error.localizedDescription))))
            }
        }
    }

    /// Handles the response for delete requests.
    /// - Parameters:
    ///   - response: The response received from Alamofire.
    ///   - onResult: A closure to handle the result of the delete operation, returning a `Result` with either `Void` or an `AppError`.
    private func handleDeleteResponse(_ response: AFDataResponse<Data>, onResult: @escaping (Result<Void, AppError>) -> Void) {
        switch response.result {
        case .success:
            onResult(.success(()))
        case .failure(let error):
            if let statusCode = response.response?.statusCode, statusCode == 404 {
                onResult(.success(()))
            } else {
                let responseString = String(data: response.data ?? Data(), encoding: .utf8)
                onResult(.failure(.networkError(String(format: ErrorMessage.networkErrorWithResponse.localized, error.localizedDescription, responseString ?? ErrorMessage.noResponseData.localized))))
            }
        }
    }

    // MARK: - Utility Methods
    
    /// Retrieves the headers required for making API requests.
    /// - Returns: A dictionary containing the headers.
    private func getHeaders() -> HTTPHeaders {
        return [
            APIConstants.Headers.applicationID.rawValue: ParseConfig.applicationID,
            APIConstants.Headers.clientKey.rawValue: ParseConfig.clientKey,
            APIConstants.Headers.contentType.rawValue: ParseConfig.contentType
        ]
    }
}
