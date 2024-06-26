//
//  AddEventView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 26/06/2024.
//

import SwiftUI
import ParseSwift

struct AddEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var eventController: EventController
    @StateObject private var parametersController = ParametersListController(numberOfTeams: 2, teamNames: ["Équipe 1", "Équipe 2"])
    @StateObject private var optionsController = OptionsController()
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Nom de l'évènement")
                            .font(.headline)
                            .padding(.leading, 20)

                        ReusableTextField(
                            hint: $eventController.newEventTitle,
                            icon: IconNames.pencil.rawValue,
                            title: nil,
                            fieldName: "Nom de l'évènement"
                        )

                        Text("Paramètre de l'évènement")
                            .font(.headline)
                            .padding(.leading, 20)
                        ParametersList(controller: parametersController)
                            .frame(height: CGFloat(140.0 + Double(parametersController.numberOfTeams) * 44.0))

                        VStack(alignment: .leading) {
                            Text("Liste des membres")
                                .font(.headline)
                                .padding(.leading, 20)

                            OptionsListView(controller: optionsController)
                                .frame(height: CGFloat(optionsController.options.count) * 44.0 + 50.0)
                        }

                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding(.leading, 20)
                        }
                    }
                    .padding(.bottom, 20)
                }

                TextButton(
                    text: "Ajouter l'événement",
                    isLoading: isLoading,
                    onClick: {
                        isLoading = true
                        if eventController.addEvent(parametersController: parametersController, optionsController: optionsController) {
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
                        CustomHeader(title: "Ajouter un évènement")
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
