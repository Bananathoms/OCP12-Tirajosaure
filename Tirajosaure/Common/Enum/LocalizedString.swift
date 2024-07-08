//
//  LocalizedString.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 14/06/2024.
//

import Foundation

/// Enum representing localized strings used in the app.
enum LocalizedString: String {
    // General
    case email
    case password
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
    case failedToRequestPasswordReset = "failed_to_request_password_reset"

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
    case invalidQuestionID = "invalid_question_id"

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
    
    // HomeView
    case drawTab = "draw_tab"
    case teamsTab = "teams_tab"
    case settingsTab = "settings_tab"
    
    // Question
    case questionsTitle = "questions_title"
    case addNewQuestion = "add_new_question"
    case editQuestion = "edit_question"
    case questionTitlePlaceholder = "question_title_placeholder"
    case enterQuestionTitle = "enter_question_title"
    case answersListPlaceholder = "answers_list_placeholder"
    case addAnswer = "add_answer"
    case answer = "answer"
    case draw = "draw"
    
    // History and Statistics
    case historyTitle = "history_title"
    case statisticsTitle = "statistics_title"
    case totalDraw = "total_draw"
    case optionLabel = "option_label"
    case countLabel = "count_label"
    case drawsLabel = "draws_label"
    case noResultsYet = "no_results_yet"

    // Empty QuestionList
    case emptyQuestionsTitle = "empty_questions_title"
    case emptyQuestionsMessage = "empty_questions_message"
    
    // Team
    case defaultTeamName = "default_team_name"
    case launchDraw = "launch_draw"
    case history = "history"
    case loading = "loading"
    case noDrawFound = "no_draw_found"
    case noDrawFoundMessage = "no_draw_found_message"
    case drawOn = "draw_on"
    
    // Event
    case eventName = "event_name"
    case eventParameters = "event_parameters"
    case eventTitlePlaceholder = "event_title_placeholder"
    case membersListPlaceholder = "members_list_placeholder"
    case addEvent = "add_event"
    case editEvent = "edit_event"
    case addNewEvent = "add_new_event"
    case events = "events"
    case noEventsAvailable = "no_events_available"
    case pressButtonToCreateEvent = "press_button_to_create_event"
    case teamNumber = "team_number"
    case member = "member"
    case members = "members"
    case addMember = "add_member"
    
    // Parameters
    case selectLanguage = "select_language"
    case language = "language"
    case userInformations = "user_informations"
    
    // ParameterList
    case equitableDistribution = "equitable_distribution"
    case numberOfTeams = "number_of_teams"
    case teamName = "team_name"
}
