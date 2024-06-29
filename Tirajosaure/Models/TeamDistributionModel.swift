//
//  TeamDistributionModel.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 29/06/2024.
//

import Foundation
import ParseSwift

/// A model responsible for managing the distribution of team members for events.
struct TeamDistributionModel {
    
    /// Initializes the teams for a given event.
    /// - Parameter event: The event for which teams are being initialized.
    /// - Returns: An array of `TeamResult` representing the initialized teams.
    static func initializeTeams(for event: Event) -> [TeamResult] {
        return event.teams.map { teamName in
            TeamResult(name: teamName, members: [], draw: Pointer<TeamsDraw>(objectId: DefaultValues.emptyString))
        }
    }
    
    /// Updates the list of members to be distributed for a given event.
    /// - Parameter event: The event for which members are being updated.
    /// - Returns: An array of strings representing the members to be distributed.
    static func updateMembersToDistribute(for event: Event) -> [String] {
        return event.members
    }
    
    /// Adds a member to the team with the fewest members, ensuring equitable distribution.
    /// - Parameters:
    ///   - member: The member to be added.
    ///   - teams: The teams to which the member should be added.
    static func addMemberEquitably(_ member: String, to teams: inout [TeamResult]) {
        if let minIndex = teams.indices.min(by: { teams[$0].members.count < teams[$1].members.count }) {
            teams[minIndex].members.append(member)
        }
    }
    
    /// Adds a member to a random team.
    /// - Parameters:
    ///   - member: The member to be added.
    ///   - teams: The teams to which the member should be added.
    static func addMemberRandomly(_ member: String, to teams: inout [TeamResult]) {
        let randomIndex = Int.random(in: 0..<teams.count)
        teams[randomIndex].members.append(member)
    }
    
    /// Clears all members from the given teams.
    /// - Parameter teams: The teams to be cleared.
    static func clearTeams(_ teams: inout [TeamResult]) {
        for i in 0..<teams.count {
            teams[i].members.removeAll()
        }
    }
}
