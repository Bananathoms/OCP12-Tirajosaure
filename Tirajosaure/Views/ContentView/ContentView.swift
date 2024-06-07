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
            HomeView(userController: userController)
        case .unLogged:
            SignInView(controller: SignInController())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone SE (3rd generation)")
            .previewDisplayName("iPhone SE")
        ContentView()
            .previewDevice("iPhone 14 Pro")
            .previewDisplayName("iPhone 14 Pro")
    }
}
