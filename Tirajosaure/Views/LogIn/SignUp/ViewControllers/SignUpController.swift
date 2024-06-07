//
//  SignUpController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import Foundation

/// A controller class responsible for managing the user sign-up process.
class SignUpController: ObservableObject {
    @Published var email: String = "Test@Test.com"
    @Published var firstName: String = "John"
    @Published var lastName: String = "Doe"
    @Published var password: String = "Azerty1234"
    @Published var confirmPwd: String = "Azerty1234"
    @Published var isLoading: Bool = false
    @Published var user: User?

    /// Initiates the sign-up process with the provided details.
    func signUp() {
        guard password == confirmPwd else {
            SnackBarService.current.error("Les mots de passe ne correspondent pas")
            return
        }
        isLoading = true
        UserService.current.signUp(email: email, firstName: firstName, lastName: lastName, password: password) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let user):
                self.user = user
                let firstName = user.firstName ?? ""
                let lastName = user.lastName ?? ""
                SnackBarService.current.success("Utilisateur \(firstName) \(lastName) enregistré!")
                UserService.current.setUser(newUser: user)
            case .failure(let error):
                SnackBarService.current.error(error.localizedDescription)
            }
        }
    }
}
