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
        print("Initialized with teams: \(teams.map { $0.name }), members: \(membersToDistribute.map { $0.name })")
    }

    func createTeams(names: [String]) {
        self.teams = names.map { Team(name: $0, members: []) }
        print("Created teams: \(names)")
    }

    func updateTeams(_ teams: [Team]) {
        self.teams = teams
        print("Updated teams: \(teams.map { $0.name })")
    }

    func updateMembersToDistribute(event: Event) {
        self.membersToDistribute = event.members
        print("Updated members to distribute: \(membersToDistribute.map { $0.name })")
    }

    func startDistribution(equitableDistribution: Bool) {
        guard !membersToDistribute.isEmpty else {
            print("No members to distribute.")
            return
        }
        isLoading = true
        membersToDistribute.shuffle()
        print("Shuffled members to distribute: \(membersToDistribute.map { $0.name })")
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
            print("Distribution complete.")
            return
        }

        // Ensure we don't assign the same member twice in the same cycle
        if currentMember == nil {
            currentMember = membersToDistribute[distributionIndex]
            print("Distributing member: \(currentMember?.name ?? "None")")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let member = self.currentMember {
                let teamIndex: Int
                if equitableDistribution {
                    teamIndex = self.distributionIndex % self.teams.count
                } else {
                    teamIndex = Int.random(in: 0..<self.teams.count)
                }
                self.teams[teamIndex].members.append(member)
                print("Assigned \(member.name) to team \(self.teams[teamIndex].name)")
                self.distributionIndex += 1
                self.currentMember = nil
            }
        }
    }

    func clearTeams() {
        for index in teams.indices {
            teams[index].members.removeAll()
        }
        print("Cleared all teams.")
    }
    
    func getTeams() -> [Team] {
        return teams
    }
}
