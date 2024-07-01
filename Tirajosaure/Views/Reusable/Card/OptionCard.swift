//
//  OptionCard.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 19/06/2024.
//

import SwiftUI

struct OptionCard: View {
    let option: String
    let isSelected: Bool

    var body: some View {
        Text(option)
            .foregroundColor(isSelected ? .oxfordBlue : .antiqueWhite)
            .font(isSelected ? .title2 : .title3)
            .minimumScaleFactor(0.5)
            .lineLimit(1)
            .padding(5)
            .frame(width: isSelected ? 150 : 100, height: isSelected ? 100 : 75)
            .background(isSelected ? .antiqueWhite : .celestialBlue)
            .cornerRadius(isSelected ? 10 : 5)
            .shadow(radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: isSelected ? 10 : 5)
                    .stroke(Color.oxfordBlue, lineWidth: 2)
            )
    }
}

struct OptionCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OptionCard(option: "Option", isSelected: true)
            OptionCard(option: "Option", isSelected: false)
        }
    }
}
