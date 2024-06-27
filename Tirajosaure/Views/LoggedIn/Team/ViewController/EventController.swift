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
    
    @Published var newEventTitle: String = DefaultValues.emptyString
    @Published var parametersController = ParametersListController(numberOfTeams: 2, teamNames: ["Équipe 1", "Équipe 2"])
    @Published var optionsController = OptionsController()
    
    init() {
        fetchAllData()
    }
    
    /// Fetch all events for the current user
    func fetchAllData() {
        guard let currentUser = UserService.current.user else { return }
        let userPointer = Pointer<User>(objectId: currentUser.objectId ?? "")

        EventService.shared.fetchEvents(for: userPointer) { [weak self] result in
            switch result {
            case .success(let events):
                self?.events = events
            case .failure(let error):
                print("Failed to fetch events: \(error.localizedDescription)")
            }
        }
    }
    
    /// Add an event in the list
    @discardableResult
    func addEvent() -> Bool {
        guard let userId = UserService.current.user?.objectId else {
            print("User ID not found")
            return false
        }
        
        guard !newEventTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            SnackBarService.current.error("Le titre de l'événement est vide")
            print("Event title is empty")
            return false
        }
        
        let validOptions = optionsController.options.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        guard validOptions.count >= 2 else {
            SnackBarService.current.error("Pas assez d'options valides")
            print("Not enough valid options")
            return false
        }
        
        let userPointer = Pointer<User>(objectId: userId)
        let newEvent = Event(
            title: newEventTitle,
            user: userPointer,
            equitableDistribution: parametersController.equitableDistribution,
            teams: parametersController.teamNames,
            members: validOptions
        )
        print("Saving event: \(newEvent)")
        EventService.shared.saveEvent(newEvent) { result in
            switch result {
            case .success(let savedEvent):
                DispatchQueue.main.async {
                    self.events.append(savedEvent)
                    self.newEventTitle = DefaultValues.emptyString
                    self.parametersController = ParametersListController(numberOfTeams: 2, teamNames: ["Équipe 1", "Équipe 2"])
                    self.optionsController.options = []
                    print("Event saved successfully: \(savedEvent)")
                }
            case .failure(let error):
                SnackBarService.current.error("Échec de l'enregistrement de l'événement: \(error.localizedDescription)")
                print("Failed to save event: \(error)")
            }
        }
        return true
    }
    
    /// Updates an existing event in the list.
    /// - Parameter updatedEvent: The event containing the updated data.
    func updateEvent(event: Event, parametersController: ParametersListController, optionsController: OptionsController, completion: @escaping (Result<Event, AppError>) -> Void) {
        let updatedEvent = Event(
            objectId: event.objectId,
            title: event.title,
            user: event.user,
            equitableDistribution: parametersController.equitableDistribution,
            teams: parametersController.teamNames,
            members: optionsController.options
        )
        
        print("Updating event: \(updatedEvent)")  
        EventService.shared.saveEvent(updatedEvent) { result in
            switch result {
            case .success(let savedEvent):
                if let index = self.events.firstIndex(where: { $0.id == savedEvent.id }) {
                    self.events[index] = savedEvent
                }
                print("Event updated successfully: \(savedEvent)")
                completion(.success(savedEvent))
            case .failure(let error):
                print("Failed to update event: \(error.localizedDescription)")
                SnackBarService.current.error("Échec de la mise à jour de l'événement: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    
    /// Removes an event from the list.
    /// - Parameter offsets: The set of indices specifying the events to be removed.
    func removeEvent(at offsets: IndexSet) {
        offsets.forEach { index in
            let event = events[index]
            EventService.shared.deleteEvent(event) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.events.remove(at: index)
                    }
                case .failure(let error):
                    SnackBarService.current.error("Échec de la suppression de l'événement: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Moves an event from one position to another within the list.
    /// - Parameters:
    ///   - source: The set of indices specifying the current positions of the events to be moved.
    ///   - destination: The index specifying the new position for the events.
    func moveEvent(from source: IndexSet, to destination: Int) {
        self.events.move(fromOffsets: source, toOffset: destination)
    }
}
