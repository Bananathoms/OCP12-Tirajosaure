//
//  TeamDistributionController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import Foundation
import Combine
import ParseSwift

/// Controller class responsible for managing the distribution of team members.
class TeamDistributionController: ObservableObject {
    @Published var teams: [TeamResult] = []
    @Published var isLoading = false
    @Published var currentMember: String?
    var membersToDistribute: [String] = []
    var teamsDraw: TeamsDraw?
    
    /// Initializes teams based on the provided event.
    /// - Parameter event: The event for which teams are being initialized.
    func initializeTeams(for event: Event) {
        self.teams = TeamDistributionModel.initializeTeams(for: event)
    }
    
    /// Updates the list of members to be distributed based on the provided event.
    /// - Parameter event: The event for which members are being updated.
    func updateMembersToDistribute(for event: Event) {
        self.membersToDistribute = TeamDistributionModel.updateMembersToDistribute(for: event)
    }
    
    /// Starts the distribution of members into teams.
    /// - Parameter equitableDistribution: A boolean indicating whether the distribution should be equitable.
    func startDistribution(equitableDistribution: Bool) {
        guard !teams.isEmpty else { return }
        self.isLoading = true

        DispatchQueue.global().async {
            var members = self.membersToDistribute.shuffled()
            while !members.isEmpty {
                let member = members.removeFirst()

                DispatchQueue.main.async {
                    self.currentMember = member
                }

                Thread.sleep(forTimeInterval: 2.0)
                DispatchQueue.main.async {
                    self.currentMember = nil
                    if equitableDistribution {
                        TeamDistributionModel.addMemberEquitably(member, to: &self.teams)
                    } else {
                        TeamDistributionModel.addMemberRandomly(member, to: &self.teams)
                    }
                }

                Thread.sleep(forTimeInterval: 0.5)
            }

            DispatchQueue.main.async {
                self.isLoading = false
                self.saveTeamsDraw()
            }
        }
    }
    
    /// Saves the teams draw to the server.
    private func saveTeamsDraw() {
        guard let teamsDraw = self.teamsDraw else { return }
        TeamsDrawService.saveTeamsDraw(teamsDraw) { result in
            switch result {
            case .success(let savedDraw):
                for team in self.teams {
                    var teamToSave = team
                    teamToSave.draw = Pointer<TeamsDraw>(objectId: savedDraw.objectId!)
                    TeamsDrawService.saveTeamResult(teamToSave) { _ in }
                }
            case .failure(let error):
                SnackBarService.current.error(String(format: ErrorMessage.failedToSaveTeam.localized, error.localizedDescription))
            }
        }
    }
    
    /// Clears the members from all teams.
    func clearTeams() {
        TeamDistributionModel.clearTeams(&self.teams)
    }
}
