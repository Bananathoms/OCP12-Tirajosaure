//
//  EventHistoricController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 29/06/2024.
//

import Foundation
import SwiftUI
import ParseSwift

/// Controller class responsible for managing and loading historic data of events and their team results.
class EventHistoricController: ObservableObject {
    @Published var teamsDraws: [TeamsDraw] = []
    @Published var isLoading = false
    
    /// Loads historic data for a specific event.
    /// - Parameter event: The event for which historic data is being loaded.
    func loadHistoricData(for event: Event) {
        isLoading = true
        TeamsDrawService.fetchTeamsDraw(for: event) { result in
            switch result {
            case .success(let draws):
                self.teamsDraws = draws
            case .failure(let error):
                SnackBarService.current.error(String(format: ErrorMessage.failedToLoadTeams.localized, error.localizedDescription))
            }
            self.isLoading = false
        }
    }
    
    /// Loads team results for a specific draw.
    /// - Parameter draw: The draw for which team results are being loaded.
    func loadTeamResults(for draw: TeamsDraw) {
        TeamsDrawService.fetchTeamResults(for: draw) { result in
            switch result {
            case .success(let teamResults):
                let sortedTeamsWithMembers = SortedModel.sortedTeamsWithMembers(teamResults)
                
                if let index = self.teamsDraws.firstIndex(where: { $0.objectId == draw.objectId }) {
                    self.teamsDraws[index].teamResults = sortedTeamsWithMembers
                }
            case .failure(let error):
                SnackBarService.current.error(String(format: ErrorMessage.failedToLoadTeams.localized, error.localizedDescription))
            }
        }
    }
}
