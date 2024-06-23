//
//  TeamDistributionController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import Foundation
import Combine

class TeamDistributionController: ObservableObject {
    @Published var teams: [Team]
    @Published var membersToDistribute: [Member]
    @Published var currentMember: Member? = nil
    @Published var isAnimating = false
    @Published var isLoading = false
    var timer: Timer?
    private var distributionIndex = 0

    init(teams: [Team], membersToDistribute: [Member]) {
        self.teams = teams
        self.membersToDistribute = membersToDistribute
    }

    func createTeams(names: [String]) {
        self.teams = names.map { Team(name: $0, members: []) }
    }

    func updateTeams(_ teams: [Team]) {
        self.teams = teams
    }

    func updateMembersToDistribute(event: Event) {
        self.membersToDistribute = event.members
    }

    func startDistribution(equitableDistribution: Bool) {
        guard !membersToDistribute.isEmpty else {
            return
        }
        isLoading = true
        membersToDistribute.shuffle()
        isAnimating = true
        distributionIndex = 0

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.distributeMember(equitableDistribution: equitableDistribution)
        }
    }

    private func distributeMember(equitableDistribution: Bool) {
        guard distributionIndex < membersToDistribute.count else {
            timer?.invalidate()
            timer = nil
            isAnimating = false
            isLoading = false
            return
        }

        currentMember = membersToDistribute[distributionIndex]

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let member = self.currentMember {
                let teamIndex: Int
                if equitableDistribution {
                    teamIndex = self.distributionIndex % self.teams.count
                } else {
                    teamIndex = Int.random(in: 0..<self.teams.count)
                }
                self.teams[teamIndex].members.append(member)
                self.distributionIndex += 1
                self.currentMember = nil
            }
        }
    }

    func clearTeams() {
        for index in teams.indices {
            teams[index].members.removeAll()
        }
    }
    
    func getTeams() -> [Team] {
        return teams
    }
}

