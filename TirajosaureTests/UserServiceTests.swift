//
//  UserServiceTests.swift
//  TirajosaureTests
//
//  Created by Thomas Carlier on 07/06/2024.
//

import Foundation

import XCTest
@testable import Tirajosaure

class UserServiceTests: XCTestCase {
    var userService: UserService!
    var mockApiService: MockApiService!
    
    override func setUp() {
        super.setUp()
        userService = UserService()
        mockApiService = MockApiService()
        ApiService.current = mockApiService
    }
    
    override func tearDown() {
        userService = nil
        mockApiService = nil
        super.tearDown()
        
    }

    func testValidateInputs() {
        let invalidEmailResult = userService.validateInputs(email: "invalidemail", firstName: "John", lastName: "Doe", password: "Password123")
        XCTAssertEqual(invalidEmailResult, "Veuillez rentrer un e-mail valide")
        
        let emptyFirstNameResult = userService.validateInputs(email: "test@example.com", firstName: "", lastName: "Doe", password: "Password123")
        XCTAssertEqual(emptyFirstNameResult, "Merci de rentrer un prénom")
        
        let emptyLastNameResult = userService.validateInputs(email: "test@example.com", firstName: "John", lastName: "", password: "Password123")
        XCTAssertEqual(emptyLastNameResult, "Merci de rentrer un nom")
        
        let shortPasswordResult = userService.validateInputs(email: "test@example.com", firstName: "John", lastName: "Doe", password: "short")
        XCTAssertEqual(shortPasswordResult, "Le mot de passe doit faire plus de 8 caractères")
        
        let noUppercasePasswordResult = userService.validateInputs(email: "test@example.com", firstName: "John", lastName: "Doe", password: "password")
        XCTAssertEqual(noUppercasePasswordResult, "Le mot de passe doit avoir au moins une majuscule")
    }
    
    func testSignUpSuccess() {
        let expectation = self.expectation(description: "User sign up success")
        
        let mockUser = User(username: "test@example.com", email: "test@example.com", password: "Password123", firstName: "John", lastName: "Doe")
        mockApiService.signUpResult = .success(mockUser)
        
        userService.signUp(email: "test@example.com", firstName: "John", lastName: "Doe", password: "Password123") { result in
            switch result {
            case .success(let user):
                XCTAssertEqual(user.email, mockUser.email)
                XCTAssertEqual(user.firstName, mockUser.firstName)
                XCTAssertEqual(user.lastName, mockUser.lastName)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSignUpFailure() {
        let expectation = self.expectation(description: "User sign up failure")
        
        let mockError = AppError.parseError("Test error")
        mockApiService.signUpResult = .failure(mockError)
        
        userService.signUp(email: "test@example.com", firstName: "John", lastName: "Doe", password: "Password123") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, mockError.localizedDescription)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testResetService() {
        let mockUser = User(username: "test@example.com", email: "test@example.com", firstName: "John", lastName: "Doe")
        userService.user = mockUser
        userService.connexionState = .logged
        
        userService.resetService()
        
        XCTAssertNil(userService.user)
        XCTAssertEqual(userService.connexionState, .unLogged)
    }
}
