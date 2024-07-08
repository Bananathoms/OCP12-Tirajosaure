//
//  MockApiService.swift
//  TirajosaureTests
//
//  Created by Thomas Carlier on 07/06/2024.
//

import Foundation
@testable import Tirajosaure
import ParseSwift

class MockApiService: ApiService {
    var logInResult: Result<User, AppError>?
    var signUpResult: Result<User, AppError>?
    var requestPasswordResetResult: Result<Void, AppError>?

    override func logIn(email: String, password: String, onResult: @escaping (Result<User, AppError>) -> Void) {
        if let result = logInResult {
            onResult(result)
        }
    }

    override func signUp(user: User, onResult: @escaping (Result<User, AppError>) -> Void) {
        if let result = signUpResult {
            print("Mock signUp called with result: \(result)")
            onResult(result)
        }
    }

    override func requestPasswordReset(email: String, onResult: @escaping (Result<Void, AppError>) -> Void) {
        if let result = requestPasswordResetResult {
            onResult(result)
        }
    }
}

