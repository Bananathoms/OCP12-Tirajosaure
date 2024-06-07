//
//  TirajosaureApp.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 02/06/2024.
//

import SwiftUI
import ParseSwift
import Mixpanel
import IQKeyboardManagerSwift

@main
/// The main structure of the Tirajosaure application.
/// Uses the `App` protocol from SwiftUI to manage the app's lifecycle.
struct TirajosaureApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    /// The main scene of the application.
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/// The application delegate, responsible for initializing services.
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    /// Called when the application has finished launching.
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - launchOptions: A dictionary indicating the reason the app was launched (if any).
    /// - Returns: A boolean indicating whether the app successfully finished launching.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.initializeServices()
        return true
    }
    
    /// Initializes the various services used by the application.
    private func initializeServices() {
        ParseSwift.initialize(applicationId: ParseConfig.applicationID,
                              clientKey: ParseConfig.clientKey,
                              serverURL: URL(string: ParseConfig.serverURL)!)
        NotificationCenter.default.post(name: .parseInitialized, object: nil)
        Mixpanel.initialize(token: MixpanelConfig.projectToken, trackAutomaticEvents: false)
        IQKeyboardManager.shared.enable = true
        
    }
}
