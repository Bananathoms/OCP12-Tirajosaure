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
    @State var teams: [Team]
    @State var equitableDistribution: Bool
    @ObservedObject var eventController: EventController
    @StateObject var teamDistributionController: TeamDistributionController
    @StateObject var parametersController: ParametersListController
    @StateObject var optionsController: OptionsController
    @Environment(\.presentationMode) var presentationMode
    @State private var teamMembers: [String: [Member]] = [:] 

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
                                if let members = teamMembers[team.objectId ?? ""] {
                                    ForEach(members) { member in
                                        OptionCard(option: member.name, isSelected: false)
                                    }
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
        event.equitableDistribution = parametersController.equitableDistribution
        
        for team in teams {
            if let teamMembers = teamMembers[team.objectId ?? ""] {
                for member in teamMembers {
                    var updatedMember = member
                    updatedMember.team = Pointer(objectId: team.objectId ?? "")
                    EventService.shared.saveMember(updatedMember) { result in
                        switch result {
                        case .success:
                            print("Member updated successfully")
                        case .failure(let error):
                            print("Failed to update member: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
        
        eventController.updateEvent(event, teams: teams, equitableDistribution: event.equitableDistribution)
    }

    
    private func loadEventDetails() {
        EventService.shared.fetchTeams(for: Pointer<Event>(objectId: event.objectId ?? "")) { result in
            switch result {
            case .success(let teams):
                self.teams = teams
                for team in teams {
                    EventService.shared.fetchMembers(for: Pointer<Event>(objectId: event.objectId ?? "")) { memberResult in
                        switch memberResult {
                        case .success(let members):
                            let filteredMembers = members.filter { $0.team?.objectId == team.objectId }
                            DispatchQueue.main.async {
                                self.teamMembers[team.objectId ?? ""] = filteredMembers
                            }
                        case .failure(let error):
                            print("Failed to fetch members: \(error.localizedDescription)")
                        }
                    }
                }
            case .failure(let error):
                print("Failed to fetch teams: \(error.localizedDescription)")
            }
        }
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
        user: Pointer<User>(objectId: "sampleUserId"), equitableDistribution: true
    )

    static var previews: some View {
        EventDetailView(
            event: event,
            teams: [
                Team(name: "Équipe 1", event: Pointer(objectId: "sampleEventId")),
                Team(name: "Équipe 2", event: Pointer(objectId: "sampleEventId"))
            ],
            equitableDistribution: event.equitableDistribution,
            eventController: EventController(),
            teamDistributionController: TeamDistributionController(
                teams: [],
                membersToDistribute: []
            ),
            parametersController: ParametersListController(
                numberOfTeams: 2,
                teamNames: ["Équipe 1", "Équipe 2"]
            ),
            optionsController: OptionsController()
        )
        .previewDevice(PreviewDevices.iPhone14Pro.previewDevice)
        .previewDisplayName(PreviewDevices.iPhone14Pro.displayName)
        
        EventDetailView(
            event: event,
            teams: [
                Team(name: "Équipe 1", event: Pointer(objectId: "sampleEventId")),
                Team(name: "Équipe 2", event: Pointer(objectId: "sampleEventId"))
            ],
            equitableDistribution: event.equitableDistribution,
            eventController: EventController(),
            teamDistributionController: TeamDistributionController(
                teams: [],
                membersToDistribute: []
            ),
            parametersController: ParametersListController(
                numberOfTeams: 2,
                teamNames: ["Équipe 1", "Équipe 2"]
            ),
            optionsController: OptionsController()
        )
        .previewDevice(PreviewDevices.iPhoneSE.previewDevice)
        .previewDisplayName(PreviewDevices.iPhoneSE.displayName)
    }
}
