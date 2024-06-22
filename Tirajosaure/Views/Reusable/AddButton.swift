//
//  AddButton.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 16/06/2024.
//

import SwiftUI

struct AddButton: View {
    let text: String
    let image: Image?
    let buttonColor: Color
    let textColor: Color
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        HStack {
            if let image = image {
                image
                    .foregroundColor(textColor)
            }
            Text(text)
                .foregroundColor(textColor)
        }
        .frame(width: width, height: height)
        .background(buttonColor)
        .cornerRadius(40.0)
        .padding(20)
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton(
            text: "Ajouter une nouvelle question",
            image: Image(systemName: "plus.circle.fill"),
            buttonColor: .blue,
            textColor: .white,
            width: 300,
            height: 50
        )
    }
}

