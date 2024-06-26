//
//  EventItem.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import SwiftUI
import ParseSwift

struct EventItem<Destination: View>: View {
    var event: Event
    var members: [Member]
    var destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading) {
                Text(event.title)
                    .font(.headline)
                    .foregroundColor(.oxfordBlue)
                Text("\(members.count) membres")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            .padding()
            .background(Color.antiqueWhite)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}


struct EventItem_Previews: PreviewProvider {
    static var previews: some View {
        let event = Event(
            title: "Tournoi de foot",
            user: Pointer<User>(objectId: "sampleUserId"),
            equitableDistribution: true
        )
        
        let members = [
            Member(name: "Alice", event: Pointer<Event>(objectId: "sampleEventId")),
            Member(name: "Bob", event: Pointer<Event>(objectId: "sampleEventId"))
        ]
        
        return EventItem(
            event: event,
            members: members,
            destination: Text("Event Details")
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
