//
//  ReusablePicker.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 08/06/2024.
//

import SwiftUI



struct ReusablePicker: View {
    @Binding var selection: String
    let title: String
    let items: [String]
    let itemTitleProvider: (String) -> String
    let defaultTitle: String

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.nunitoRegular(16))
                    .foregroundColor(.oxfordBlue)
                    .padding(.leading, 30)
                    .frame(alignment: .topLeading)
                Spacer()
            }
            
            HStack {
                Picker(selection: $selection, label: Text("")) {
                    Text(defaultTitle).tag("")
                    ForEach(items, id: \.self) { item in
                        HStack {
                            Text(itemTitleProvider(item))
                            Spacer()
                        }
                        .tag(item)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color.antiqueWhite)
            .cornerRadius(15.0)
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity)
    }
}

struct ReusablePicker_Previews: PreviewProvider {
    @State static var selection = ""

    static var previews: some View {
        Group {
            ReusablePicker(selection: $selection, title: "Security Question", items: ["1", "2", "3"], itemTitleProvider: { id in
                return "Question \(id)"
            }, defaultTitle: "Click to choose a question")
            .previewDevice("iPhone SE (3rd generation)")
            .previewDisplayName("iPhone SE")
            
            ReusablePicker(selection: $selection, title: "Security Question", items: ["1", "2", "3"], itemTitleProvider: { id in
                return "Question \(id)"
            }, defaultTitle: "Click to choose a question")
            .previewDevice("iPhone 14 Pro")
            .previewDisplayName("iPhone 14 Pro")
        }
    }
}
