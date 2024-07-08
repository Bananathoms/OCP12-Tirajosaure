//
//  SortedModel.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 29/06/2024.
//

import Foundation

/// A model responsible for sorting team results and their members.
struct SortedModel {
    
    /// Sorts the given team results by team name and their members by name.
    /// - Parameter teamResults: The list of `TeamResult` to be sorted.
    /// - Returns: A sorted list of `TeamResult` where both the teams and their members are sorted alphabetically.
    static func sortedTeamsWithMembers(_ teamResults: [TeamResult]) -> [TeamResult] {
        let sortedTeamResults = teamResults.sorted { $0.name < $1.name }
        
        let sortedTeamsWithMembers = sortedTeamResults.map { teamResult -> TeamResult in
            var sortedTeamResult = teamResult
            sortedTeamResult.members = teamResult.members.sorted()
            return sortedTeamResult
        }
        
        return sortedTeamsWithMembers
    }
}
