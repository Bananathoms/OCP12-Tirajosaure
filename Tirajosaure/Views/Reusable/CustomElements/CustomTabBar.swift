//
//  CustomTabBar.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 16/06/2024.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedIndex: Int
    let tabItems: [TabItem]
    var backgroundColor: Color
    var selectedColor: Color
    var unselectedColor: Color
    var cornerRadius: CGFloat

    var body: some View {
        VStack {
            Spacer()
            HStack {
                ForEach(0..<tabItems.count, id: \.self) { index in
                    Spacer()
                    Button(action: {
                        selectedIndex = index
                    }) {
                        VStack {
                            Image(systemName: tabItems[index].iconName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 24)
                            Text(tabItems[index].title)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundColor(selectedIndex == index ? selectedColor : unselectedColor)
                    }
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(backgroundColor)
            .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -5)
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(
            selectedIndex: .constant(0),
            tabItems: [
                TabItem(title: "Draw", iconName: "pencil.circle"),
                TabItem(title: "Teams", iconName: "person.3"),
                TabItem(title: "Settings", iconName: "gearshape")
            ],
            backgroundColor: .celestialBlue,
            selectedColor: .white,
            unselectedColor: .white.opacity(0.6),
            cornerRadius: 20
        )
    }
}
