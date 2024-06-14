//
//  LocalizedString.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 14/06/2024.
//

import Foundation

enum LocalizedString: String {
    // General
    case email = "email"
    case password = "password"
    case firstName = "first_name"
    case lastName = "last_name"
    case enterYourPassword = "enter_your_password"
    case confirmYourPassword = "confirm_your_password"
    case continueButton = "continue_button"
    case logoutButton = "logout_button"
    case resetPasswordTitle = "reset_password_title"
    case resetPasswordButton = "reset_password_button"
    case passwordResetEmailSent = "password_reset_email_sent"

    // General Errors
    case networkErrorMessage = "network_error_message"
    case unknownErrorMessage = "unknown_error_message"

    // Validation Errors
    case validationErrorMessage = "validation_error_message"
    case parseErrorMessage = "parse_error_message"
    case passwordsDoNotMatch = "passwords_do_not_match"
    case invalidEmail = "invalid_email"
    case emptyPassword = "empty_password"
    case firstNameMissing = "first_name_missing"
    case lastNameMissing = "last_name_missing"
    case passwordLengthError = "password_length_error"
    case passwordUppercaseError = "password_uppercase_error"

    // Authentication Errors
    case authenticationErrorMessage = "authentication_error_message"

    // Success Messages
    case successfulSignIn = "successful_sign_in"
    case successfulSignUp = "successful_sign_up"

    // Sign-In Screen
    case signinTitle = "signin_title"
    case noAccountPrompt = "no_account_prompt"
    case signupHere = "signup_here"
    case forgotPassword = "forgot_password"
    case signinButton = "signin_button"

    // Sign-Up Screen
    case signupTitle = "signup_title"
}
