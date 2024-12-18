//
//  TeamDistributionModelTests.swift
//  TirajosaureTests
//
//  Created by Thomas Carlier on 29/06/2024.
//

import Foundation
import XCTest
@testable import Tirajosaure
import ParseSwift

class TeamDistributionModelTests: XCTestCase {
    
    func testInitializeTeams() {
        let event = Event(title: "Test Event", user: Pointer<User>(objectId: "TestUserId"), equitableDistribution: true, teams: ["Team1", "Team2"], members: ["Member1", "Member2"])
        let teams = TeamDistributionModel.initializeTeams(for: event)
        
        XCTAssertEqual(teams.count, 2)
        XCTAssertEqual(teams[0].name, "Team1")
        XCTAssertEqual(teams[1].name, "Team2")
        XCTAssertTrue(teams[0].members.isEmpty)
        XCTAssertTrue(teams[1].members.isEmpty)
    }
    
    func testUpdateMembersToDistribute() {
        let event = Event(title: "Test Event", user: Pointer<User>(objectId: "TestUserId"), equitableDistribution: true, teams: ["Team1", "Team2"], members: ["Member1", "Member2"])
        let members = TeamDistributionModel.updateMembersToDistribute(for: event)
        
        XCTAssertEqual(members, ["Member1", "Member2"])
    }
    
    func testAddMemberEquitably() {
        var teams = [
            TeamResult(name: "Team1", members: ["Member1"], draw: Pointer<TeamsDraw>(objectId: "DrawId")),
            TeamResult(name: "Team2", members: [], draw: Pointer<TeamsDraw>(objectId: "DrawId"))
        ]
        
        TeamDistributionModel.addMemberEquitably("Member2", to: &teams)
        
        XCTAssertEqual(teams[0].members.count, 1)
        XCTAssertEqual(teams[1].members.count, 1)
        XCTAssertEqual(teams[1].members[0], "Member2")
    }
    
    func testAddMemberRandomly() {
        var teams = [
            TeamResult(name: "Team1", members: [], draw: Pointer<TeamsDraw>(objectId: "DrawId")),
            TeamResult(name: "Team2", members: [], draw: Pointer<TeamsDraw>(objectId: "DrawId"))
        ]
        
        TeamDistributionModel.addMemberRandomly("Member1", to: &teams)
        TeamDistributionModel.addMemberRandomly("Member2", to: &teams)
        
        let totalMembers = teams.reduce(0) { $0 + $1.members.count }
        XCTAssertEqual(totalMembers, 2)
    }
    
    func testClearTeams() {
        var teams = [
            TeamResult(name: "Team1", members: ["Member1"], draw: Pointer<TeamsDraw>(objectId: "DrawId")),
            TeamResult(name: "Team2", members: ["Member2"], draw: Pointer<TeamsDraw>(objectId: "DrawId"))
        ]
        
        TeamDistributionModel.clearTeams(&teams)
        
        XCTAssertTrue(teams[0].members.isEmpty)
        XCTAssertTrue(teams[1].members.isEmpty)
    }
}
