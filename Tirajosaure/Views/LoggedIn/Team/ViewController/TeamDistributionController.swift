//
//  TeamDistributionController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import Foundation
import Combine
import ParseSwift

class TeamDistributionController: ObservableObject {
    @Published var teams: [TeamResult] = []
    @Published var isLoading = false
    var membersToDistribute: [String] = []

    func updateMembersToDistribute(for event: Event) {
        self.membersToDistribute = event.members
    }

    func startDistribution(equitableDistribution: Bool) {
        guard !teams.isEmpty else { return }
        self.isLoading = true
        DispatchQueue.global().async {
            var teamMembers: [[String]] = Array(repeating: [], count: self.teams.count)
            var currentIndex = 0

            for member in self.membersToDistribute {
                teamMembers[currentIndex].append(member)
                currentIndex = (currentIndex + 1) % self.teams.count
            }

            DispatchQueue.main.async {
                for (index, team) in self.teams.enumerated() {
                    self.teams[index].members = teamMembers[index]
                }
                self.isLoading = false
            }
        }
    }

    func clearTeams() {
        teams = []
    }
}
