//
//  SignInController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import Foundation

/// A controller class responsible for managing the user sign-in process.
class SignInController: ObservableObject {
    @Published var email: String = "test@test.com"
    @Published var password: String = "Azerty1234"
    @Published var isLoading: Bool = false
    @Published var user: User?

    /// Initiates the sign-in process with the provided email and password.
    func signIn() {
        self.isLoading = true
        UserService.current.logIn(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let user):
                self.user = user
                let firstName = user.firstName ?? ""
                let lastName = user.lastName ?? ""
                SnackBarService.current.success("successful_sign_in".localized(with: firstName, lastName))
                UserService.current.setUser(newUser: user)
            case .failure(let error):
                SnackBarService.current.error(error.localizedDescription)
            }
        }
    }
}
