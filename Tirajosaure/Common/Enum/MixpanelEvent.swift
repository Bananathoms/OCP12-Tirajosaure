//
//  MixpanelEvent.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 14/06/2024.
//

import Foundation
import Mixpanel

enum MixpanelEvent: String {
    case appInstalled = "App Installed"
    case loginButtonClicked = "Login Button Clicked"
    case signUpButtonClicked = "Sign Up Button Clicked"
    case forgotPasswordButtonClicked = "Forgot Password Button Clicked"

    var eventName: String {
        return self.rawValue
    }

    func trackEvent() {
        Mixpanel.mainInstance().track(event: self.eventName)
    }
}
