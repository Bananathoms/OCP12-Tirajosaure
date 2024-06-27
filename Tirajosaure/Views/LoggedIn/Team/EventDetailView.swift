//
//  EventDetailView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import SwiftUI
import ParseSwift

struct EventDetailView: View {
    @State var event: Event
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
                        ForEach(event.teams, id: \.self) { team in
                            VStack(alignment: .leading) {
                                Text(team)
                                    .font(.headline)
                                    .foregroundColor(.oxfordBlue)
                                ForEach(event.members.filter { $0.starts(with: team.prefix(1)) }, id: \.self) { member in
                                    OptionCard(option: member, isSelected: false)
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

                TextButton(
                    text: "Lancer le tirage",
                    isLoading: teamDistributionController.isLoading,
                    onClick: {
                        startDistribution()
                    },
                    buttonColor: .antiqueWhite,
                    textColor: .oxfordBlue
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
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
                print("ON APPEAR")
                loadEventDetails()
            }
        }
    }

    private func loadEventDetails() {
        print("LOAD EVENT DETAILS BEFORE: Teams - \(parametersController.teamNames), Members - \(optionsController.options)")

        // Mise à jour des équipes et des membres
        parametersController.numberOfTeams = event.teams.count
        parametersController.teamNames = event.teams
        optionsController.options = event.members

        print("LOAD EVENT DETAILS AFTER: Teams - \(parametersController.teamNames), Members - \(optionsController.options)")
    }
    
    private func startDistribution() {
        teamDistributionController.clearTeams()
        teamDistributionController.updateMembersToDistribute(for: event)
        teamDistributionController.startDistribution(equitableDistribution: event.equitableDistribution)
    }
}

struct EventDetailView_Previews: PreviewProvider {
    @State static var event = Event(
        title: "Tournoi de foot",
        user: Pointer<User>(objectId: "sampleUserId"),
        equitableDistribution: true,
        teams: ["Équipe 1", "Équipe 2"],
        members: ["Membre 1", "Membre 2"]
    )

    static var previews: some View {
        EventDetailView(
            event: event,
            eventController: EventController(),
            teamDistributionController: TeamDistributionController(),
            parametersController: ParametersListController(numberOfTeams: event.teams.count, teamNames: event.teams),
            optionsController: OptionsController()
        )
    }
}
