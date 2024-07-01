//
//  AddEventView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 26/06/2024.
//

import SwiftUI

struct AddEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var eventController: EventController
    @StateObject private var optionsController = OptionsController()
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView{
                    VStack {
                        ReusableTextField(
                            hint: $eventController.newEventTitle,
                            icon: IconNames.pencil.rawValue,
                            title:  LocalizedString.eventTitlePlaceholder.localized,
                            fieldName: LocalizedString.eventTitlePlaceholder.localized
                        )
                        
                        ParametersList(title: LocalizedString.eventParameters.localized, controller: eventController.parametersController)
                        
                        OptionsListView(title: LocalizedString.membersListPlaceholder.localized, addElement: LocalizedString.addMember.localized, element: LocalizedString.member.localized, controller: optionsController)
                    }
                }.padding(.top)
 
                TextButton(
                    text: LocalizedString.addEvent.localized,
                    isLoading: isLoading,
                    onClick: {
                        eventController.optionsController = optionsController
                        isLoading = true
                        if eventController.addEvent() {
                            isLoading = false
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            isLoading = false
                        }
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
                        CustomHeader(title: LocalizedString.addEvent.localized)
                    }
                }
            }
            .background(Color.skyBlue)
        }
        .navigationBarBackButtonHidden(true)
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
