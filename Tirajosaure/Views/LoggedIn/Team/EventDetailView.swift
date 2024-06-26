//
//  EventDetailView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import SwiftUI

struct EventDetailView: View {
    @State var event: Event
    @State var teams: [Team]
    @State var equitableDistribution: Bool
    @ObservedObject var eventController: EventController
    @StateObject var teamDistributionController: TeamDistributionController
    @StateObject var parametersController: ParametersListController
    @StateObject var optionsController: OptionsController
    @Environment(\.presentationMode) var presentationMode

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(teams) { team in
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
                .padding(.bottom, 20)

                if teamDistributionController.isLoading {
                    ProgressView("Distribution en cours...")
                        .padding(.bottom, 20)
                } else {
                    TextButton(
                        text: "Lancer le tirage",
                        isLoading: false,
                        onClick: {
                            startDistribution()
                        },
                        buttonColor: .antiqueWhite,
                        textColor: .oxfordBlue
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        saveChanges()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        CustomHeader(title: event.title)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: EventEditView(event: $event, eventController: eventController)) {
                        Image(systemName: IconNames.pencilCircleFill.rawValue)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.oxfordBlue)
                            .padding(.leading, 5)
                            .padding(.top)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .background(Color.skyBlue)
            .onAppear {
                loadEventDetails()
            }
            .onDisappear {
                saveChanges()
            }
            .onReceive(teamDistributionController.$teams) { newTeams in
                self.teams = newTeams
            }
        }
    }
    
    private func saveChanges() {
        event.members = optionsController.options.map { Member(name: $0) }
        event.teams = parametersController.teamNames.map { Team(name: $0, members: []) }
        event.equitableDistribution = parametersController.equitableDistribution
        eventController.updateEvent(event, teams: event.teams, equitableDistribution: event.equitableDistribution)
    }
    
    private func loadEventDetails() {
        teams = event.teams
        optionsController.options = event.members.map { $0.name }
        parametersController.numberOfTeams = event.teams.count
        parametersController.teamNames = event.teams.map { $0.name }
    }
    
    private func startDistribution() {
        teamDistributionController.clearTeams()
        teamDistributionController.updateMembersToDistribute(event: event)
        teamDistributionController.startDistribution(equitableDistribution: event.equitableDistribution)
    }
}

struct EventDetailView_Previews: PreviewProvider {
    @State static var event = Event(
        title: "Tournoi de foot",
        members: [Member(name: "Alice"), Member(name: "Bob"), Member(name: "Charlie"), Member(name: "David")],
        teams: [Team(name: "Équipe 1", members: []), Team(name: "Équipe 2", members: [])],
        equitableDistribution: true
    )

    static var previews: some View {
        EventDetailView(
            event: event,
            teams: event.teams,
            equitableDistribution: event.equitableDistribution,
            eventController: EventController(),
            teamDistributionController: TeamDistributionController(
                teams: event.teams,
                membersToDistribute: event.members
            ),
            parametersController: ParametersListController(
                numberOfTeams: event.teams.count,
                teamNames: event.teams.map { $0.name }
            ),
            optionsController: OptionsController()
        )
        .previewDevice(PreviewDevices.iPhone14Pro.previewDevice)
        .previewDisplayName(PreviewDevices.iPhone14Pro.displayName)
        
        EventDetailView(
            event: event,
            teams: event.teams,
            equitableDistribution: event.equitableDistribution,
            eventController: EventController(),
            teamDistributionController: TeamDistributionController(
                teams: event.teams,
                membersToDistribute: event.members
            ),
            parametersController: ParametersListController(
                numberOfTeams: event.teams.count,
                teamNames: event.teams.map { $0.name }
            ),
            optionsController: OptionsController()
        )
        .previewDevice(PreviewDevices.iPhoneSE.previewDevice)
        .previewDisplayName(PreviewDevices.iPhoneSE.displayName)
    }
}
