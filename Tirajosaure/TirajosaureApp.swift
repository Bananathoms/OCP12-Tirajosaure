//
//  TirajosaureApp.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 02/06/2024.
//

import SwiftUI
import ParseSwift
import Mixpanel

@main
struct TirajosaureApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ParseSwift.initialize(applicationId: ParseConfig.applicationID, clientKey: ParseConfig.clientKey, serverURL: URL(string: ParseConfig.serverURL)!)
        Mixpanel.initialize(token: MixpanelConfig.projectToken, trackAutomaticEvents: false)
      return true
    }
}
