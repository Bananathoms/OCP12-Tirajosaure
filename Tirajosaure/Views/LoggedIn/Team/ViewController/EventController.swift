//
//  EventController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import Foundation
import Combine

class EventController: ObservableObject {
    @Published var events: [Event] = []

    func addEvent(_ event: Event) {
        events.append(event)
    }

    func removeEvent(at offsets: IndexSet) {
        events.remove(atOffsets: offsets)
    }

    func moveEvent(from source: IndexSet, to destination: Int) {
        events.move(fromOffsets: source, toOffset: destination)
    }

    func updateEvent(_ event: Event, teams: [Team], equitableDistribution: Bool) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index].title = event.title
            events[index].members = event.members
            events[index].teams = teams
            events[index].equitableDistribution = equitableDistribution
        }
    }
}
