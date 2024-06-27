//
//  EventItem.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import SwiftUI
import ParseSwift

struct EventItem<Destination: View>: View {
    let event: Event
    let destination: () -> Destination

    var body: some View {
        NavigationLink(destination: destination()) {
            VStack(alignment: .leading) {
                Text(event.title)
                    .font(.headline)
                    .foregroundColor(.oxfordBlue)
                Text("\(event.members.count) membres")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.antiqueWhite)
//            .cornerRadius(10)
//            .shadow(radius: 5)
        }
    }
}

struct EventItem_Previews: PreviewProvider {
    static var previews: some View {
        let sampleEvent = Event(
            title: "Tournoi de foot",
            user: Pointer<User>(objectId: "sampleUserId"),
            equitableDistribution: true,
            teams: ["Équipe 1", "Équipe 2"],
            members: ["Membre 1", "Membre 2"]
        )
        
        let optionsController = OptionsController()
        optionsController.options = ["Membre 1", "Membre 2"]
        
        return EventItem(event: sampleEvent) {
            EventDetailView(
                event: sampleEvent,
                eventController: EventController(),
                teamDistributionController: TeamDistributionController(),
                parametersController: ParametersListController(numberOfTeams: 2, teamNames: ["Équipe 1", "Équipe 2"]),
                optionsController: optionsController
            )
        }
        .previewDevice(PreviewDevices.iPhone14Pro.previewDevice)
        .previewDisplayName(PreviewDevices.iPhone14Pro.displayName)
    }
}
