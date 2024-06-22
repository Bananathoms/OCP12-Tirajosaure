//
//  MockUserService.swift
//  TirajosaureTests
//
//  Created by Thomas Carlier on 14/06/2024.
//

import Foundation
@testable import Tirajosaure

class MockUserService: UserService {
    var splashDataCalled = false

    override func splashData() {
        splashDataCalled = true
    }
}
