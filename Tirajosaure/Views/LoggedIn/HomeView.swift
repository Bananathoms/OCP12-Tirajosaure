//
//  HomeView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var userController = UserController()

    var body: some View {
        VStack {
            TabView {
                DrawView()
                    .tabItem {
                        Image(systemName: "pencil.circle")
                        Text("Draw")
                    }

                TeamView()
                    .tabItem {
                        Image(systemName: "person.3")
                        Text("Teams")
                    }

                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
            }
        }
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

