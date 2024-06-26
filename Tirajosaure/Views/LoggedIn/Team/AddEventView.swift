//
//  AddEventView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 26/06/2024.
//

import SwiftUI
import ParseSwift

struct AddEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var eventController: EventController
    @State private var eventName: String = ""
    @StateObject private var parametersController = ParametersListController(numberOfTeams: 2, teamNames: ["Équipe 1", "Équipe 2"])
    @StateObject private var optionsController = OptionsController()
    @State private var isLoading = false
    @State private var errorMessage: String?

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
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding(.leading, 20)
                        }
                    }
                    .padding(.bottom, 20)
                }

                TextButton(
                    text: "Ajouter l'évènement",
                    isLoading: isLoading,
                    onClick: {
                        addEvent()
                    },
                    buttonColor: .antiqueWhite,
                    textColor: .oxfordBlue
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        CustomHeader(title: "Ajouter un évènement")
                    }
                }
            }
            .background(Color.skyBlue)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func addEvent() {
        isLoading = true
        
        let userPointer = Pointer<User>(objectId: User.current?.objectId ?? "")
        let newEvent = Event(title: eventName, user: userPointer, equitableDistribution: parametersController.equitableDistribution)
        
        EventService.shared.saveEvent(newEvent) { result in
            switch result {
            case .success(let savedEvent):
                self.saveTeams(for: savedEvent)
            case .failure(let error):
                self.isLoading = false
                self.errorMessage = "Failed to save event: \(error.localizedDescription)"
            }
        }
    }

    func saveTeams(for event: Event) {
        var teams: [Team] = []
        for teamName in parametersController.teamNames {
            let team = Team(name: teamName, event: Pointer(objectId: event.objectId ?? ""))
            teams.append(team)
        }

        let dispatchGroup = DispatchGroup()

        for team in teams {
            dispatchGroup.enter()
            EventService.shared.saveTeam(team) { result in
                switch result {
                case .success(let savedTeam):
                    print("Saved team: \(savedTeam.name)")
                case .failure(let error):
                    print("Failed to save team: \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.saveMembers(for: event)
        }
    }

    func saveMembers(for event: Event) {
        let dispatchGroup = DispatchGroup()
        let members = optionsController.options.map { Member(name: $0, event: Pointer(objectId: event.objectId ?? "")) }

        for member in members {
            dispatchGroup.enter()
            EventService.shared.saveMember(member) { result in
                switch result {
                case .success(let savedMember):
                    print("Saved member: \(savedMember.name)")
                case .failure(let error):
                    print("Failed to save member: \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.isLoading = false
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AddEventView_Previews: PreviewProvider {
    @StateObject static var controller = EventController()

    static var previews: some View {
        AddEventView(eventController: controller)
            .previewDevice(PreviewDevices.iPhone14Pro.previewDevice)
            .previewDisplayName(PreviewDevices.iPhone14Pro.displayName)
        AddEventView(eventController: controller)
            .previewDevice(PreviewDevices.iPhoneSE.previewDevice)
            .previewDisplayName(PreviewDevices.iPhoneSE.displayName)
    }
}
