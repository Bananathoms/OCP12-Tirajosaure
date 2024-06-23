//
//  ParametersList.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import SwiftUI

struct ParametersList: View {
    @ObservedObject var controller: ParametersListController

    var body: some View {
        VStack(alignment: .leading) {
            List {
                Toggle("Répartition équitable", isOn: $controller.equitableDistribution)
                    .padding(.vertical, 5)
                    .listRowBackground(Color.antiqueWhite)
                
                Stepper(value: $controller.numberOfTeams, in: 2...10) {
                    Text("Nombre d'équipes: \(controller.numberOfTeams)")
                }
                .padding(.vertical, 5)
                .listRowBackground(Color.antiqueWhite)

                ForEach(0..<controller.numberOfTeams, id: \.self) { index in
                    HStack {
                        TextField("Nom de l'équipe \(index + 1)", text: Binding(
                            get: {
                                if index < controller.teamNames.count {
                                    return controller.teamNames[index]
                                } else {
                                    return ""
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
            .contentMargins(.top, 0)
            .scrollContentBackground(.hidden)
            .listStyle(InsetGroupedListStyle())
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
            controller: ParametersListController(numberOfTeams: 2, teamNames: ["Équipe 1", "Équipe 2"])
        )
    }
}
