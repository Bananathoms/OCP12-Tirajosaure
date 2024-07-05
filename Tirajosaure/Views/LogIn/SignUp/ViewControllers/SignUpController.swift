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
        guard !firstName.isEmpty else {
            SnackBarService.current.error(LocalizedString.firstNameMissing.localized)
            return
        }
        
        guard !lastName.isEmpty else {
            SnackBarService.current.error(LocalizedString.lastNameMissing.localized)
            return
        }
        
        guard email.isValidEmail else {
            SnackBarService.current.error(LocalizedString.invalidEmail.localized)
            return
        }
        
        guard password == confirmPwd else {
            SnackBarService.current.error(LocalizedString.passwordsDoNotMatch.localized)
            return
        }
        
        guard password.count >= 8 else {
            SnackBarService.current.error(LocalizedString.passwordLengthError.localized)
            return
        }
        
        guard password.hasUppercase() else {
            SnackBarService.current.error(LocalizedString.passwordUppercaseError.localized)
            return
        }
        
        isLoading = true
        UserService.current.signUp(email: email, firstName: firstName, lastName: lastName, password: password) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(_):
                self.logInAfterSignUp(email: self.email, password: self.password)
                SnackBarService.current.success(LocalizedString.successfulSignUp.localized(with: firstName, lastName))
            case .failure(let error):
                SnackBarService.current.error(error.localizedDescription)
            }
        }
    }
    
    /// Logs in the user immediately after sign-up.
    /// - Parameters:
    ///   - email: The email address used for sign-up.
    ///   - password: The password used for sign-up.
    private func logInAfterSignUp(email: String, password: String) {
        UserService.current.logIn(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.user = user
                UserService.current.setUser(newUser: user)
            case .failure(let error):
                SnackBarService.current.error(error.localizedDescription)
            }
        }
    }
}
