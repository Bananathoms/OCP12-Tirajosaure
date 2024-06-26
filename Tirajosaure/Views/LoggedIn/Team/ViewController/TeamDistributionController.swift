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

    func createTeams(names: [String], event: Pointer<Event>) {
        self.teams = names.map { Team(name: $0, event: event) }
    }

    func updateTeams(_ teams: [Team]) {
        self.teams = teams
    }

    func updateMembersToDistribute(for event: Event) {
        let eventPointer = Pointer<Event>(objectId: event.objectId ?? "")
        EventService.shared.fetchMembers(for: eventPointer) { [weak self] result in
            switch result {
            case .success(let members):
                print("Updated members to distribute: \(members.map { $0.name })")
                self?.membersToDistribute = members
            case .failure(let error):
                print("Failed to fetch members: \(error.localizedDescription)")
            }
        }
    }

    func startDistribution(equitableDistribution: Bool) {
        guard !membersToDistribute.isEmpty else {
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

        currentMember = membersToDistribute[distributionIndex]
        print("Distributing member: \(currentMember?.name ?? "")")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let member = self.currentMember {
                let teamIndex: Int
                if equitableDistribution {
                    teamIndex = self.distributionIndex % self.teams.count
                } else {
                    teamIndex = Int.random(in: 0..<self.teams.count)
                }

                guard let teamObjectId = self.teams[teamIndex].objectId else {
                    print("Error: Team objectId is nil")
                    return
                }

                var updatedMember = member
                updatedMember.team = Pointer(objectId: teamObjectId)
                EventService.shared.saveMember(updatedMember) { result in
                    switch result {
                    case .success(let savedMember):
                        print("Assigned \(savedMember.name) to team \(self.teams[teamIndex].name)")
                    case .failure(let error):
                        print("Failed to assign member to team: \(error.localizedDescription)")
                    }
                }
                self.distributionIndex += 1
                self.currentMember = nil
            }
        }
    }

    func clearTeams() {
        for team in teams {
            EventService.shared.fetchMembers(for: Pointer<Event>(objectId: team.event.objectId)) { result in
                switch result {
                case .success(let members):
                    for member in members {
                        var updatedMember = member
                        updatedMember.team = nil
                        EventService.shared.saveMember(updatedMember) { saveResult in
                            switch saveResult {
                            case .success(let savedMember):
                                print("Cleared team for member: \(savedMember.name)")
                            case .failure(let error):
                                print("Failed to clear team for member: \(error.localizedDescription)")
                            }
                        }
                    }
                case .failure(let error):
                    print("Failed to fetch members: \(error.localizedDescription)")
                }
            }
        }
        print("Cleared all teams.")
    }
    
    func getTeams() -> [Team] {
        return teams
    }
}
