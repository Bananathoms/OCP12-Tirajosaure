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
import ParseSwift
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
        stub(condition: isMethodPOST() && isAbsoluteURLString(ParseConfig.serverURL + APIConstants.Endpoints.signUp)) { request in
            let requestBody = try? JSONSerialization.jsonObject(with: request.ohhttpStubs_httpBody ?? Data(), options: []) as? [String: Any]
            
            XCTAssertEqual(requestBody?[APIConstants.Parameters.username] as? String, DefaultValues.emptyString)
            XCTAssertEqual(requestBody?[APIConstants.Parameters.email] as? String, DefaultValues.emptyString)
            XCTAssertEqual(requestBody?[APIConstants.Parameters.password] as? String, DefaultValues.emptyString)
            XCTAssertEqual(requestBody?[APIConstants.Parameters.firstName] as? String, DefaultValues.emptyString)
            XCTAssertEqual(requestBody?[APIConstants.Parameters.lastName] as? String, DefaultValues.emptyString)
            
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
        
        let user = User(username: nil, email: nil, password: nil, firstName: nil, lastName: nil)
        let expectation = self.expectation(description: "SignUp with default values succeeds")
        
        apiService.signUp(user: user) { result in
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
    
    func testRequestPasswordResetFailureWithNoData() {        stub(condition: isMethodPOST() && isPath(APIConstants.Endpoints.requestPasswordReset)) { _ in
        return HTTPStubsResponse(error: NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue, userInfo: nil))
    }
        
        let expectation = self.expectation(description: "Password reset request fails with no data")
        
        apiService.requestPasswordReset(email: "unknownuser@example.com") { result in
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
    
    func testSaveDrawResultSuccess() {
        let drawResult = DrawResult()
        let mockDrawResult = MockDrawResult(drawResult: drawResult)
        
        mockDrawResult.saveCompletion = { completion in
            completion(.success(drawResult))
        }
        
        let expectation = self.expectation(description: "Save draw result succeeds")
        
        apiService.saveDrawResult(mockDrawResult.drawResult) { result in
            switch result {
            case .success(let savedResult):
                XCTAssertEqual(savedResult.date, drawResult.date)
                XCTAssertEqual(savedResult.option, drawResult.option)
                XCTAssertEqual(savedResult.question, drawResult.question)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Save draw result failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSaveDrawResultFailure() {
        stub(condition: isPath("/classes/DrawResult")) { request in
            let stubData = """
            {
                "code": 101,
                "error": "Test error"
            }
            """.data(using: .utf8)!
            let response = HTTPStubsResponse(data: stubData, statusCode: 400, headers: ["Content-Type": "application/json"])
            return response
        }
        
        let drawResult = DrawResult(option: "TestOption", date: Date(), question: Pointer<Question>(objectId: "TestQuestion"))
        
        let expectation = self.expectation(description: "Save draw result fails")
        
        apiService.saveDrawResult(drawResult) { result in
            switch result {
            case .success:
                XCTFail("Save draw result succeeded unexpectedly")
            case .failure(let error):
                
                if case let .networkError(message) = error {
                    XCTAssertTrue(message.contains("Test error"))
                } else {
                    XCTFail("Expected networkError but got \(error)")
                }
                
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadDrawResultsSuccess() {
        stub(condition: isPath("/classes/DrawResult")) { _ in
            let stubData = """
            {
                "results": [
                    {
                        "objectId": "123",
                        "option": "TestOption",
                        "date": "2024-06-20T21:30:54.503Z",
                        "question": {
                            "__type": "Pointer",
                            "className": "Question",
                            "objectId": "TestQuestion"
                        }
                    }
                ]
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 200, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectation(description: "Load draw results succeeds")
        
        apiService.loadDrawResults(for: Pointer<Question>(objectId: "TestQuestion")) { result in
            switch result {
            case .success(let results):
                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(results.first?.option, "TestOption")
                XCTAssertEqual(results.first?.question.objectId, "TestQuestion")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Load draw results failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadDrawResultsFailure() {
        stub(condition: isPath("/classes/DrawResult")) { _ in
            let stubData = """
            {
                "code": 101,
                "error": "Test error"
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 400, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectation(description: "Load draw results fails")
        
        apiService.loadDrawResults(for: Pointer<Question>(objectId: "TestQuestion")) { result in
            switch result {
            case .success:
                XCTFail("Load draw results succeeded unexpectedly")
            case .failure(let error):
                XCTAssertEqual(error, .networkError("ParseError code=101 error=Test error"))
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
