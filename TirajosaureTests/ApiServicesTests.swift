//
//  ApiServicesTests.swift
//  TirajosaureTests
//
//  Created by Thomas Carlier on 14/06/2024.
//

import Foundation
import XCTest
import Alamofire
import OHHTTPStubs
@testable import Tirajosaure

class ApiServiceTests: XCTestCase {
    
    var apiService: ApiService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        apiService = ApiService()
    }
    
    override func tearDownWithError() throws {
        apiService = nil
        HTTPStubs.removeAllStubs()
        try super.tearDownWithError()
    }
    
    func testSignUpSuccess() {
        stub(condition: isMethodPOST() && isAbsoluteURLString(ParseConfig.serverURL + APIConstants.Endpoints.signUp)) { _ in
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
        
        let user = User(username: "testuser", email: "testuser@example.com", password: "password123", firstName: "Test", lastName: "User")
        let expectation = self.expectation(description: "SignUp succeeds")
        
        apiService.signUp(user: user) { result in
            switch result {
            case .success(let returnedUser):
                XCTAssertEqual(returnedUser.username, user.username)
                XCTAssertEqual(returnedUser.email, user.email)
                XCTAssertEqual(returnedUser.firstName, user.firstName)
                XCTAssertEqual(returnedUser.lastName, user.lastName)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("SignUp failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testLogInSuccess() {
        stub(condition: isMethodGET() && isPath(APIConstants.Endpoints.logIn)) { _ in
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
        
        apiService.logIn(email: "testuser@example.com", password: "password123") { result in
            switch result {
            case .success(let returnedUser):
                print("LogIn success: \(returnedUser)")
                XCTAssertEqual(returnedUser.username, "testuser")
                XCTAssertEqual(returnedUser.email, "testuser@example.com")
                expectation.fulfill()
            case .failure(let error):
                print("LogIn failed with error: \(error)")
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
        
        apiService.logIn(email: "wronguser@example.com", password: "wrongpassword") { result in
            switch result {
            case .success:
                XCTFail("LogIn succeeded with invalid credentials")
            case .failure(let error):
                XCTAssertEqual(error, .parseError("Invalid username/password."))
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testRequestPasswordResetSuccess() {
        stub(condition: isMethodPOST() && isPath(APIConstants.Endpoints.requestPasswordReset)) { _ in
            let stubData = """
            {}
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 200, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectation(description: "Password reset request succeeds")
        
        apiService.requestPasswordReset(email: "testuser@example.com") { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                print("Password reset request failed with error: \(error)")
                XCTFail("Password reset request failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testRequestPasswordResetFailure() {
        stub(condition: isMethodPOST() && isPath(APIConstants.Endpoints.requestPasswordReset)) { _ in
            let stubData = """
            {
                "error": "User not found."
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 404, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectation(description: "Password reset request fails")
        
        apiService.requestPasswordReset(email: "unknownuser@example.com") { result in
            switch result {
            case .success:
                XCTFail("Password reset request succeeded unexpectedly")
            case .failure(let error):
                XCTAssertEqual(error, .networkError("Failed to request password reset: User not found."))
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
