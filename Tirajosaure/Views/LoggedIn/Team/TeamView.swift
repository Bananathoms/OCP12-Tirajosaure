//
//  TeamView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 15/06/2024.
//

import SwiftUI

struct TeamView: View {
    @StateObject private var eventController = EventController()
    @State private var isEditing = false

    var body: some View {
        NavigationStack {
            VStack {
                if eventController.events.isEmpty {
                    emptyStateView
                } else {
                    eventListView
                }

                NavigationLink(destination: AddEventView(eventController: eventController)) {
                    AddButton(
                        text: "Créer un nouvel événement",
                        image: IconNames.plusCircleFill.systemImage,
                        buttonColor: .antiqueWhite,
                        textColor: .oxfordBlue,
                        width: 300,
                        height: 50
                    )
                    .padding()
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.skyBlue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomHeader(title: "Événements", showBackButton: false, fontSize: 36)
                        .padding(.vertical)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            isEditing.toggle()
                        }
                    }) {
                        Image(systemName: isEditing ? IconNames.checkmarkCircleFill.rawValue : IconNames.pencilCircleFill.rawValue)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.top)
                            .foregroundColor(.oxfordBlue)
                    }
                }
            }
            .padding(.top)
            .background(Color.skyBlue)
        }
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .background(Color.thulianPink)
    }

    private var emptyStateView: some View {
        VStack {
            Text("Aucun événement disponible")
                .font(.customFont(.nunitoBold, size: 20))
                .foregroundColor(.gray)
                .padding(.top, 40)
            Text("Appuyez sur le bouton ci-dessous pour créer un nouvel événement.")
                .font(.customFont(.nunitoRegular, size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing], 20)
                .padding(.top, 10)
            Spacer()
        }
    }

    private var eventListView: some View {
        List {
            ForEach(eventController.events) { event in
                let members = eventController.getMembers(for: event)
                EventItem(
                    event: event,
                    members: members,
                    destination: EventDetailView(
                        event: event,
                        teams: eventController.getTeams(for: event),
                        equitableDistribution: event.equitableDistribution,
                        eventController: eventController,
                        teamDistributionController: TeamDistributionController(
                            teams: eventController.getTeams(for: event),
                            membersToDistribute: eventController.getMembers(for: event)
                        ),
                        parametersController: ParametersListController(
                            numberOfTeams: eventController.getTeams(for: event).count,
                            teamNames: eventController.getTeams(for: event).map { $0.name }
                        ),
                        optionsController: OptionsController()
                    )
                )
                .padding(.trailing)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.antiqueWhite)
            }
            .onDelete(perform: eventController.removeEvent)
            .onMove(perform: eventController.moveEvent)
        }
        .contentMargins(.top, 24)
        .environment(\.editMode, .constant(isEditing ? .active : .inactive))
        .scrollContentBackground(.hidden)
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView()
            .previewDevice(PreviewDevices.iPhone14Pro.previewDevice)
            .previewDisplayName(PreviewDevices.iPhone14Pro.displayName)
        TeamView()
            .previewDevice(PreviewDevices.iPhoneSE.previewDevice)
            .previewDisplayName(PreviewDevices.iPhoneSE.displayName)
    }
}
