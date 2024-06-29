//
//  TeamsDrawService.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 28/06/2024.
//

import Foundation
import ParseSwift

/// Service class responsible for handling operations related to TeamsDraw and TeamResult.
class TeamsDrawService {
    static let shared = TeamsDrawService()
    private let apiService = ApiService.current

    private init() {}

    /// Saves a TeamsDraw object to the Parse server.
    /// - Parameters:
    ///   - teamsDraw: The TeamsDraw object to be saved.
    ///   - completion: A closure to handle the result of the save operation, returning un `Result` with either a `TeamsDraw` ou un `AppError`.
    func saveTeamsDraw(_ teamsDraw: TeamsDraw, completion: @escaping (Result<TeamsDraw, AppError>) -> Void) {
        apiService.saveTeamsDraw(teamsDraw, completion: completion)
    }

    /// Fetches TeamsDraw objects associated with a specific event from the Parse server.
    /// - Parameters:
    ///   - event: The Event object for which the TeamsDraw objects are to be fetched.
    ///   - completion: A closure to handle the result of the fetch operation, returning un `Result` with either a list of `TeamsDraw` objects ou un `AppError`.
    func fetchTeamsDraw(for event: Event, completion: @escaping (Result<[TeamsDraw], AppError>) -> Void) {
        let eventPointer = Pointer<Event>(objectId: event.objectId ?? DefaultValues.emptyString)
        apiService.fetchTeamsDraw(for: eventPointer, completion: completion)
    }

    /// Deletes TeamsDraw objects and their associated TeamResults associated with a specific event from the Parse server.
    /// - Parameters:
    ///   - eventPointer: The `Pointer<Event>` representing the current event.
    ///   - completion: A closure to handle the result of the delete operation, returning un `Result` with either `Void` ou un `AppError`.
    func deleteTeamsDraws(for eventPointer: Pointer<Event>, completion: @escaping (Result<Void, AppError>) -> Void) {
        apiService.fetchTeamsDraw(for: eventPointer) { [weak self] result in
            switch result {
            case .success(let teamsDraws):
                let group = DispatchGroup()
                var deletionError: AppError?

                for teamsDraw in teamsDraws {
                    group.enter()
                    self?.deleteTeamsDrawAndResults(teamsDraw) { result in
                        if case .failure(let error) = result {
                            deletionError = error
                        }
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    if let error = deletionError {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Saves a TeamResult object to the Parse server.
    /// - Parameters:
    ///   - teamResult: The TeamResult object to be saved.
    ///   - completion: A closure to handle the result of the save operation, returning un `Result` with either a `TeamResult` ou un `AppError`.
    func saveTeamResult(_ teamResult: TeamResult, completion: @escaping (Result<TeamResult, AppError>) -> Void) {
        apiService.saveTeamResult(teamResult, completion: completion)
    }

    /// Fetches TeamResult objects associated with a specific TeamsDraw from the Parse server.
    /// - Parameters:
    ///   - teamsDraw: The TeamsDraw object for which the TeamResult objects are to be fetched.
    ///   - completion: A closure to handle the result of the fetch operation, returning un `Result` with either a list of `TeamResult` objects ou un `AppError`.
    func fetchTeamResults(for teamsDraw: TeamsDraw, completion: @escaping (Result<[TeamResult], AppError>) -> Void) {
        apiService.fetchTeamResults(for: teamsDraw, completion: completion)
    }

    /// Deletes TeamResults associated with a specific TeamsDraw from the Parse server.
    /// - Parameters:
    ///   - teamsDraw: The `TeamsDraw` object whose TeamResults are to be deleted.
    ///   - completion: A closure to handle the result of the delete operation, returning un `Result` with either `Void` ou un `AppError`.
    func deleteTeamResults(for teamsDraw: TeamsDraw, completion: @escaping (Result<Void, AppError>) -> Void) {
        fetchTeamResults(for: teamsDraw) { [weak self] result in
            switch result {
            case .success(let teamResults):
                let group = DispatchGroup()
                var deletionError: AppError?
                
                for teamResult in teamResults {
                    group.enter()
                    self?.apiService.deleteTeamResult(teamResult) { result in
                        if case .failure(let error) = result {
                            deletionError = error
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    if let error = deletionError {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }



    /// Deletes TeamsDraw and associated TeamResults from the Parse server.
    /// - Parameters:
    ///   - teamsDraw: The `TeamsDraw` object to be deleted.
    ///   - completion: A closure to handle the result of the delete operation, returning un `Result` with either `Void` ou un `AppError`.
    private func deleteTeamsDrawAndResults(_ teamsDraw: TeamsDraw, completion: @escaping (Result<Void, AppError>) -> Void) {
        deleteTeamResults(for: teamsDraw) { [weak self] result in
            switch result {
            case .success:
                self?.apiService.deleteTeamsDraw(teamsDraw) { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


}
