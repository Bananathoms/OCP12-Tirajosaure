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
    @State private var eventCount = 1

    var body: some View {
        VStack {
            Text("")
                .padding(.top, 24)
            NavigationStack {
                VStack {
                    if eventController.events.isEmpty {
                        emptyStateView
                    } else {
                        eventListView
                    }

                    Button(action: {
                        addNewEvent()
                    }) {
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
        }
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
                EventItem(
                    event: event,
                    destination: {
                        EventDetailView(event: event, eventController: eventController)
                    }
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

    private func addNewEvent() {
        let newEventTitle = "Événement \(eventCount)"
        let newEvent = Event(title: newEventTitle, members: [])
        eventController.addEvent(newEvent)
        eventCount += 1
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
