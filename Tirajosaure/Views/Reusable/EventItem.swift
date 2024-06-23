//
//  EventItem.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import SwiftUI

struct EventItem<Destination: View>: View {
    var event: Event
    var destination: () -> Destination

    var body: some View {
        NavigationLink(destination: destination()) {
            HStack {
                VStack(alignment: .leading) {
                    Text(event.title)
                        .font(.headline)
                        .foregroundColor(.oxfordBlue)
                    Text("\(event.members.count) membres")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                .padding(20)
                Spacer()
            }
            .background(Color.antiqueWhite)
            .cornerRadius(10)
        }
        .frame(height: 60)
    }
}

struct EventItem_Previews: PreviewProvider {
    static var previews: some View {
        let members = [
            Member(name: "Alice"),
            Member(name: "Bob"),
            Member(name: "Charlie"),
            Member(name: "David")
        ]
        
        EventItem(
            event: Event(
                title: "Tournoi de foot",
                members: members
            ),
            destination: { Text("Detail View") }
        )
    }
}
