//
//  MockUserService.swift
//  TirajosaureTests
//
//  Created by Thomas Carlier on 14/06/2024.
//

import Foundation
@testable import Tirajosaure

class MockUserService: UserService {
    var mockCurrentUser: User?

    override func splashData() {
        if let user = self.mockCurrentUser {
            self.user = user
            self.connexionState = .logged
        } else {
            self.connexionState = .unLogged
        }
    }
}
