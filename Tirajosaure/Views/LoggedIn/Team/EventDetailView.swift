//
//  EventDetailView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import SwiftUI

struct EventDetailView: View {
    @ObservedObject var eventController: EventController
    @State private var event: Event
    @StateObject private var parametersController: ParametersListController
    @StateObject private var optionsController = OptionsController()
    @StateObject private var teamDistributionController: TeamDistributionController
    @State private var isLoading = false
    @Environment(\.presentationMode) var presentationMode
    @State private var eventName: String
    @State private var navigateToResult = false
    @State private var errorMessage: String?
    
    init(event: Event, eventController: EventController) {
        self._event = State(initialValue: event)
        self.eventController = eventController
        self._eventName = State(initialValue: event.title)
        let initialTeamNames = ["Équipe 1", "Équipe 2"]
        let teamNames = event.teams.isEmpty ? initialTeamNames : event.teams.map { $0.name }
        self._parametersController = StateObject(wrappedValue: ParametersListController(numberOfTeams: teamNames.count, teamNames: teamNames, equitableDistribution: event.equitableDistribution))
           self._teamDistributionController = StateObject(wrappedValue: TeamDistributionController(teams: event.teams, membersToDistribute: event.members))
       }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Nom de l'évènement")
                            .font(.headline)
                            .padding(.leading, 20)

                        ReusableTextField(
                            hint: $eventName,
                            icon: IconNames.pencil.rawValue,
                            title: nil,
                            fieldName: eventName
                        )

                        Text("Paramètre de l'évènement")
                            .font(.headline)
                            .padding(.leading, 20)
                        ParametersList(controller: parametersController)
                            .frame(height: CGFloat(140.0 + Double(parametersController.numberOfTeams) * 44.0))

                        VStack(alignment: .leading) {
                            Text("Liste des membres")
                                .font(.headline)
                                .padding(.leading, 20)

                            OptionsListView(controller: optionsController)
                                .frame(height: CGFloat(optionsController.options.count) * 44.0 + 50.0)
                        }
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding(.leading, 20)
                        }
                    }
                    .padding(.bottom, 20)
                }

                TextButton(
                    text: "Effectuer le tirage",
                    isLoading: isLoading,
                    onClick: {
                        performDraw()
                    },
                    buttonColor: .antiqueWhite,
                    textColor: .oxfordBlue
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .navigationDestination(isPresented: $navigateToResult) {
                    TeamsResultView(
                        teamDistributionController: teamDistributionController,
                        equitableDistribution: parametersController.equitableDistribution
                    )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        CustomHeader(title: event.title, showBackButton: true)
                    }
                }
            }
            .onAppear {
                parametersController.updateTeamNames()
                optionsController.options = event.members.map { $0.name }
            }
            .onDisappear {
                event.members = optionsController.options.map { Member(name: $0) }
            }
            .background(Color.skyBlue)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func performDraw() {
        guard optionsController.options.count >= parametersController.numberOfTeams else {
            SnackBarService.current.error("Le nombre de membres doit être au moins égal au nombre d'équipes.")
            errorMessage = "Le nombre de membres doit être au moins égal au nombre d'équipes."
            return
        }

        isLoading = true
        teamDistributionController.createTeams(names: parametersController.teamNames)
        
        event.title = eventName
        event.members = optionsController.options.map { Member(name: $0) }
        
        eventController.updateEvent(event, teams: teamDistributionController.teams, equitableDistribution: parametersController.equitableDistribution)
        
        teamDistributionController.updateMembersToDistribute(event: event)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            navigateToResult = true
        }
    }

}

struct EventDetailView_Previews: PreviewProvider {
    @StateObject static var controller = EventController()

    static var previews: some View {
        Group {
            EventDetailView(
                event: Event(title: "Tournoi de foot", members: [Member(name: "Alice"), Member(name: "Bob"), Member(name: "Charlie"), Member(name: "David")]),
                eventController: controller
            )
            .previewDevice(PreviewDevices.iPhone14Pro.previewDevice)
            .previewDisplayName(PreviewDevices.iPhone14Pro.displayName)

            EventDetailView(
                event: Event(title: "Tournoi de foot", members: [Member(name: "Alice"), Member(name: "Bob"), Member(name: "Charlie"), Member(name: "David")]),
                eventController: controller
            )
            .previewDevice(PreviewDevices.iPhoneSE.previewDevice)
            .previewDisplayName(PreviewDevices.iPhoneSE.displayName)
        }
    }
}
