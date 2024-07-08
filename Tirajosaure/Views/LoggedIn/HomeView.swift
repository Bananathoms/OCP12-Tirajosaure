//
//  HomeView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var userController = UserController()
    @ObservedObject var languageController = LanguageController.shared
    @State private var selectedIndex = 0

    @State private var tabItems: [TabItem] = [
        TabItem(title: LocalizedString.drawTab.localized, iconName: IconNames.pencilCircle.rawValue),
        TabItem(title: LocalizedString.teamsTab.localized, iconName: IconNames.person3.rawValue),
        TabItem(title: LocalizedString.settingsTab.localized, iconName: IconNames.gearshape.rawValue)
    ]

    var body: some View {
        VStack {
            ZStack {
                switch selectedIndex {
                case 0:
                    QuestionView()
                case 1:
                    EventView()
                case 2:
                    SettingsView()
                default:
                    QuestionView()
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
        .onChange(of: languageController.currentLanguage) { _ in
            updateTabItems()
        }
    }
    
    private func updateTabItems() {
        tabItems = [
            TabItem(title: LocalizedString.drawTab.localized, iconName: IconNames.pencilCircle.rawValue),
            TabItem(title: LocalizedString.teamsTab.localized, iconName: IconNames.person3.rawValue),
            TabItem(title: LocalizedString.settingsTab.localized, iconName: IconNames.gearshape.rawValue)
        ]
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
