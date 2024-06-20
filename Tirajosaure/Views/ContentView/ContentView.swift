//
//  ContentView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 02/06/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var userController = UserController()

    var body: some View {
        switch userController.connexionState {
        case .splash:
            SplashView(userController: userController)
        case .logged:
            HomeView()
        case .unLogged:
            SignInView(controller: SignInController())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevices.iPhone14Pro.previewDevice)
            .previewDisplayName(PreviewDevices.iPhone14Pro.displayName)
        ContentView()
            .previewDevice(PreviewDevices.iPhoneSE.previewDevice)
            .previewDisplayName(PreviewDevices.iPhoneSE.displayName)
    }
}