//
//  QuestionService.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 18/06/2024.
//

import Foundation
import ParseSwift
import Alamofire

/// A service class responsible for handling operations related to `Question` objects,
class QuestionService {
    static let shared = QuestionService()

    private init() {}
    
    /// Fetches questions associated with a specific user from the Parse server.
    /// - Parameters:
    ///   - userId: The ID of the user whose questions are to be fetched.
    ///   - completion: A closure to handle the result of the fetch operation, returning a `Result` with either an array of `Question` objects or an `AppError`.
    func fetchQuestions(for userId: String, completion: @escaping (Result<[Question], AppError>) -> Void) {
        ApiService.current.fetchQuestions(for: userId, completion: completion)
    }

    /// Saves a `Question` object to the Parse server.
    /// - Parameters:
    ///   - question: The `Question` object to be saved.
    ///   - completion: A closure to handle the result of the save operation, returning a `Result` with either the saved `Question` object or an `AppError`.
    func saveQuestion(_ question: Question, completion: @escaping (Result<Question, AppError>) -> Void) {
        ApiService.current.saveQuestion(question, completion: completion)
    }

    /// Deletes a `Question` object from the Parse server.
    /// - Parameters:
    ///   - question: The `Question` object to be deleted.
    ///   - completion: A closure to handle the result of the delete operation, returning a `Result` with either `Void` or an `AppError`.
    func deleteQuestion(_ question: Question, completion: @escaping (Result<Void, AppError>) -> Void) {
        ApiService.current.deleteQuestion(question, completion: completion)
    }
}
