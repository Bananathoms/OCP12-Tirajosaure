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
    case failedToFetchQuestions = "failed_to_fetch_equestions"
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
    case networkDataMissing = "network_data_missing"
    case networkErrorDescription = "network_error_description"
    case networkErrorWithResponse = "network_error_with_response"
    case failedToFetchEvents = "failed_to_fetch_events"
    case userIDNotFound = "user_id_not_found"
    case eventTitleEmpty = "event_title_empty"
    case notEnoughValidOptions = "not_enough_valid_options"
    case notEnoughValidEventOptions = "not_enough_valid_event_options"
    case failedToSaveEvent = "failed_to_save_event"
    case failedToUpdateEvent = "failed_to_update_event"
    case failedToDeleteEvent = "failed_to_delete_event"
    case failedToSaveTeamsDraw = "failed_to_save_teams_draw"
    case failedToFetchTeamsDraw = "failed_to_fetch_teams_draw"
    case failedToFetchTeamResults = "failed_to_fetch_team_results"
    case invalidTeamsDrawID = "invalid_teams_draw_id"
    case invalidTeamResultID = "invalid_team_result_id"
    case invalidEventID = "invalid_event_id"
    case invalidUserID = "invalid_user_id"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

