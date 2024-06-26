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
    @Published var newEventTitle: String = DefaultValues.emptyString
    @Published var parametersController = ParametersListController(numberOfTeams: 0, teamNames: [])

    init() {
        fetchAllData()
    }

    func fetchAllData() {
        guard let currentUser = UserService.current.user else { return }
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

    @discardableResult
    func addEvent(parametersController: ParametersListController, optionsController: OptionsController) -> Bool {
        guard let userId = UserService.current.user?.objectId else {
            print("User ID not found")
            return false
        }

        guard !newEventTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            SnackBarService.current.error("Le titre de l'événement est vide")
            print("Event title is empty")
            return false
        }

        let userPointer = Pointer<User>(objectId: userId)
        let newEvent = Event(
            title: newEventTitle,
            user: userPointer,
            equitableDistribution: parametersController.equitableDistribution
        )
        print("Saving event: \(newEvent)")
        EventService.shared.saveEvent(newEvent) { [weak self] result in
            switch result {
            case .success(let savedEvent):
                DispatchQueue.main.async {
                    self?.events.append(savedEvent)
                    self?.newEventTitle = ""
                    self?.parametersController = ParametersListController(numberOfTeams: 0, teamNames: [])
                    self?.saveTeamsAndMembers(for: savedEvent, parametersController: parametersController, optionsController: optionsController)
                    print("Event saved successfully: \(savedEvent)")
                }
            case .failure(let error):
                SnackBarService.current.error("Échec de l'enregistrement de l'événement: \(error.localizedDescription)")
                print("Failed to save event: \(error)")
            }
        }
        return true
    }

    func updateEvent(event: Event, parametersController: ParametersListController, optionsController: OptionsController) {
        let teams = parametersController.teamNames.map { Team(name: $0, event: Pointer(objectId: event.objectId ?? "")) }
        let members = optionsController.options.map { Member(name: $0, event: Pointer(objectId: event.objectId ?? "")) }
        
        EventService.shared.saveEvent(event) { [weak self] result in
            switch result {
            case .success(let updatedEvent):
                if let index = self?.events.firstIndex(where: { $0.objectId == updatedEvent.objectId }) {
                    self?.events[index] = updatedEvent
                }
                self?.saveTeams(for: updatedEvent, teams: teams)
                self?.saveMembers(for: updatedEvent, members: members)
                print("Event updated successfully: \(updatedEvent)")
            case .failure(let error):
                print("Failed to update event: \(error.localizedDescription)")
            }
        }
    }

    func saveTeamsAndMembers(for event: Event, parametersController: ParametersListController, optionsController: OptionsController) {
        let teams = parametersController.teamNames.map { Team(name: $0, event: Pointer(objectId: event.objectId ?? "")) }
        let members = optionsController.options.map { Member(name: $0, event: Pointer(objectId: event.objectId ?? "")) }

        print("saveTeamsAndMembers: Saving teams for event: \(event.objectId ?? "") with teams: \(teams.map { $0.name })")
        saveTeams(for: event, teams: teams)

        print("saveTeamsAndMembers: Saving members for event: \(event.objectId ?? "") with members: \(members.map { $0.name })")
        saveMembers(for: event, members: members)
    }

    func saveTeams(for event: Event, teams: [Team]) {
        print("saveTeams: Teams to save: \(teams.map { $0.name })")
        let dispatchGroup = DispatchGroup()

        for team in teams {
            dispatchGroup.enter()
            print("saveTeams: Saving team: \(team.name)")
            EventService.shared.saveTeam(team) { result in
                switch result {
                case .success(let savedTeam):
                    print("saveTeams: Team saved successfully: \(savedTeam)")
                case .failure(let error):
                    print("saveTeams: Failed to save team: \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            print("saveTeams: All teams saved.")
        }
    }

    func saveMembers(for event: Event, members: [Member]) {
        print("saveMembers: Members to save: \(members.map { $0.name })")
        let dispatchGroup = DispatchGroup()

        for member in members {
            dispatchGroup.enter()
            print("saveMembers: Saving member: \(member.name)")
            EventService.shared.saveMember(member) { result in
                switch result {
                case .success(let savedMember):
                    print("saveMembers: Member saved successfully: \(savedMember)")
                case .failure(let error):
                    print("saveMembers: Failed to save member: \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            print("saveMembers: All members saved.")
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
