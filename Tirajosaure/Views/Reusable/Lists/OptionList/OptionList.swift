//
//  OptionList.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 16/06/2024.
//

import SwiftUI

struct OptionsListView: View {
    let title: String
    let addElement: String
    let element: String
    @ObservedObject var controller: OptionsController
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section(
                    header: Text("\(title)")
                        .font(.customFont(.nunitoRegular, size: 16))
                        .foregroundColor(.oxfordBlue)
                        .frame(alignment: .topLeading)
                )
                {
                    HStack(spacing: 0) {
                        Text(DefaultValues.emptyString) /// Able to have separator under button
                        Button(action: {
                            controller.addOption()
                        }) {
                            IconNames.plusCircleFill.systemImage
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.green)
                        }
                        Text("\(addElement)")
                            .padding(.leading, 20)
                        Spacer()
                    }
                    .listRowBackground(Color.antiqueWhite)
                    
                    ForEach(Array(controller.options.enumerated()), id: \.offset) { index, option in
                        HStack {
                            TextField("\(element)", text: Binding(
                                get: { controller.options[safe: index] ?? DefaultValues.emptyString },
                                set: { newValue in
                                    if index < controller.options.count {
                                        controller.options[index] = newValue
                                    }
                                }
                            ))
                            .background(Color.antiqueWhite)
                            .cornerRadius(10)
                        }
                        .listRowBackground(Color.antiqueWhite)
                    }
                    .onDelete(perform: controller.removeOption)
                    .onMove(perform: controller.moveOption)
                }
            }
            .scrollDisabled(true)
            .headerProminence(.increased)
            .scrollContentBackground(.hidden)
            .listStyle(InsetGroupedListStyle())
            .environment(\.editMode, .constant(.active))
            .frame(height: controller.calculateListHeight())
        }
        .background(Color.skyBlue)
    }
}

struct OptionsListView_Previews: PreviewProvider {
    @StateObject static var controller = OptionsController()
    
    static var previews: some View {
        OptionsListView(title: "test", addElement: "add an element", element: "element", controller: controller)
    }
}
