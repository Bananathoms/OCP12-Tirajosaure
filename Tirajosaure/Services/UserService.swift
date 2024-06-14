//
//  UserService.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import Foundation
import Combine
import ParseSwift

/// A service class responsible for managing user-related operations such as login, signup, and logout.
class UserService: ObservableObject {
    static let current = UserService()
    
    @Published var connexionState = ConnexionState.splash
    @Published var user: User?
    
    /// Initializes the `UserService` and adds an observer for Parse initialization.
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(parseInitialized), name: .parseInitialized, object: nil)
    }
    
    /// Called when Parse is initialized.
    @objc func parseInitialized() {
        self.splashData()
    }
    
    /// Loads the splash data and updates the connection state based on whether a user is logged in.
    func splashData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let user = User.current {
                self.user = user
                self.connexionState = .logged
            } else {
                self.connexionState = .unLogged
            }
        }
    }
    
    /// Sets the current user and updates the connection state to logged.
    /// - Parameter newUser: The user to set as the current user.
    func setUser(newUser: User) {
        self.user = newUser
        self.connexionState = .logged
    }
    
    /// Logs out the current user and resets the service.
    func logOut() {
        User.logout { _ in
            self.resetService()
        }
    }
    
    /// Resets the service by clearing the current user and setting the connection state to unlogged.
    func resetService() {
        self.user = nil
        self.connexionState = .unLogged
    }
    
    /// Logs in a user with the provided email and password.
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - password: The password of the user.
    ///   - completion: A closure to handle the result of the login, returning a `Result` with either a `User` or an `AppError`.
    func logIn(email: String, password: String, completion: @escaping (Result<User, AppError>) -> Void) {
        if let errorMessage = validateLoginInputs(email: email, password: password) {
            completion(.failure(.validationError(errorMessage)))
            return
        }

        ApiService.current.logIn(email: email, password: password) { result in
            switch result {
            case .success(let user):
                self.user = user
                self.connexionState = .logged
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Registers a new user with the provided details.
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - firstName: The first name of the user.
    ///   - lastName: The last name of the user.
    ///   - password: The password of the user.
    ///   - completion: A closure to handle the result of the registration, returning a `Result` with either a `User` ou un `AppError`.
    func signUp(email: String, firstName: String, lastName: String, password: String, completion: @escaping (Result<User, AppError>) -> Void) {
        if let errorMessage = validateInputs(email: email, firstName: firstName, lastName: lastName, password: password) {
            completion(.failure(.validationError(errorMessage)))
            return
        }

        let newUser = User(username: email.lowercased(), email: email.lowercased(), password: password, firstName: firstName, lastName: lastName)
        ApiService.current.signUp(user: newUser) { result in
            switch result {
            case .success(let user):
                self.user = user
                self.connexionState = .logged
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Requests a password reset for the user with the provided email.
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - completion: A closure to handle the result of the request, returning un `Result` avec either `Void` ou un `AppError`.
    func requestPasswordReset(email: String, completion: @escaping (Result<Void, AppError>) -> Void) {
        ApiService.current.requestPasswordReset(email: email) { result in
            completion(result)
        }
    }
    
    /// Validates the login inputs.
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - password: The password of the user.
    /// - Returns: An optional error message string if validation fails, otherwise nil.
    func validateLoginInputs(email: String, password: String) -> String? {
        if !email.isValidEmail {
            return LocalizedString.invalidEmail.localized
        }
        if password.isEmpty {
            return LocalizedString.emptyPassword.localized
        }
        return nil
    }

    /// Validates the registration inputs.
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - firstName: The first name of the user.
    ///   - lastName: The last name of the user.
    ///   - password: The password of the user.
    /// - Returns: An optional error message string if validation fails, otherwise nil.
    func validateInputs(email: String, firstName: String, lastName: String, password: String) -> String? {
        if firstName.isEmpty {
            return LocalizedString.firstNameMissing.localized
        }
        if lastName.isEmpty {
            return LocalizedString.lastNameMissing.localized
        }
        if !email.isValidEmail {
            return LocalizedString.invalidEmail.localized
        }
        if password.count < 8 {
            return LocalizedString.passwordLengthError.localized
        }
        if !password.hasUppercase() {
            return LocalizedString.passwordUppercaseError.localized
        }
        return nil
    }
}
