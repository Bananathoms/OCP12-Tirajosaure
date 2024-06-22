//
//  UserServiceTests.swift
//  TirajosaureTests
//
//  Created by Thomas Carlier on 07/06/2024.
//

import Foundation
import XCTest
@testable import Tirajosaure
import OHHTTPStubs
import ParseSwift

class UserServiceTests: XCTestCase {
    var userService: UserService!
    var mockUserService: MockUserService!
    var testDefaults: UserDefaults!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        userService = UserService.current
        mockUserService = MockUserService()
        
        let testSuiteName = "TestDefaults"
        testDefaults = UserDefaults(suiteName: testSuiteName)
        userService.userDefaults = testDefaults
        clearUserDefaults(testDefaults)
    }
    
    override func tearDownWithError() throws {
        clearUserDefaults(testDefaults)
        userService = nil
        mockUserService = nil
        testDefaults = nil
        HTTPStubs.removeAllStubs()
        try super.tearDownWithError()
    }
    
    
    func clearUserDefaults(_ defaults: UserDefaults) {
        if defaults.persistentDomain(forName: Bundle.main.bundleIdentifier ?? "") != nil {
            defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier ?? "")
            defaults.synchronize()
        }
    }
    
    func testParseInitializedCallsSplashData() {

        mockUserService.splashDataCalled = false
        
        mockUserService.parseInitialized()

        XCTAssertTrue(mockUserService.splashDataCalled, "parseInitialized should call splashData")
    }
    
    func testSplashDataWithUser() {
        let user = User(username: "testuser", email: "testuser@example.com", password: "password123", firstName: "Test", lastName: "User")
        let userData = try! JSONEncoder().encode(user)
        testDefaults.set(userData, forKey: DefaultValues.currentUser)

        let expectation = self.expectation(description: "splashData loads user data")
        userService.splashData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertEqual(self.userService.user?.username, "testuser")
            XCTAssertEqual(self.userService.connexionState, .logged)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSplashDataWithoutUser() {
        testDefaults.removeObject(forKey: DefaultValues.currentUser)

        userService.user = nil
        userService.connexionState = .splash

        let expectation = self.expectation(description: "splashData sets connexionState to unLogged")
        userService.splashData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertNil(self.userService.user)
            XCTAssertEqual(self.userService.connexionState, .unLogged)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
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
    
    func testSignUpSuccess() {
        stub(condition: isMethodPOST() && isAbsoluteURLString(ParseConfig.serverURL + APIConstants.Endpoints.signUp)) { request in
            let requestBody = try? JSONSerialization.jsonObject(with: request.ohhttpStubs_httpBody ?? Data(), options: []) as? [String: Any]
            
            XCTAssertEqual(requestBody?[APIConstants.Parameters.username] as? String, "testuser@example.com")
            XCTAssertEqual(requestBody?[APIConstants.Parameters.email] as? String, "testuser@example.com")
            XCTAssertEqual(requestBody?[APIConstants.Parameters.password] as? String, "Password123")
            XCTAssertEqual(requestBody?[APIConstants.Parameters.firstName] as? String, "Test")
            XCTAssertEqual(requestBody?[APIConstants.Parameters.lastName] as? String, "User")
            
            let stubData = """
            {
                "objectId": "12345",
                "username": "testuser",
                "email": "testuser@example.com",
                "firstName": "Test",
                "lastName": "User"
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 201, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectation(description: "SignUp with valid values succeeds")
        
        userService.signUp(email: "testuser@example.com", firstName: "Test", lastName: "User", password: "Password123") { result in
            switch result {
            case .success(let returnedUser):
                XCTAssertEqual(returnedUser.username, "testuser")
                XCTAssertEqual(returnedUser.email, "testuser@example.com")
                XCTAssertEqual(returnedUser.firstName, "Test")
                XCTAssertEqual(returnedUser.lastName, "User")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("SignUp failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func testSignUpFailure() {
        stub(condition: isMethodPOST() && isAbsoluteURLString(ParseConfig.serverURL + APIConstants.Endpoints.signUp)) { _ in
            let stubData = """
            {
                "code": 202,
                "error": "Email already taken."
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 400, headers: ["Content-Type": "application/json"])
        }

        let expectation = self.expectation(description: "SignUp should fail with API error")

        userService.signUp(email: "testuser@example.com", firstName: "Test", lastName: "User", password: "Password123") { result in
            switch result {
            case .success:
                XCTFail("SignUp succeeded unexpectedly")
            case .failure(let error):
                if case let .networkError(message) = error {
                    XCTAssertTrue(message.contains("Email already taken."), "Expected network error with message 'Email already taken.', but got \(message)")
                } else {
                    XCTFail("Expected networkError but got \(error)")
                }
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSignUpValidationFailureFirstNameMissing() {
        let expectation = self.expectation(description: "SignUp should fail with first name missing error")
        
        userService.signUp(email: "testuser@example.com", firstName: "", lastName: "User", password: "Password123") { result in
            switch result {
            case .success:
                XCTFail("SignUp succeeded unexpectedly")
            case .failure(let error):
                if case let .validationError(message) = error {
                    XCTAssertEqual(message, LocalizedString.firstNameMissing.localized, "Expected first name missing error message")
                } else {
                    XCTFail("Expected validationError but got \(error)")
                }
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSignUpValidationFailureLastNameMissing() {
        let expectation = self.expectation(description: "SignUp should fail with last name missing error")
        
        userService.signUp(email: "testuser@example.com", firstName: "Test", lastName: "", password: "Password123") { result in
            switch result {
            case .success:
                XCTFail("SignUp succeeded unexpectedly")
            case .failure(let error):
                if case let .validationError(message) = error {
                    XCTAssertEqual(message, LocalizedString.lastNameMissing.localized, "Expected last name missing error message")
                } else {
                    XCTFail("Expected validationError but got \(error)")
                }
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSignUpValidationFailureInvalidEmail() {
        let expectation = self.expectation(description: "SignUp should fail with invalid email error")
        
        userService.signUp(email: "invalid-email", firstName: "Test", lastName: "User", password: "Password123") { result in
            switch result {
            case .success:
                XCTFail("SignUp succeeded unexpectedly")
            case .failure(let error):
                if case let .validationError(message) = error {
                    XCTAssertEqual(message, LocalizedString.invalidEmail.localized, "Expected invalid email error message")
                } else {
                    XCTFail("Expected validationError but got \(error)")
                }
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSignUpValidationFailurePasswordTooShort() {
        let expectation = self.expectation(description: "SignUp should fail with password too short error")
        
        userService.signUp(email: "testuser@example.com", firstName: "Test", lastName: "User", password: "Pass12") { result in
            switch result {
            case .success:
                XCTFail("SignUp succeeded unexpectedly")
            case .failure(let error):
                if case let .validationError(message) = error {
                    XCTAssertEqual(message, LocalizedString.passwordLengthError.localized, "Expected password too short error message")
                } else {
                    XCTFail("Expected validationError but got \(error)")
                }
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSignUpValidationFailurePasswordNoUppercase() {
        let expectation = self.expectation(description: "SignUp should fail with password no uppercase error")
        
        userService.signUp(email: "testuser@example.com", firstName: "Test", lastName: "User", password: "password123") { result in
            switch result {
            case .success:
                XCTFail("SignUp succeeded unexpectedly")
            case .failure(let error):
                if case let .validationError(message) = error {
                    XCTAssertEqual(message, LocalizedString.passwordUppercaseError.localized, "Expected password no uppercase error message")
                } else {
                    XCTFail("Expected validationError but got \(error)")
                }
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testLogInSuccess() {
        stub(condition: isMethodGET() && isPath(APIConstants.Endpoints.logIn)) { request in
            _ = try? JSONSerialization.jsonObject(with: request.ohhttpStubs_httpBody ?? Data(), options: []) as? [String: Any]
            let stubData = """
            {
                "objectId": "12345",
                "username": "testuser",
                "email": "testuser@example.com",
                "firstName": "Test",
                "lastName": "User"
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 200, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectation(description: "LogIn succeeds")
        
        userService.logIn(email: "testuser@example.com", password: "password123") { result in
            switch result {
            case .success(let returnedUser):
                XCTAssertEqual(returnedUser.username, "testuser")
                XCTAssertEqual(returnedUser.email, "testuser@example.com")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("LogIn failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLogInFailureInvalidCredentials() {
        stub(condition: isMethodGET() && isAbsoluteURLString(ParseConfig.serverURL + APIConstants.Endpoints.logIn)) { _ in
            let stubData = """
            {
                "code": 101,
                "error": "Invalid username/password."
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 400, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectation(description: "LogIn fails with invalid credentials")
        
        userService.logIn(email: "wronguser@example.com", password: "wrongpassword") { result in
            switch result {
            case .success:
                XCTFail("LogIn succeeded with invalid credentials")
            case .failure(let error):
                if case let .networkError(message) = error {
                    XCTAssertTrue(message.contains("Invalid username/password."))
                } else {
                    XCTFail("Expected networkError but got \(error) instead")
                }
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLogInValidationFailure() {
        let expectation = self.expectation(description: "LogIn should fail with validation error")
        
        userService.logIn(email: "invalid-email", password: "password123") { result in
            switch result {
            case .success:
                XCTFail("LogIn succeeded unexpectedly")
            case .failure(let error):
                if case let .validationError(message) = error {
                    XCTAssertEqual(message, LocalizedString.invalidEmail.localized, "Expected invalid email error message")
                } else {
                    XCTFail("Expected validationError but got \(error)")
                }
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLogInEmptyPasswordFailure() {
        let expectation = self.expectation(description: "LogIn should fail with empty password error")
        
        userService.logIn(email: "testuser@example.com", password: "") { result in
            switch result {
            case .success:
                XCTFail("LogIn succeeded unexpectedly")
            case .failure(let error):
                if case let .validationError(message) = error {
                    XCTAssertEqual(message, LocalizedString.emptyPassword.localized, "Expected empty password error message")
                } else {
                    XCTFail("Expected validationError but got \(error)")
                }
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testRequestPasswordResetSuccess() {
        stub(condition: isMethodPOST() && isAbsoluteURLString(ParseConfig.serverURL + APIConstants.Endpoints.requestPasswordReset)) { _ in
            let stubData = "{}".data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 200, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectation(description: "Password reset request succeeds")
        
        userService.requestPasswordReset(email: "testuser@example.com") { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Password reset request failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testRequestPasswordResetFailure() {
        stub(condition: isMethodPOST() && isAbsoluteURLString(ParseConfig.serverURL + APIConstants.Endpoints.requestPasswordReset)) { _ in
            let stubData = """
            {
                "error": "User not found."
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 404, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectation(description: "Password reset request fails")
        
        userService.requestPasswordReset(email: "unknownuser@example.com") { result in
            switch result {
            case .success:
                XCTFail("Password reset request succeeded unexpectedly")
            case .failure(let error):
                let localizedErrorMessage = ErrorMessage.failedToRequestPasswordReset.localized
                switch error {
                case .networkError(let message):
                    XCTAssertEqual(message, "\(localizedErrorMessage): User not found.")
                default:
                    XCTFail("Unexpected error type: \(error)")
                }
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testRequestPasswordResetFailureWithNoData() {
        stub(condition: isMethodPOST() && isAbsoluteURLString(ParseConfig.serverURL + APIConstants.Endpoints.requestPasswordReset)) { _ in
            return HTTPStubsResponse(error: NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue, userInfo: nil))
        }
        
        let expectation = self.expectation(description: "Password reset request fails with no data")
        
        userService.requestPasswordReset(email: "unknownuser@example.com") { result in
            switch result {
            case .success:
                XCTFail("Password reset request succeeded unexpectedly")
            case .failure(let error):
                let localizedErrorMessage = ErrorMessage.failedToRequestPasswordReset.localized
                switch error {
                case .networkError(let message):
                    XCTAssertTrue(message.contains(localizedErrorMessage))
                    XCTAssertTrue(message.contains("NSURLErrorDomain"))
                default:
                    XCTFail("Unexpected error type: \(error)")
                }
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}


private extension URL {
    func queryParameters() throws -> [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return nil }
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        return parameters
    }
}
