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
    @StateObject private var optionsController = OptionsController()
    @Environment(\.presentationMode) var presentationMode

    init(event: Binding<Event>, eventController: EventController) {
        self._event = event
        self.eventController = eventController
        self._parametersController = StateObject(wrappedValue: ParametersListController(numberOfTeams: 0, teamNames: []))
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
                    
                }
            }
            .padding(.top)
            .background(Color.skyBlue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        
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
        EventService.shared.fetchTeams(for: Pointer<Event>(objectId: event.objectId ?? "")) { result in
            switch result {
            case .success(let teams):
                let teamNames = teams.map { $0.name }
                DispatchQueue.main.async {
                    self.parametersController.numberOfTeams = teams.count
                    self.parametersController.teamNames = teamNames
                }
            case .failure(let error):
                print("Failed to fetch teams: \(error.localizedDescription)")
            }
        }
        EventService.shared.fetchMembers(for: Pointer<Event>(objectId: event.objectId ?? "")) { result in
            switch result {
            case .success(let members):
                DispatchQueue.main.async {
                    self.optionsController.options = members.map { $0.name }
                }
            case .failure(let error):
                print("Failed to fetch members: \(error.localizedDescription)")
            }
        }
    }


}

struct EventEditView_Previews: PreviewProvider {
    @State static var event = Event(
        title: "Tournoi de foot",
        user: Pointer<User>(objectId: "sampleUserId")
    )

    static var previews: some View {
        EventEditView(event: $event, eventController: EventController())
    }
}
