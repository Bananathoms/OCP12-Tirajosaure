//
//  EventEditView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 26/06/2024.
//

import SwiftUI

struct EventEditView: View {
    @Binding var event: Event
    @ObservedObject var eventController: EventController
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var parametersController: ParametersListController
    @StateObject private var optionsController = OptionsController()
    
    init(event: Binding<Event>, eventController: EventController) {
        self._event = event
        self.eventController = eventController
        self._parametersController = StateObject(wrappedValue: ParametersListController(numberOfTeams: event.wrappedValue.teams.count, teamNames: event.wrappedValue.teams.map { $0.name }))
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
                            hint: $event.title,
                            icon: nil,
                            title: nil,
                            fieldName: "Nom de l'évènement"
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
                    }
                    .padding(.bottom, 20)
                }
                .onAppear {
                    loadEventDetails()
                }
                .onDisappear {
                    saveChanges()
                }
            }
            .padding(.top)
            .background(Color.skyBlue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        saveChanges()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        CustomHeader(title: "Modifier un évènement")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func loadEventDetails() {
        optionsController.options = event.members.map { $0.name }
        parametersController.numberOfTeams = event.teams.count
        parametersController.teamNames = event.teams.map { $0.name }
    }
    
    private func saveChanges() {
        event.members = optionsController.options.map { Member(name: $0) }
        event.teams = parametersController.teamNames.map { Team(name: $0, members: []) }
        event.equitableDistribution = parametersController.equitableDistribution
        eventController.updateEvent(event, teams: event.teams, equitableDistribution: event.equitableDistribution)
    }
}

struct EventEditView_Previews: PreviewProvider {
    @State static var event = Event(
        title: "Tournoi de foot",
        members: [Member(name: "Alice"), Member(name: "Bob"), Member(name: "Charlie"), Member(name: "David")],
        teams: [Team(name: "Équipe 1", members: []), Team(name: "Équipe 2", members: [])],
        equitableDistribution: true
    )
    
    static var previews: some View {
        EventEditView(event: $event, eventController: EventController())
    }
}
