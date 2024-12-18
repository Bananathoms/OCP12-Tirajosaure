//
//  ParametersList.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import SwiftUI

struct ParametersList: View {
    let title: String
    @ObservedObject var controller: ParametersListController
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section(
                    header: Text("\(title)")
                        .font(.customFont(.nunitoRegular, size: 16))
                        .foregroundColor(.oxfordBlue)
                        .frame(alignment: .topLeading)
                ) {
                    Toggle(LocalizedString.equitableDistribution.rawValue.localized, isOn: $controller.equitableDistribution)
                        .padding(.vertical, 5)
                        .listRowBackground(Color.antiqueWhite)
                    
                    Stepper {
                        Text(String(format: LocalizedString.numberOfTeams.rawValue.localized, controller.numberOfTeams))
                    } onIncrement: {
                        controller.numberOfTeams += 1
                    } onDecrement: {
                        if controller.numberOfTeams > 2 {
                            controller.numberOfTeams -= 1
                        }
                    }
                    .listRowBackground(Color.antiqueWhite)
                    
                    ForEach(0..<controller.numberOfTeams, id: \.self) { index in
                        HStack {
                            TextField(String(format: LocalizedString.teamName.rawValue.localized, index + 1), text: Binding(
                                get: {
                                    if index < controller.teamNames.count {
                                        return controller.teamNames[index]
                                    } else {
                                        return DefaultValues.emptyString
                                    }
                                },
                                set: { newValue in
                                    if index < controller.teamNames.count {
                                        controller.updateTeamName(at: index, with: newValue)
                                    }
                                }
                            ))
                            .background(Color.antiqueWhite)
                            .cornerRadius(10)
                        }
                        .listRowBackground(Color.antiqueWhite)
                    }
                }
            }
            .scrollDisabled(true)
            .headerProminence(.increased)
            .scrollContentBackground(.hidden)
            .listStyle(InsetGroupedListStyle())
            .frame(height: controller.calculateListHeight())
        }
        .background(Color.skyBlue)
        .onAppear {
            controller.updateTeamNames()
        }
    }
}

struct ParametersList_Previews: PreviewProvider {
    static var previews: some View {
        ParametersList(
            title: "Test", controller: ParametersListController(numberOfTeams: 2, teamNames: ["Team 1", "Team 2"])
        )
    }
}
