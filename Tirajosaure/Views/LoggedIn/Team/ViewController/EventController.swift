//
//  EventController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import Foundation
import Combine
import ParseSwift

/// Controller class responsible for managing events.
class EventController: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading = false
    
    @Published var newEventTitle: String = DefaultValues.emptyString
    @Published var parametersController = ParametersListController(numberOfTeams: 2, teamNames: [
        "\(LocalizedString.defaultTeamName.localized) 1",
        "\(LocalizedString.defaultTeamName.localized) 2"
    ])
    @Published var optionsController = OptionsController()
    
    init() {
        loadEvents()
    }
    
    /// Fetches all events for the current user.
    func loadEvents() {
        self.isLoading = true
        guard let currentUser = UserService.current.user else {
            SnackBarService.current.error(ErrorMessage.userIDNotFound.localized)
            self.isLoading = false
            return
        }
        let userPointer = Pointer<User>(objectId: currentUser.objectId ?? DefaultValues.emptyString)

        EventService.shared.fetchEvents(for: userPointer) { [weak self] result in
            switch result {
            case .success(let events):
                self?.events = events
                self?.isLoading = false
            case .failure(let error):
                self?.isLoading = false
                SnackBarService.current.error(String(format: ErrorMessage.failedToFetchEvents.localized, error.localizedDescription))
            }
        }
    }
    
    /// Adds a new event to the list.
    /// - Returns: A boolean indicating whether the event was successfully added.
    @discardableResult
    func addEvent() -> Bool {
        guard let userId = UserService.current.user?.objectId else {
            SnackBarService.current.error(ErrorMessage.userIDNotFound.localized)
            return false
        }
        
        guard !newEventTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            SnackBarService.current.error(ErrorMessage.eventTitleEmpty.localized)
            return false
        }
        
        let validOptions = optionsController.options.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        guard validOptions.count >= parametersController.numberOfTeams else {
            SnackBarService.current.error(ErrorMessage.notEnoughValidEventOptions.localized)
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
        
        EventService.shared.saveEvent(newEvent) { result in
            switch result {
            case .success(let savedEvent):
                DispatchQueue.main.async {
                    self.events.append(savedEvent)
                    self.newEventTitle = DefaultValues.emptyString
                    self.parametersController = ParametersListController(numberOfTeams: 2, teamNames: [
                        "\(LocalizedString.defaultTeamName.localized) 1",
                        "\(LocalizedString.defaultTeamName.localized) 2"
                    ])
                    self.optionsController.options = []
                }
            case .failure(let error):
                SnackBarService.current.error(String(format: ErrorMessage.failedToSaveEvent.localized, error.localizedDescription))
            }
        }
        return true
    }
    
    /// Updates an existing event in the list.
    /// - Parameters:
    ///   - event: The event containing the updated data.
    ///   - parametersController: The controller managing event parameters.
    ///   - optionsController: The controller managing event options.
    ///   - completion: A closure to handle the result of the update operation, returning a `Result` with either an `Event` or an `AppError`.
    func updateEvent(event: Event, parametersController: ParametersListController, optionsController: OptionsController, completion: @escaping (Result<Event, AppError>) -> Void) {
        let updatedEvent = Event(
            objectId: event.objectId,
            title: event.title,
            user: event.user,
            equitableDistribution: parametersController.equitableDistribution,
            teams: parametersController.teamNames,
            members: optionsController.options
        )
         
        EventService.shared.saveEvent(updatedEvent) { result in
            switch result {
            case .success(let savedEvent):
                if let index = self.events.firstIndex(where: { $0.id == savedEvent.id }) {
                    self.events[index] = savedEvent
                }
                completion(.success(savedEvent))
            case .failure(let error):
                SnackBarService.current.error(String(format: ErrorMessage.failedToUpdateEvent.localized, error.localizedDescription))
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
                    SnackBarService.current.error(String(format: ErrorMessage.failedToDeleteEvent.localized, error.localizedDescription))
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
