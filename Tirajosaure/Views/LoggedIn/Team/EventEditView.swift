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
                    VStack(alignment: .leading, spacing: 20) {
                        Text(LocalizedString.eventName.localized)
                            .font(.headline)
                            .padding(.leading, 20)

                        ReusableTextField(
                            hint: $event.title,
                            icon: nil,
                            title: nil,
                            fieldName: LocalizedString.eventName.localized
                        )

                        Text(LocalizedString.eventParameters.localized)
                            .font(.headline)
                            .padding(.leading, 20)

                        ParametersList(controller: parametersController)
                            .frame(height: CGFloat(140.0 + Double(parametersController.numberOfTeams) * 44.0))

                        VStack(alignment: .leading) {
                            Text(LocalizedString.memberList.localized)
                                .font(.headline)
                                .padding(.leading, 20)

                            OptionsListView(controller: optionsController)
                                .frame(height: CGFloat(optionsController.options.count) * 44.0 + 50.0)
                        }
                    }
                    .padding(.bottom, 20)
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
