//
//  EventEditView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 26/06/2024.
//

import SwiftUI
import ParseSwift

struct EventEditView: View {
    @Binding var event: Event
    @ObservedObject var eventController: EventController
    @StateObject private var parametersController: ParametersListController
    @StateObject private var optionsController: OptionsController
    @Environment(\.presentationMode) var presentationMode
    
    init(event: Binding<Event>, eventController: EventController) {
        self._event = event
        self.eventController = eventController
        
        let paramsController = ParametersListController(numberOfTeams: event.wrappedValue.teams.count, teamNames: event.wrappedValue.teams)
        let optsController = OptionsController()
        optsController.options = event.wrappedValue.members
        
        _parametersController = StateObject(wrappedValue: paramsController)
        _optionsController = StateObject(wrappedValue: optsController)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        ReusableTextField(
                            hint: $event.title,
                            icon: nil,
                            title: LocalizedString.eventName.localized,
                            fieldName: LocalizedString.eventName.localized
                        )
                        
                        ParametersList(title: LocalizedString.eventParameters.localized, controller: parametersController)
                        
                        OptionsListView(title: LocalizedString.membersListPlaceholder.localized, addElement: LocalizedString.addMember.localized, element: LocalizedString.member.localized, controller: optionsController)
                    }
                }
                .onAppear {
                    MixpanelEvent.editEventButtonClicked.trackEvent()
                    loadEventDetails()
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
                        CustomHeader(title: LocalizedString.editEvent.localized)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func loadEventDetails() {
        parametersController.equitableDistribution = event.equitableDistribution
        parametersController.numberOfTeams = event.teams.count
        parametersController.teamNames = event.teams
        optionsController.options = event.members
    }
    
    private func saveChanges() {
        event.equitableDistribution = parametersController.equitableDistribution
        event.teams = parametersController.teamNames
        event.members = optionsController.options
        eventController.updateEvent(event: event, parametersController: parametersController, optionsController: optionsController) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                SnackBarService.current.error(ErrorMessage.failedToUpdateEvent.localized + ": \(error.localizedDescription)")
            }
        }
    }
}

struct EventEditView_Previews: PreviewProvider {
    @State static var event = Event(
        title: "Tournoi de foot",
        user: Pointer<User>(objectId: "sampleUserId"),
        equitableDistribution: true,
        teams: ["Équipe 1", "Équipe 2"],
        members: ["Membre 1", "Membre 2"]
    )
    
    static var previews: some View {
        EventEditView(event: $event, eventController: EventController())
    }
}
