//
//  HomeView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var userController = UserController()
    @State private var selectedIndex = 0

    let tabItems = [
        TabItem(title: "Draw", iconName: "pencil.circle"),
        TabItem(title: "Teams", iconName: "person.3"),
        TabItem(title: "Settings", iconName: "gearshape")
    ]

    var body: some View {
        VStack {
            ZStack {
                switch selectedIndex {
                case 0:
                    DrawView()
                case 1:
                    TeamView()
                case 2:
                    SettingsView()
                default:
                    DrawView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            CustomTabBar(
                selectedIndex: $selectedIndex,
                tabItems: tabItems,
                backgroundColor: .antiqueWhite,
                selectedColor: .oxfordBlue,
                unselectedColor: .oxfordBlue.opacity(0.4),
                cornerRadius: 20
            )
            .frame(maxWidth: .infinity)
            .frame(height: 80)
        }
        .background(Color.skyBlue)
        .edgesIgnoringSafeArea([.bottom])
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice(PreviewDevices.iPhone14Pro.previewDevice)
            .previewDisplayName(PreviewDevices.iPhone14Pro.displayName)
        HomeView()
            .previewDevice(PreviewDevices.iPhoneSE.previewDevice)
            .previewDisplayName(PreviewDevices.iPhoneSE.displayName)
    }
}

