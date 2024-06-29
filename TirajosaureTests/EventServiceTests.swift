//
//  EventServiceTests.swift
//  TirajosaureTests
//
//  Created by Thomas Carlier on 29/06/2024.
//

import XCTest
import OHHTTPStubs
import Alamofire
@testable import Tirajosaure
import ParseSwift

class EventServiceTests: XCTestCase {

    var eventService: EventService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        eventService = EventService.shared
    }

    override func tearDownWithError() throws {
        eventService = nil
        HTTPStubs.removeAllStubs()
        try super.tearDownWithError()
    }

    func testFetchEventsSuccess() {
        stub(condition: isPath("/classes/Event") && isMethodGET()) { _ in
            let stubData = """
            {
                "results": [
                    {
                        "objectId": "12345",
                        "title": "Test Event",
                        "equitableDistribution": true,
                        "user": {
                            "__type": "Pointer",
                            "className": "_User",
                            "objectId": "TestUserId"
                        },
                        "teams": ["Team1", "Team2"],
                        "members": ["Member1", "Member2"]
                    }
                ]
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 200, headers: ["Content-Type": "application/json"])
        }

        let expectation = self.expectation(description: "Fetch events succeeds")

        let userPointer = Pointer<User>(objectId: "TestUserId")
        eventService.fetchEvents(for: userPointer) { result in
            switch result {
            case .success(let events):
                XCTAssertEqual(events.count, 1)
                XCTAssertEqual(events.first?.objectId, "12345")
                XCTAssertEqual(events.first?.title, "Test Event")
                XCTAssertEqual(events.first?.equitableDistribution, true)
                XCTAssertEqual(events.first?.user.objectId, "TestUserId")
                XCTAssertEqual(events.first?.teams, ["Team1", "Team2"])
                XCTAssertEqual(events.first?.members, ["Member1", "Member2"])
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Fetch events failed with error: \(error)")
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchEventsFailure() {
        stub(condition: isPath("/classes/Event") && isMethodGET()) { _ in
            let stubData = """
            {
                "code": 101,
                "error": "Test error"
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 400, headers: ["Content-Type": "application/json"])
        }

        let expectation = self.expectation(description: "Fetch events fails")

        let userPointer = Pointer<User>(objectId: "TestUserId")
        eventService.fetchEvents(for: userPointer) { result in
            switch result {
            case .success:
                XCTFail("Fetch events succeeded unexpectedly")
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

    func testSaveEventSuccess() {
        stub(condition: isMethodPOST() && isPath(APIConstants.Endpoints.eventBase)) { _ in
            let stubData = """
            {
                "objectId": "12345",
                "createdAt": "2024-06-25T21:48:41.085Z",
                "updatedAt": "2024-06-25T21:48:41.085Z"
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 201, headers: ["Content-Type": "application/json"])
        }

        let event = Event(title: "New Event", user: Pointer<User>(objectId: "TestUserId"), equitableDistribution: true, teams: ["Team1"], members: ["Member1"])
        let expectation = self.expectation(description: "Save event succeeds")

        EventService.shared.saveEvent(event) { result in
            switch result {
            case .success(let savedEvent):
                XCTAssertEqual(savedEvent.objectId, "12345")
                XCTAssertNotNil(savedEvent.createdAt)
                XCTAssertNotNil(savedEvent.updatedAt)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Save event failed with error: \(error)")
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }



    func testSaveEventFailure() {
        stub(condition: isMethodPOST() && isPath("/classes/Event")) { _ in
            let stubData = """
            {
                "code": 101,
                "error": "Test error"
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 400, headers: ["Content-Type": "application/json"])
        }

        let event = Event(title: "Test Event", user: Pointer<User>(objectId: "TestUserId"), equitableDistribution: true, teams: ["Team1", "Team2"], members: ["Member1", "Member2"])
        let expectation = self.expectation(description: "Save event fails")

        eventService.saveEvent(event) { result in
            switch result {
            case .success:
                XCTFail("Save event succeeded unexpectedly")
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

    func testDeleteEventSuccess() {
        let objectId = "12345"
        var event = Event(title: "Test Event", user: Pointer<User>(objectId: "TestUserId"), equitableDistribution: true, teams: ["Team1", "Team2"], members: ["Member1", "Member2"])
        event.objectId = objectId
        
        stub(condition: isPath("/classes/Event/\(objectId)") && isMethodDELETE()) { _ in
            let stubData = """
            {}
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 200, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectation(description: "Delete event succeeds")
        
        EventService.shared.deleteEvent(event) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Delete event failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    
    func testDeleteEventFailure() {
        let objectId = "12345"
        var event = Event(title: "Test Event", user: Pointer<User>(objectId: "TestUserId"), equitableDistribution: true, teams: ["Team1", "Team2"], members: ["Member1", "Member2"])
        event.objectId = objectId

        stub(condition: isPath("/classes/Event/\(objectId)") && isMethodDELETE()) { _ in
            let stubData = """
            {
                "code": 101,
                "error": "Test error"
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 400, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectation(description: "Delete event fails")
        
        eventService.deleteEvent(event) { result in
            switch result {
            case .success:
                XCTFail("Delete event succeeded unexpectedly")
            case .failure(let error):
                if case .networkError(let message) = error {
                    XCTAssertTrue(message.contains("Test error"))
                } else {
                    XCTFail("Expected networkError but got \(error)")
                }
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    
    func testDeleteEventValidationError() {
        var event = Event(title: "Test Event", user: Pointer<User>(objectId: "TestUserId"), equitableDistribution: true, teams: ["Team1", "Team2"], members: ["Member1", "Member2"])
        event.objectId = nil 
        
        let expectation = self.expectation(description: "Delete event validation error")
        
        eventService.deleteEvent(event) { result in
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
}
