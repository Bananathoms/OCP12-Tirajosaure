//
//  ErrorMessage.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 14/06/2024.
//

import Foundation

enum ErrorMessage: String {
    case failedToRequestPasswordReset = "failed_to_request_password_reset"
    case failedToDecodeJSONResponse = "failed_to_decode_json_response"
    case unknownError = "unknown_error"
    case defaultMessage = "default_message"
    case emptyQuestionTitle = "empty_question_title"
    case insufficientOptions = "insufficient_options"
    case failedToSaveQuestion = "failed_to_save_question"
    case failedToUpdateQuestion = "failed_to_update_question"
    case failedToDeleteQuestion = "failed_to_delete_question"
    case failedToLoadQuestions = "failed_to_load_questions"
    case failedToSaveUserData = "failed_to_save_user_data"
    case failedToLoadUserData = "failed_to_load_user_data"
    case failedToSaveDrawResult = "failed_to_save_draw_result"
    case failedToLoadDrawResults = "failed_to_load_draw_results"
    case networkErrorMessage = "network_error_message"
    case noResponseData = "no_response_data"
    case invalidQuestionID = "invalid_question_id"
    case failedToSaveTeam = "failed_to_save_team"
    case failedToUpdateTeam = "failed_to_update_team"
    case failedToDeleteTeam = "failed_to_delete_team"
    case failedToLoadTeams = "failed_to_load_teams"
    case failedToSaveMember = "failed_to_save_member"
    case failedToUpdateMember = "failed_to_update_member"
    case failedToDeleteMember = "failed_to_delete_member"
    case failedToLoadMembers = "failed_to_load_members"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

