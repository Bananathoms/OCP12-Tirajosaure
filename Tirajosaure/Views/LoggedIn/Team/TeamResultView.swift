//
//  TeamResultView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import SwiftUI

struct TeamsResultView: View {
    @ObservedObject var teamDistributionController: TeamDistributionController
    @State var equitableDistribution: Bool

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(teamDistributionController.teams) { team in
                        VStack(alignment: .leading) {
                            Text(team.name)
                                .font(.headline)
                                .foregroundColor(.oxfordBlue)
                            ForEach(team.members) { member in
                                OptionCard(option: member.name, isSelected: false)
                            }
                        }
                        .padding()
                        .background(Color.antiqueWhite)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
                .padding()
            }

            VStack {
                if let currentMember = teamDistributionController.currentMember {
                    VStack {
                        OptionCard(option: currentMember.name, isSelected: false)
                            .padding()
                    }
                }
                if !teamDistributionController.isAnimating {
                    TextButton(
                        text: "Lancer le tirage",
                        isLoading: teamDistributionController.isLoading,
                        onClick: {
                            teamDistributionController.clearTeams()
                            
                            teamDistributionController.startDistribution(equitableDistribution: equitableDistribution)
                        },
                        buttonColor: .antiqueWhite,
                        textColor: .oxfordBlue
                    )
                    .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 20)
        }
        .onDisappear {
            teamDistributionController.timer?.invalidate()
        }
        .navigationTitle("Équipes")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.skyBlue)
    }
}

struct TeamsResultView_Previews: PreviewProvider {
    static var previews: some View {
        TeamsResultView(
            teamDistributionController: TeamDistributionController(teams: [
                Team(name: "Équipe 1", members: []),
                Team(name: "Équipe 2", members: []),
                Team(name: "Équipe 3", members: [])
            ], membersToDistribute: [
                Member(name: "Membre 1"),
                Member(name: "Membre 2"),
                Member(name: "Membre 3"),
                Member(name: "Membre 4")
            ]),
            equitableDistribution: true
        )
    }
}
