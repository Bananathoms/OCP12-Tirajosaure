//
//  OptionList.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 16/06/2024.
//

import SwiftUI

struct OptionsListView: View {
    @ObservedObject var controller: OptionsController
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Éléments")
                .font(.customFont(.nunitoRegular, size: 16))
                .foregroundColor(.oxfordBlue)
                .padding(.leading, 30)
            
            List {
                HStack(spacing: 0) {
                    Text("") /// Able to have separator under button
                    Button(action: {
                        controller.addOption()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.green)
                    }
                    Text("Ajouter un élément")
                        .padding(.leading, 20)
                    Spacer()
                }
                .listRowBackground(Color.antiqueWhite)
                
                ForEach(Array(controller.options.enumerated()), id: \.offset) { index, option in
                    HStack {
                        TextField("Élément", text: Binding(
                            get: { controller.options[index] },
                            set: { newValue in controller.options[index] = newValue }
                        ))
                        .background(Color.antiqueWhite)
                        .cornerRadius(10)
                    }
                    .listRowBackground(Color.antiqueWhite)
                }
                .onDelete(perform: controller.removeOption)
                .onMove(perform: controller.moveOption)
            }
            .contentMargins(.top, 0)
            .scrollContentBackground(.hidden)
            .listStyle(InsetGroupedListStyle())
            .environment(\.editMode, .constant(.active))
        }
        .background(Color.skyBlue)
    }
}

struct OptionsListView_Previews: PreviewProvider {
    @StateObject static var controller = OptionsController()

    static var previews: some View {
        OptionsListView(controller: controller)
    }
}


