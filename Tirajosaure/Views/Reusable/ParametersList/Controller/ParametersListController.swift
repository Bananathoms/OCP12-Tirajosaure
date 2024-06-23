//
//  ParametersListController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import Foundation
import Combine

class ParametersListController: ObservableObject {
    @Published var numberOfTeams: Int {
        didSet {
            updateTeamNames()
        }
    }
    @Published var teamNames: [String]
    @Published var equitableDistribution: Bool
    
    init(numberOfTeams: Int, teamNames: [String], equitableDistribution: Bool = true) {
        self.numberOfTeams = numberOfTeams
        self.teamNames = teamNames
        self.equitableDistribution = equitableDistribution
        updateTeamNames()
    }
    
    func updateTeamNames() {
        if teamNames.count < numberOfTeams {
            for _ in teamNames.count..<numberOfTeams {
                teamNames.append("Équipe \(teamNames.count + 1)")
            }
        } else if teamNames.count > numberOfTeams {
            teamNames = Array(teamNames.prefix(numberOfTeams))
        }
    }
    
    func updateTeamName(at index: Int, with newName: String) {
        guard index >= 0 && index < teamNames.count else { return }
        teamNames[index] = newName
    }
}
