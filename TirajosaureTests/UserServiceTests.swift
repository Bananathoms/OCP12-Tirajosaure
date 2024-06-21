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
    var userService: MockUserService!
    var mockApiService: MockApiService!
    let testDefaults = UserDefaults(suiteName: "TestDefaults")
    
    override func setUp() {
        super.setUp()
        testDefaults?.removePersistentDomain(forName: "TestDefaults")
        mockApiService = MockApiService()
        ApiService.current = mockApiService
        userService = MockUserService()
    }
    
    override func tearDown() {
        testDefaults?.removePersistentDomain(forName: "TestDefaults")
        userService = nil
        mockApiService = nil
        super.tearDown()
    }
    
    func testSetUser() {
        let user = User(username: "test@example.com", email: "test@example.com", password: "Password123", firstName: "Test", lastName: "User")
        
        userService.setUser(newUser: user)
        
        XCTAssertEqual(userService.user?.username, user.username)
        XCTAssertEqual(userService.connexionState, .logged)
    }
    
    func testLogOut() {
        let expectation = self.expectation(description: "LogOut")
        
        let user = User(username: "test@example.com", email: "test@example.com", password: "Password123", firstName: "Test", lastName: "User")
        userService.setUser(newUser: user)
        
        XCTAssertEqual(userService.user?.username, user.username)
        XCTAssertEqual(userService.connexionState, .logged)
        
        userService.logOut()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNil(self.userService.user)
            XCTAssertEqual(self.userService.connexionState, .unLogged)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testResetService() {
        let user = User(username: "test@example.com", email: "test@example.com", password: "Password123", firstName: "Test", lastName: "User")
        userService.setUser(newUser: user)
        
        XCTAssertEqual(userService.user?.username, user.username)
        XCTAssertEqual(userService.connexionState, .logged)
        
        userService.resetService()
        
        XCTAssertNil(userService.user)
        XCTAssertEqual(userService.connexionState, .unLogged)
    }
    
    func testSplashDataUserLoggedIn() {
        let user = User(username: "test@example.com", email: "test@example.com", password: "Password123", firstName: "Test", lastName: "User")
        userService.mockCurrentUser = user
        
        userService.splashData()
        
        XCTAssertEqual(userService.user?.username, user.username)
        XCTAssertEqual(userService.connexionState, .logged)
    }
    
    func testParseInitialized() {
        let expectation = self.expectation(description: "ParseInitialized")
        
        XCTAssertEqual(userService.connexionState, .splash)
        
        userService.parseInitialized()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertNotEqual(self.userService.connexionState, .splash)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSignUpSuccess() {
        let user = User(username: "test@example.com", email: "test@example.com", password: "Password123", firstName: "Test", lastName: "User")
        mockApiService.signUpResult = .success(user)
        
        let expectation = self.expectation(description: "SignUpSuccess")
        userService.signUp(email: "test@example.com", firstName: "Test", lastName: "User", password: "Password123") { result in
            switch result {
            case .success(let returnedUser):
                XCTAssertEqual(returnedUser.username, user.username)
                XCTAssertEqual(self.userService.user?.username, user.username)
                XCTAssertEqual(self.userService.connexionState, .logged)
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSignUpFailure() {
        let errorMessage = LocalizedString.invalidEmail.localized
        mockApiService.signUpResult = .failure(.validationError(errorMessage))
        
        let expectation = self.expectation(description: "SignUpFailure")
        
        var observedState: ConnexionState?
        let observation = userService.$connexionState.sink { state in
            observedState = state
            print("Observed State: \(state)")
        }
        
        userService.user = nil
        userService.connexionState = .splash
        
        userService.signUp(email: "invalidemail", firstName: "Test", lastName: "User", password: "Password123") { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                print("User after failure: \(String(describing: self.userService.user))")
                print("Connexion state after failure: \(self.userService.connexionState)")
                
                // Vérifier que l'utilisateur est nil
                XCTAssertNil(self.userService.user, "Expected user to be nil, but got \(String(describing: self.userService.user))")
                
                // Vérifier que l'état de connexion est splash
                XCTAssertEqual(observedState, .splash, "Expected connexionState to be 'splash', but got \(String(describing: observedState))")
                
                // Vérifier que le message d'erreur est correct
                if case .validationError(let message) = error {
                    XCTAssertEqual(message, errorMessage)
                } else {
                    XCTFail("Expected validationError, got \(error)")
                }
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        observation.cancel()
    }

    
    func testSignUpValidationFailure() {
        let expectation = self.expectation(description: "SignUpValidationFailure")

        userService.signUp(email: "test@example.com", firstName: "", lastName: "User", password: "Password123") { result in
            switch result {
            case .failure(let error):
                if case .validationError(let message) = error {
                    XCTAssertEqual(message, "first_name_missing".localized)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected validationError, got \(error)")
                }
            case .success:
                XCTFail("Expected failure, got success")
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLogInSuccess() {
        let user = User(username: "test@example.com", email: "test@example.com", password: "Password123", firstName: "Test", lastName: "User")
        mockApiService.logInResult = .success(user)
        
        let expectation = self.expectation(description: "LogInSuccess")
        userService.logIn(email: "test@example.com", password: "Password123") { result in
            switch result {
            case .success(let returnedUser):
                XCTAssertEqual(returnedUser.username, user.username)
                XCTAssertEqual(self.userService.user?.username, user.username)
                XCTAssertEqual(self.userService.connexionState, .logged)
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLogInFailure() {
        let errorMessage = LocalizedString.authenticationErrorMessage.localized
        mockApiService.logInResult = .failure(.authenticationError(errorMessage))
        
        let expectation = self.expectation(description: "LogInFailure")
        
        userService.user = nil
        userService.connexionState = .splash
        
        userService.logIn(email: "test@example.com", password: "WrongPassword") { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, errorMessage)
                XCTAssertNil(self.userService.user)
                XCTAssertEqual(self.userService.connexionState, .splash)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testRequestPasswordResetSuccess() {
        mockApiService.requestPasswordResetResult = .success(())
        
        let expectation = self.expectation(description: "RequestPasswordResetSuccess")
        userService.requestPasswordReset(email: "test@example.com") { result in
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testRequestPasswordResetFailure() {
        let errorMessage = LocalizedString.networkErrorMessage.localized
        mockApiService.requestPasswordResetResult = .failure(.networkError(errorMessage))
        
        let expectation = self.expectation(description: "RequestPasswordResetFailure")
        userService.requestPasswordReset(email: "test@example.com") { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, errorMessage)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testValidateLoginInputsInvalidEmail() {
        let result = userService.validateLoginInputs(email: "invalid-email", password: "Password123")
        XCTAssertEqual(result, LocalizedString.invalidEmail.localized)
    }
    
    func testValidateLoginInputsEmptyPassword() {
        let result = userService.validateLoginInputs(email: "test@example.com", password: "")
        XCTAssertEqual(result, LocalizedString.emptyPassword.localized)
    }
    
    func testValidateLoginInputsValid() {
        let result = userService.validateLoginInputs(email: "test@example.com", password: "Password123")
        XCTAssertNil(result)
    }
    
    func testValidateInputsFirstNameMissing() {
        let result = userService.validateInputs(email: "test@example.com", firstName: "", lastName: "User", password: "Password123")
        XCTAssertEqual(result, LocalizedString.firstNameMissing.localized)
    }
    
    func testValidateInputsLastNameMissing() {
        let result = userService.validateInputs(email: "test@example.com", firstName: "Test", lastName: "", password: "Password123")
        XCTAssertEqual(result, LocalizedString.lastNameMissing.localized)
    }
    
    func testValidateInputsInvalidEmail() {
        let result = userService.validateInputs(email: "invalid-email", firstName: "Test", lastName: "User", password: "Password123")
        XCTAssertEqual(result, LocalizedString.invalidEmail.localized)
    }
    
    func testValidateInputsPasswordTooShort() {
        let result = userService.validateInputs(email: "test@example.com", firstName: "Test", lastName: "User", password: "Pass12")
        XCTAssertEqual(result, LocalizedString.passwordLengthError.localized)
    }
    
    func testValidateInputsPasswordNoUppercase() {
        let result = userService.validateInputs(email: "test@example.com", firstName: "Test", lastName: "User", password: "password123")
        XCTAssertEqual(result, LocalizedString.passwordUppercaseError.localized)
    }
    
    func testValidateInputsValid() {
        let result = userService.validateInputs(email: "test@example.com", firstName: "Test", lastName: "User", password: "Password123")
        XCTAssertNil(result)
    }
}
