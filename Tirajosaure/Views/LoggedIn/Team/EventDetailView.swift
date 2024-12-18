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
                        ForEach(teamDistributionController.teams) { teamResult in
                            TeamCard(name: teamResult.name, members: teamResult.members)
                        }
                    }
                    .padding()
                }
                .padding(.bottom, 20)

                if let currentMember = teamDistributionController.currentMember {
                    MemberCard(member: currentMember)
                        .transition(.slide)
                        .animation(.easeInOut, value: teamDistributionController.currentMember)
                }

                HStack {
                    TextButton(
                        text: LocalizedString.launchDraw.localized,
                        isLoading: teamDistributionController.isLoading,
                        onClick: {
                            MixpanelEvent.launchTeamDrawButtonClicked.trackEvent()
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
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        CustomHeader(title: event.title)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack{
                        NavigationLink(destination: EventHistoricView(event: event)) {
                            Image(systemName: IconNames.clockFill.rawValue)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.oxfordBlue)
                                .padding(.leading, 5)
                                .padding(.top)
                        }
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
            }
            .navigationBarBackButtonHidden(true)
            .background(Color.skyBlue)
            .onAppear {
                loadEventDetails()
            }
        }
    }

    private func loadEventDetails() {
        parametersController.numberOfTeams = event.teams.count
        parametersController.teamNames = event.teams
        optionsController.options = event.members
        teamDistributionController.initializeTeams(for: event)
    }
    
    private func startDistribution() {
        teamDistributionController.clearTeams()
        teamDistributionController.updateMembersToDistribute(for: event)
        teamDistributionController.teamsDraw = TeamsDraw(date: Date(), event: Pointer<Event>(objectId: event.objectId ?? DefaultValues.emptyString))
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
