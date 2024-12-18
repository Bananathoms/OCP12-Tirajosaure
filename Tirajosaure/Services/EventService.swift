//
//  EventService.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 25/06/2024.
//

import Foundation
import ParseSwift
import Alamofire

/// Service class responsible for managing operations related to `Event` objects.
class EventService {
    static let shared = EventService()
    private let teamsDrawService = TeamsDrawService.shared
    private let apiService = ApiService.current

    private init() {}
    
    /// Fetches events associated with a specific user from the Parse server.
    /// - Parameters:
    ///   - userPointer: A pointer to the user whose events are to be fetched.
    ///   - completion: A closure to handle the result of the fetch operation, returning a `Result` with either an array of `Event` objects or an `AppError`.
    func fetchEvents(for userPointer: Pointer<User>, completion: @escaping (Result<[Event], AppError>) -> Void) {
        apiService.fetchEvents(for: userPointer, completion: completion)
    }
    
    /// Saves an `Event` object to the Parse server.
    /// - Parameters:
    ///   - event: The `Event` object to be saved.
    ///   - completion: A closure to handle the result of the save operation, returning a `Result` with either the saved `Event` object or an `AppError`.
    func saveEvent(_ event: Event, completion: @escaping (Result<Event, AppError>) -> Void) {
        apiService.saveEvent(event, completion: completion)
    }
    
    /// Deletes an `Event` object and its associated `TeamsDraw` objects from the Parse server.
    /// - Parameters:
    ///   - event: The `Event` object to be deleted.
    ///   - completion: A closure to handle the result of the delete operation, returning a `Result` with either `Void` or an `AppError`.
    func deleteEvent(_ event: Event, completion: @escaping (Result<Void, AppError>) -> Void) {
        guard let eventId = event.objectId else {
            completion(.failure(.validationError(ErrorMessage.invalidEventID.localized)))
            return
        }

        let eventPointer = Pointer<Event>(objectId: eventId)

        teamsDrawService.deleteTeamsDraws(for: eventPointer) { [weak self] result in
            switch result {
            case .success:
                self?.deleteEventOnly(event, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Deletes only the `Event` object from the Parse server.
    /// - Parameters:
    ///   - event: The `Event` object to be deleted.
    ///   - completion: A closure to handle the result of the delete operation, returning a `Result` with either `Void` or an `AppError`.
    private func deleteEventOnly(_ event: Event, completion: @escaping (Result<Void, AppError>) -> Void) {
        apiService.deleteEvent(event, completion: completion)
    }
}
