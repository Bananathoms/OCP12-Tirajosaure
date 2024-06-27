//
//  EventService.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 25/06/2024.
//

import Foundation
import ParseSwift
import Alamofire

class EventService {
    static let shared = EventService()

    private init() {}

    func fetchEvents(for userPointer: Pointer<User>, completion: @escaping (Result<[Event], AppError>) -> Void) {
        ApiService.current.fetchEvents(for: userPointer, completion: completion)
    }

    func saveEvent(_ event: Event, completion: @escaping (Result<Event, AppError>) -> Void) {
        ApiService.current.saveEvent(event, completion: completion)
    }

    func updateEvent(_ event: Event, completion: @escaping (Result<Event, AppError>) -> Void) {
        ApiService.current.saveEvent(event, completion: completion)
    }

    func deleteEvent(_ event: Event, completion: @escaping (Result<Void, AppError>) -> Void) {
        ApiService.current.deleteEvent(event, completion: completion)
    }
}
