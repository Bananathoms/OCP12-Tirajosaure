//
//  EventView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 15/06/2024.
//

import SwiftUI
import ParseSwift

struct EventView: View {
    @StateObject private var eventController = EventController()
    @State private var isEditing = false
    @State private var navigateToAdd = false

    var body: some View {
        NavigationStack {
            VStack {
                eventController.isLoading ? AnyView(LoadingStateView()) : AnyView(eventListStateView)
            }
            .frame(maxWidth: .infinity)
            .background(Color.skyBlue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomHeader(title: LocalizedString.events.localized, showBackButton: false, fontSize: 36)
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
        EmptyStateView(
            title: LocalizedString.noEventsAvailable.localized,
            message: LocalizedString.pressButtonToCreateEvent.localized
        )
    }
    
    private var eventListStateView: some View {
        ReusableListStateView(
            data: eventController.events,
            emptyView: emptyStateView,
            contentView: eventListView,
            buttonText: LocalizedString.addNewEvent.localized,
            buttonImage: IconNames.plusCircleFill.systemImage,
            buttonColor: .antiqueWhite,
            textColor: .oxfordBlue,
            destinationView: AddEventView(eventController: eventController),
            navigateToAdd: $navigateToAdd,
            buttonAction: {
                MixpanelEvent.deleteEventButtonClicked.trackEvent()
            }
        )
    }

    private var eventListView: some View {
        ReusableListView(
            data: eventController.events,
            content: { event in
                EventItem(event: event, destination: {
                    EventDetailView(
                        event: event,
                        eventController: eventController,
                        teamDistributionController: TeamDistributionController(),
                        parametersController: ParametersListController(numberOfTeams: event.teams.count, teamNames: event.teams),
                        optionsController: {
                            let controller = OptionsController()
                            controller.options = event.members
                            return controller
                        }()
                    )
                })
            },
            onDelete: eventController.removeEvent,
            onMove: eventController.moveEvent,
            isEditing: isEditing
        )
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView()
            .previewDevice(PreviewDevices.iPhone14Pro.previewDevice)
            .previewDisplayName(PreviewDevices.iPhone14Pro.displayName)
        EventView()
            .previewDevice(PreviewDevices.iPhoneSE.previewDevice)
            .previewDisplayName(PreviewDevices.iPhoneSE.displayName)
    }
}
