//
//  TeamsDrawServiceTests.swift
//  TirajosaureTests
//
//  Created by Thomas Carlier on 29/06/2024.
//

import Foundation
import XCTest
@testable import Tirajosaure
import ParseSwift
import OHHTTPStubs
import Alamofire

class TeamsDrawServiceTests: XCTestCase {

    var teamsDrawService: TeamsDrawService!
    var apiService: ApiService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        teamsDrawService = TeamsDrawService.shared
        apiService = ApiService.current
        HTTPStubs.removeAllStubs()
    }
    
    override func tearDownWithError() throws {
        teamsDrawService = nil
        apiService = nil
        HTTPStubs.removeAllStubs()
        try super.tearDownWithError()
    }

    func testSaveTeamsDrawSuccess() {
        stub(condition: isMethodPOST() && isPath("/classes/TeamsDraw")) { _ in
            let stubData = """
            {
                "objectId": "TeamsDrawId",
                "createdAt": "2024-06-28T21:48:41.085Z",
                "updatedAt": "2024-06-28T21:48:41.085Z"
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 201, headers: ["Content-Type": "application/json"])
        }

        let teamsDraw = TeamsDraw(date: Date(), event: ParseSwift.Pointer<Tirajosaure.Event>(objectId: "EventId"))
        let expectation = self.expectation(description: "Save TeamsDraw succeeds")

        teamsDrawService.saveTeamsDraw(teamsDraw) { result in
            switch result {
            case .success(let savedTeamsDraw):
                XCTAssertEqual(savedTeamsDraw.objectId, "TeamsDrawId")
                XCTAssertNotNil(savedTeamsDraw.createdAt)
                XCTAssertNotNil(savedTeamsDraw.updatedAt)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Save TeamsDraw failed with error: \(error)")
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSaveTeamsDrawFailure() {
        stub(condition: isMethodPOST() && isPath("/classes/TeamsDraw")) { _ in
            let stubData = """
            {
                "code": 101,
                "error": "Test error"
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 400, headers: ["Content-Type": "application/json"])
        }

        let teamsDraw = TeamsDraw(date: Date(), event: ParseSwift.Pointer<Tirajosaure.Event>(objectId: "EventId"))
        let expectation = self.expectation(description: "Save TeamsDraw fails")

        teamsDrawService.saveTeamsDraw(teamsDraw) { result in
            switch result {
            case .success:
                XCTFail("Save TeamsDraw succeeded unexpectedly")
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

    func testFetchTeamsDrawSuccess() {
        stub(condition: isPath("/classes/TeamsDraw") && isMethodGET()) { _ in
            let stubData = """
            {
                "results": [
                    {
                        "objectId": "TeamsDrawId",
                        "date": {
                            "__type": "Date",
                            "iso": "2024-06-28T21:48:41.085Z"
                        },
                        "event": {
                            "__type": "Pointer",
                            "className": "Event",
                            "objectId": "EventId"
                        }
                    }
                ]
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 200, headers: ["Content-Type": "application/json"])
        }

        var event = Event(title: "Test Event", user: Pointer<User>(objectId: "TestUserId"), equitableDistribution: true, teams: [], members: [])
        event.objectId = "EventId"
        let expectation = self.expectation(description: "Fetch TeamsDraw succeeds")

        teamsDrawService.fetchTeamsDraw(for: event) { result in
            switch result {
            case .success(let teamsDraws):
                XCTAssertEqual(teamsDraws.count, 1)
                XCTAssertEqual(teamsDraws.first?.objectId, "TeamsDrawId")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Fetch TeamsDraw failed with error: \(error)")
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchTeamsDrawFailure() {
        stub(condition: isPath("/classes/TeamsDraw") && isMethodGET()) { _ in
            let stubData = """
            {
                "code": 101,
                "error": "Test error"
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 400, headers: ["Content-Type": "application/json"])
        }

        var event = Event(title: "Test Event", user: Pointer<User>(objectId: "TestUserId"), equitableDistribution: true, teams: [], members: [])
        event.objectId = "EventId"
        let expectation = self.expectation(description: "Fetch TeamsDraw fails")

        teamsDrawService.fetchTeamsDraw(for: event) { result in
            switch result {
            case .success:
                XCTFail("Fetch TeamsDraw succeeded unexpectedly")
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
    
    func testDeleteTeamsDrawsSuccess() {
         let eventPointer = Pointer<Tirajosaure.Event>(objectId: "EventId")

         stub(condition: isPath("/classes/TeamsDraw") && isMethodGET()) { _ in
             let stubData = """
             {
                 "results": [
                     { "objectId": "TeamsDrawId1", "date": { "__type": "Date", "iso": "\(DateFormatter.iso8601Full.string(from: Date()))" }, "event": { "__type": "Pointer", "className": "Event", "objectId": "EventId" } },
                     { "objectId": "TeamsDrawId2", "date": { "__type": "Date", "iso": "\(DateFormatter.iso8601Full.string(from: Date()))" }, "event": { "__type": "Pointer", "className": "Event", "objectId": "EventId" } }
                 ]
             }
             """.data(using: .utf8)!
             return HTTPStubsResponse(data: stubData, statusCode: 200, headers: ["Content-Type": "application/json"])
         }

         stub(condition: isPath("/classes/TeamResult") && isMethodGET() && containsQueryParams(["where": "{\"draw\":{\"__type\":\"Pointer\",\"className\":\"TeamsDraw\",\"objectId\":\"TeamsDrawId1\"}}"])) { _ in
             let stubData = """
             {
                 "results": [
                     { "objectId": "TeamResultId1", "name": "Team1", "members": ["Member1"], "draw": { "__type": "Pointer", "className": "TeamsDraw", "objectId": "TeamsDrawId1" } },
                     { "objectId": "TeamResultId2", "name": "Team2", "members": ["Member2"], "draw": { "__type": "Pointer", "className": "TeamsDraw", "objectId": "TeamsDrawId1" } }
                 ]
             }
             """.data(using: .utf8)!
             return HTTPStubsResponse(data: stubData, statusCode: 200, headers: ["Content-Type": "application/json"])
         }

         stub(condition: isPath("/classes/TeamResult/TeamResultId1") && isMethodDELETE()) { _ in
             return HTTPStubsResponse(data: "{}".data(using: .utf8)!, statusCode: 200, headers: ["Content-Type": "application/json"])
         }

         stub(condition: isPath("/classes/TeamResult/TeamResultId2") && isMethodDELETE()) { _ in
             return HTTPStubsResponse(data: "{}".data(using: .utf8)!, statusCode: 200, headers: ["Content-Type": "application/json"])
         }

         stub(condition: isPath("/classes/TeamsDraw/TeamsDrawId1") && isMethodDELETE()) { _ in
             return HTTPStubsResponse(data: "{}".data(using: .utf8)!, statusCode: 200, headers: ["Content-Type": "application/json"])
         }

         stub(condition: isPath("/classes/TeamResult") && isMethodGET() && containsQueryParams(["where": "{\"draw\":{\"__type\":\"Pointer\",\"className\":\"TeamsDraw\",\"objectId\":\"TeamsDrawId2\"}}"])) { _ in
             let stubData = """
             {
                 "results": [
                     { "objectId": "TeamResultId3", "name": "Team3", "members": ["Member3"], "draw": { "__type": "Pointer", "className": "TeamsDraw", "objectId": "TeamsDrawId2" } },
                     { "objectId": "TeamResultId4", "name": "Team4", "members": ["Member4"], "draw": { "__type": "Pointer", "className": "TeamsDraw", "objectId": "TeamsDrawId2" } }
                 ]
             }
             """.data(using: .utf8)!
             return HTTPStubsResponse(data: stubData, statusCode: 200, headers: ["Content-Type": "application/json"])
         }

         stub(condition: isPath("/classes/TeamResult/TeamResultId3") && isMethodDELETE()) { _ in
             return HTTPStubsResponse(data: "{}".data(using: .utf8)!, statusCode: 200, headers: ["Content-Type": "application/json"])
         }

         stub(condition: isPath("/classes/TeamResult/TeamResultId4") && isMethodDELETE()) { _ in
             return HTTPStubsResponse(data: "{}".data(using: .utf8)!, statusCode: 200, headers: ["Content-Type": "application/json"])
         }

         // Stub for deleting TeamsDrawId2
         stub(condition: isPath("/classes/TeamsDraw/TeamsDrawId2") && isMethodDELETE()) { _ in
             return HTTPStubsResponse(data: "{}".data(using: .utf8)!, statusCode: 200, headers: ["Content-Type": "application/json"])
         }

         let expectation = self.expectation(description: "Delete TeamsDraws succeeds")

         teamsDrawService.deleteTeamsDraws(for: eventPointer) { result in
             switch result {
             case .success:
                 expectation.fulfill()
             case .failure(let error):
                 XCTFail("Delete TeamsDraws failed with error: \(error)")
             }
         }

         waitForExpectations(timeout: 5, handler: nil)
     }
    
    func testSaveTeamResultSuccess() {
        let teamResult = TeamResult(name: "Team1", members: ["Member1"], draw: Pointer<TeamsDraw>(objectId: "TeamsDrawId"))
        
        stub(condition: isPath("/classes/TeamResult") && isMethodPOST()) { _ in
            let stubData = """
            {
                "objectId": "TeamResultId1",
                "createdAt": "2024-06-29T21:48:41.085Z",
                "updatedAt": "2024-06-29T21:48:41.085Z",
                "name": "\(teamResult.name)",
                "members": ["Member1"],
                "draw": { "__type": "Pointer", "className": "TeamsDraw", "objectId": "\(teamResult.draw.objectId)" }
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 201, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectation(description: "Save team result succeeds")
        
        teamsDrawService.saveTeamResult(teamResult) { result in
            switch result {
            case .success(let savedResult):
                XCTAssertEqual(savedResult.objectId, "TeamResultId1")
                XCTAssertEqual(savedResult.name, "Team1")
                XCTAssertEqual(savedResult.members, ["Member1"])
                XCTAssertEqual(savedResult.draw.objectId, "TeamsDrawId")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Save team result failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSaveTeamResultFailure() {
        let teamResult = TeamResult(name: "Team1", members: ["Member1"], draw: Pointer<TeamsDraw>(objectId: "TeamsDrawId"))
        
        stub(condition: isPath("/classes/TeamResult") && isMethodPOST()) { _ in
            let stubData = """
            {
                "code": 101,
                "error": "Test error"
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 400, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectation(description: "Save team result fails")
        
        teamsDrawService.saveTeamResult(teamResult) { result in
            switch result {
            case .success:
                XCTFail("Save team result succeeded unexpectedly")
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
    
    func testDeleteTeamResultsGroupSuccess() {
        var teamsDraw = TeamsDraw(date: Date(), event: Pointer<Tirajosaure.Event>(objectId: "EventId"))
        teamsDraw.objectId = "TeamsDrawId"

        stub(condition: isPath("/classes/TeamResult") && isMethodGET() && containsQueryParams(["where": "{\"draw\":{\"__type\":\"Pointer\",\"className\":\"TeamsDraw\",\"objectId\":\"TeamsDrawId\"}}"])) { _ in
            let stubData = """
            {
                "results": [
                    { "objectId": "TeamResultId1", "name": "Team1", "members": ["Member1"], "draw": { "__type": "Pointer", "className": "TeamsDraw", "objectId": "TeamsDrawId" } },
                    { "objectId": "TeamResultId2", "name": "Team2", "members": ["Member2"], "draw": { "__type": "Pointer", "className": "TeamsDraw", "objectId": "TeamsDrawId" } }
                ]
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 200, headers: ["Content-Type": "application/json"])
        }

        stub(condition: isPath("/classes/TeamResult/TeamResultId1") && isMethodDELETE()) { _ in
            return HTTPStubsResponse(data: "{}".data(using: .utf8)!, statusCode: 200, headers: ["Content-Type": "application/json"])
        }
        
        stub(condition: isPath("/classes/TeamResult/TeamResultId2") && isMethodDELETE()) { _ in
            return HTTPStubsResponse(data: "{}".data(using: .utf8)!, statusCode: 200, headers: ["Content-Type": "application/json"])
        }

        let expectation = self.expectation(description: "Delete team results succeeds")

        teamsDrawService.deleteTeamResults(for: teamsDraw) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Delete team results failed with error: \(error)")
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}


