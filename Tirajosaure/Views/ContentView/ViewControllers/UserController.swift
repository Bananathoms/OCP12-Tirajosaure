//
//  UserController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import Foundation
import Combine

/// A controller class responsible for managing the connection state of the user.
/// Observes changes in the `UserService` and updates its own state accordingly.
class UserController: ObservableObject {
    @Published var connexionState: ConnexionState = .splash
    private var cancellables = Set<AnyCancellable>()

    /// Initializes the `UserController` and sets up observers.
    init() {
        // Observe the `parseInitialized` notification
        NotificationCenter.default.addObserver(self, selector: #selector(parseInitialized), name: .parseInitialized, object: nil)

        // Observe changes in the `connexionState` published by `UserService`
        UserService.current.$connexionState
            .sink { [weak self] state in
                self?.connexionState = state
            }
            .store(in: &cancellables)
    }

    /// Called when Parse is initialized.
    @objc private func parseInitialized() {
        UserService.current.splashData()
    }
}
