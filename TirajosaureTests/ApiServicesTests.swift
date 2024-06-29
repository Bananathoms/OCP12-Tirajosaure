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
    
    func testSignUpWithDefaultValues() {
        stub(condition: isMethodPOST() && isPath("/users")) { request in
            guard let httpBody = request.ohhttpStubs_httpBody else {
                return HTTPStubsResponse(error: NSError(domain: "com.example", code: 400, userInfo: nil))
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: Any] {
                    XCTAssertEqual(json[APIConstants.Parameters.username] as? String, DefaultValues.emptyString)
                    XCTAssertEqual(json[APIConstants.Parameters.email] as? String, DefaultValues.emptyString)
                    XCTAssertEqual(json[APIConstants.Parameters.password] as? String, DefaultValues.emptyString)
                    XCTAssertEqual(json[APIConstants.Parameters.firstName] as? String, DefaultValues.emptyString)
                    XCTAssertEqual(json[APIConstants.Parameters.lastName] as? String, DefaultValues.emptyString)
                } else {
                    XCTFail("Request body is not valid JSON")
                }
            } catch {
                XCTFail("Failed to parse request body: \(error)")
            }
            
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
                XCTAssertEqual(returnedUser.objectId, "12345")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("SignUp failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDeleteTeamResultSuccess() {
        var teamResult = TeamResult(name: "Team1", members: ["Member1"], draw: Pointer<TeamsDraw>(objectId: "TeamsDrawId"))
        teamResult.objectId = "TeamResultId"

        stub(condition: isPath("/classes/TeamResult/TeamResultId") && isMethodDELETE()) { request in
            let stubData = "{}".data(using: .utf8)! 
            return HTTPStubsResponse(data: stubData, statusCode: 200, headers: ["Content-Type": "application/json"])
        }

        let expectation = self.expectation(description: "Delete team result succeeds")

        apiService.deleteTeamResult(teamResult) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Delete team result failed with error: \(error)")
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testDeleteQuestionWithoutObjectId() {
        let question = Question(title: "Test Question", options: [], user: Pointer<User>(objectId: "TestUserId"))

        let expectation = self.expectation(description: "Delete question fails due to missing objectId")

        apiService.deleteQuestion(question) { result in
            switch result {
            case .success:
                XCTFail("Delete question succeeded unexpectedly")
            case .failure(let error):
                if case .validationError(let message) = error {
                    XCTAssertEqual(message, LocalizedString.invalidQuestionID.localized)
                } else {
                    XCTFail("Expected validationError but got \(error)")
                }
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testDeleteDrawResultWithoutObjectId() {
        let drawResult = DrawResult(option: "TestOption", date: Date(), question: Pointer<Question>(objectId: "TestQuestion"))

        let expectation = self.expectation(description: "Delete draw result fails due to missing objectId")

        apiService.deleteDrawResult(drawResult) { result in
            switch result {
            case .success:
                XCTFail("Delete draw result succeeded unexpectedly")
            case .failure(let error):
                if case .validationError(let message) = error {
                    XCTAssertEqual(message, ErrorMessage.invalidQuestionID.localized)
                } else {
                    XCTFail("Expected validationError but got \(error)")
                }
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testDeleteEventWithoutObjectId() {
        let event = Event(title: "Test Event", user: Pointer<User>(objectId: "TestUserId"), equitableDistribution: true, teams: [], members: [])

        let expectation = self.expectation(description: "Delete event fails due to missing objectId")

        apiService.deleteEvent(event) { result in
            switch result {
            case .success:
                XCTFail("Delete event succeeded unexpectedly")
            case .failure(let error):
                if case .validationError(let message) = error {
                    XCTAssertEqual(message, ErrorMessage.invalidEventID.localized)
                } else {
                    XCTFail("Expected validationError but got \(error)")
                }
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testDeleteTeamsDrawWithoutObjectId() {
        let teamsDraw = TeamsDraw(date: Date(), event: Pointer<Tirajosaure.Event>(objectId: "EventId"))

        let expectation = self.expectation(description: "Delete teamsDraw fails due to missing objectId")

        apiService.deleteTeamsDraw(teamsDraw) { result in
            switch result {
            case .success:
                XCTFail("Delete teamsDraw succeeded unexpectedly")
            case .failure(let error):
                if case .validationError(let message) = error {
                    XCTAssertEqual(message, ErrorMessage.invalidTeamsDrawID.localized)
                } else {
                    XCTFail("Expected validationError but got \(error)")
                }
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func testDeleteTeamResultWithoutObjectId() {
        let teamResult = TeamResult(name: "Team1", members: ["Member1"], draw: Pointer<TeamsDraw>(objectId: "TeamsDrawId"))

        let expectation = self.expectation(description: "Delete teamResult fails due to missing objectId")

        apiService.deleteTeamResult(teamResult) { result in
            switch result {
            case .success:
                XCTFail("Delete teamResult succeeded unexpectedly")
            case .failure(let error):
                if case .validationError(let message) = error {
                    XCTAssertEqual(message, ErrorMessage.invalidTeamResultID.localized)
                } else {
                    XCTFail("Expected validationError but got \(error)")
                }
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}
