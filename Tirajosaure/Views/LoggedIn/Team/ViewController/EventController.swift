//
//  EventController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import Foundation
import Combine
import ParseSwift

class EventController: ObservableObject {
    @Published var events: [Event] = []
    @Published var teams: [Team] = []
    @Published var members: [Member] = []

    init() {
        fetchAllData()
    }

    func fetchAllData() {
        guard let currentUser = User.current else { return }
        let userPointer = Pointer<User>(objectId: currentUser.objectId ?? "")

        EventService.shared.fetchEvents(for: userPointer) { [weak self] result in
            switch result {
            case .success(let events):
                self?.events = events
                self?.fetchTeamsForEvents(events)
                self?.fetchMembersForEvents(events)
            case .failure(let error):
                print("Failed to fetch events: \(error.localizedDescription)")
            }
        }
    }

    func fetchTeamsForEvents(_ events: [Event]) {
        for event in events {
            let eventPointer = Pointer<Event>(objectId: event.objectId ?? "")
            EventService.shared.fetchTeams(for: eventPointer) { [weak self] result in
                switch result {
                case .success(let teams):
                    self?.teams.append(contentsOf: teams)
                case .failure(let error):
                    print("Failed to fetch teams: \(error.localizedDescription)")
                }
            }
        }
    }

    func fetchMembersForEvents(_ events: [Event]) {
        for event in events {
            let eventPointer = Pointer<Event>(objectId: event.objectId ?? "")
            EventService.shared.fetchMembers(for: eventPointer) { [weak self] result in
                switch result {
                case .success(let members):
                    self?.members.append(contentsOf: members)
                case .failure(let error):
                    print("Failed to fetch members: \(error.localizedDescription)")
                }
            }
        }
    }

    func addEvent(_ event: Event) {
        EventService.shared.saveEvent(event) { [weak self] result in
            switch result {
            case .success(let savedEvent):
                self?.events.append(savedEvent)
            case .failure(let error):
                print("Failed to add event: \(error.localizedDescription)")
            }
        }
    }

    func updateEvent(_ event: Event, teams: [Team], equitableDistribution: Bool) {
        EventService.shared.saveEvent(event) { [weak self] result in
            switch result {
            case .success(let updatedEvent):
                if let index = self?.events.firstIndex(where: { $0.objectId == updatedEvent.objectId }) {
                    self?.events[index] = updatedEvent
                }
                self?.updateTeams(for: updatedEvent, teams: teams)
            case .failure(let error):
                print("Failed to update event: \(error.localizedDescription)")
            }
        }
    }

    private func updateTeams(for event: Event, teams: [Team]) {
        for team in teams {
            var updatedTeam = team
            updatedTeam.event = Pointer(objectId: event.objectId ?? "")
            EventService.shared.saveTeam(updatedTeam) { [weak self] result in
                switch result {
                case .success(let savedTeam):
                    if let index = self?.teams.firstIndex(where: { $0.objectId == savedTeam.objectId }) {
                        self?.teams[index] = savedTeam
                    } else {
                        self?.teams.append(savedTeam)
                    }
                case .failure(let error):
                    print("Failed to update team: \(error.localizedDescription)")
                }
            }
        }
    }

    func removeEvent(at offsets: IndexSet) {
        offsets.forEach { index in
            let event = events[index]
            EventService.shared.deleteEvent(event) { [weak self] result in
                switch result {
                case .success:
                    self?.events.remove(at: index)
                case .failure(let error):
                    print("Failed to delete event: \(error.localizedDescription)")
                }
            }
        }
    }

    func moveEvent(from source: IndexSet, to destination: Int) {
        events.move(fromOffsets: source, toOffset: destination)
    }
    
    func getTeams(for event: Event) -> [Team] {
        return teams.filter { $0.event.objectId == event.objectId }
    }

    func getMembers(for event: Event) -> [Member] {
        return members.filter { $0.event.objectId == event.objectId }
    }
}
