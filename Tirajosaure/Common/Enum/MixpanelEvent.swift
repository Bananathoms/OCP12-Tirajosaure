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
    case launchDrawButtonClicked = "Launch Question Draw Button Clicked"
    case addQuestionButtonClicked = "Add Question Button Clicked"
    case editQuestionButtonClicked = "Edit Question Button Clicked"
    case deleteQuestionButtonClicked = "Delete Question Button Clicked"
    case addEventButtonClicked = "Add Event Button Clicked"
    case launchTeamDrawButtonClicked = "Launch Team Draw Button Clicked"
    case editEventButtonClicked = "Edit Event Button Clicked"
    case deleteEventButtonClicked = "Delete Event Button Clicked"

    var eventName: String {
        return self.rawValue
    }

    func trackEvent() {
        Mixpanel.mainInstance().track(event: self.eventName)
    }
}
