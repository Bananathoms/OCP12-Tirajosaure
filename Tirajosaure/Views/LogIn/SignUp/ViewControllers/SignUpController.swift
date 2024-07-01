//
//  SignUpController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import Foundation

/// A controller class responsible for managing the user sign-up process.
class SignUpController: ObservableObject {
    @Published var email: String = DefaultValues.emptyString
    @Published var firstName: String = DefaultValues.emptyString
    @Published var lastName: String = DefaultValues.emptyString
    @Published var password: String = DefaultValues.emptyString
    @Published var confirmPwd: String = DefaultValues.emptyString
    @Published var isLoading: Bool = false
    @Published var user: User?

    /// Initiates the sign-up process with the provided details.
    func signUp() {
        guard password == confirmPwd else {
            SnackBarService.current.error(LocalizedString.passwordsDoNotMatch.localized)
            return
        }
        isLoading = true
        UserService.current.signUp(email: email, firstName: firstName, lastName: lastName, password: password) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let user):
                self.user = user
                let firstName = user.firstName ?? DefaultValues.emptyString
                let lastName = user.lastName ?? DefaultValues.emptyString
                SnackBarService.current.success(LocalizedString.successfulSignUp.localized(with: firstName, lastName))
                UserService.current.setUser(newUser: user)
            case .failure(let error):
                SnackBarService.current.error(error.localizedDescription)
            }
        }
    }
}
