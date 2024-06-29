//
//  TeamsDrawService.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 28/06/2024.
//

import Foundation
import ParseSwift

/// Service class responsible for handling operations related to TeamsDraw and TeamResult.
class TeamsDrawService {
    
    /// Saves a TeamsDraw object to the Parse server.
    /// - Parameters:
    ///   - teamsDraw: The TeamsDraw object to be saved.
    ///   - completion: A closure to handle the result of the save operation, returning a `Result` with either a `TeamsDraw` or an `AppError`.
    static func saveTeamsDraw(_ teamsDraw: TeamsDraw, completion: @escaping (Result<TeamsDraw, AppError>) -> Void) {
        ApiService.current.saveTeamsDraw(teamsDraw, completion: completion)
    }
    
    /// Saves a TeamResult object to the Parse server.
    /// - Parameters:
    ///   - teamResult: The TeamResult object to be saved.
    ///   - completion: A closure to handle the result of the save operation, returning a `Result` with either a `TeamResult` or an `AppError`.
    static func saveTeamResult(_ teamResult: TeamResult, completion: @escaping (Result<TeamResult, AppError>) -> Void) {
        ApiService.current.saveTeamResult(teamResult, completion: completion)
    }
    
    /// Fetches TeamsDraw objects associated with a specific event from the Parse server.
    /// - Parameters:
    ///   - event: The Event object for which the TeamsDraw objects are to be fetched.
    ///   - completion: A closure to handle the result of the fetch operation, returning a `Result` with either a list of `TeamsDraw` objects or an `AppError`.
    static func fetchTeamsDraw(for event: Event, completion: @escaping (Result<[TeamsDraw], AppError>) -> Void) {
        ApiService.current.fetchTeamsDraw(for: event, completion: completion)
    }
    
    /// Fetches TeamResult objects associated with a specific TeamsDraw from the Parse server.
    /// - Parameters:
    ///   - teamsDraw: The TeamsDraw object for which the TeamResult objects are to be fetched.
    ///   - completion: A closure to handle the result of the fetch operation, returning a `Result` with either a list of `TeamResult` objects or an `AppError`.
    static func fetchTeamResults(for teamsDraw: TeamsDraw, completion: @escaping (Result<[TeamResult], AppError>) -> Void) {
        ApiService.current.fetchTeamResults(for: teamsDraw, completion: completion)
    }
}
