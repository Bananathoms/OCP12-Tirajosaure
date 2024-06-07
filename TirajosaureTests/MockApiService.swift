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
    var signUpResult: Result<User, AppError>?

    override func signUp(user: User, onResult: @escaping (Result<User, AppError>) -> Void) {
        if let result = signUpResult {
            onResult(result)
        }
    }
}
