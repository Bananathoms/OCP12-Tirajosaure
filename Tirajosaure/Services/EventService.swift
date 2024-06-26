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

    func deleteEvent(_ event: Event, completion: @escaping (Result<Void, AppError>) -> Void) {
        ApiService.current.deleteEvent(event, completion: completion)
    }

    func saveTeam(_ team: Team, completion: @escaping (Result<Team, AppError>) -> Void) {
        ApiService.current.saveTeam(team, completion: completion)
    }

    func fetchTeams(for eventPointer: Pointer<Event>, completion: @escaping (Result<[Team], AppError>) -> Void) {
        ApiService.current.fetchTeams(for: eventPointer, completion: completion)
    }

    func deleteTeam(_ team: Team, completion: @escaping (Result<Void, AppError>) -> Void) {
        ApiService.current.deleteTeam(team, completion: completion)
    }

    func saveMember(_ member: Member, completion: @escaping (Result<Member, AppError>) -> Void) {
        ApiService.current.saveMember(member, completion: completion)
    }

    func fetchMembers(for eventPointer: Pointer<Event>, completion: @escaping (Result<[Member], AppError>) -> Void) {
        ApiService.current.fetchMembers(for: eventPointer, completion: completion)
    }

    func deleteMember(_ member: Member, completion: @escaping (Result<Void, AppError>) -> Void) {
        ApiService.current.deleteMember(member, completion: completion)
    }
}

