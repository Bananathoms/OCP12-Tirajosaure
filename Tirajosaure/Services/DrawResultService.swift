//
//  DrawResultService.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 20/06/2024.
//

import Foundation
import ParseSwift

/// A service responsible for managing draw results, including saving to and loading from Back4App.
class DrawResultService {
    private let apiService = ApiService.current
    
    /// Saves a draw result to Back4App.
    /// - Parameters:
    ///   - drawResult: The `DrawResult` to save.
    ///   - completion: A closure to handle the result of the save operation.
    func saveDrawResult(_ drawResult: DrawResult, completion: @escaping (Result<DrawResult, AppError>) -> Void) {
        apiService.saveDrawResult(drawResult) { result in
            completion(result)
        }
    }
    
    /// Loads draw results for a specific question from Back4App.
    /// - Parameters:
    ///   - question: The `Pointer<Question>` representing the current question.
    ///   - completion: A closure to handle the result of the load operation.
    func loadDrawResults(for question: Pointer<Question>, completion: @escaping (Result<[DrawResult], AppError>) -> Void) {
        apiService.loadDrawResults(for: question) { result in
            completion(result)
        }
    }
}

