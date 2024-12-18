//
//  DrawViewController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 20/06/2024.
//

import Foundation
import SwiftUI
import ParseSwift

/// A controller responsible for managing the state and operations related to the draw functionality in the Tirajosaure app.
class DrawViewController: ObservableObject {
    @Published var isAnimating: Bool = false
    @Published var selectedOptionIndex: Int = 0
    @Published var leftOptionIndex: Int = 0
    @Published var rightOptionIndex: Int = 0
    @Published var drawResults: [DrawResult] = []
    @Published var errorMessage: String? = nil
    
    private let drawResultService: DrawResultService

    init(drawResultService: DrawResultService = DrawResultService()) {
        self.drawResultService = drawResultService
    }

    /// Sets up the initial indices for the selected, left, and right options based on the provided options.
    /// - Parameter options: An array of option strings to choose from.
    func setupInitialIndices(options: [String]) {
        selectedOptionIndex = Int.random(in: 0..<options.count)
        if options.count > 1 {
            leftOptionIndex = getRandomIndex(options: options, excluding: [selectedOptionIndex])
            if options.count > 2 {
                rightOptionIndex = getRandomIndex(options: options, excluding: [selectedOptionIndex, leftOptionIndex])
            }
        }
    }
    
    /// Starts the drawing animation and selects an option randomly over a specified duration.
    /// - Parameter options: An array of option strings to choose from.
    func startDrawing(options: [String], question: Pointer<Question>) {
        isAnimating = true
        let totalDuration: TimeInterval = 3.0
        let interval: TimeInterval = 0.1
        let iterations = Int(totalDuration / interval)

        for i in 0..<iterations {
            DispatchQueue.main.asyncAfter(deadline: .now() + interval * Double(i)) {
                self.selectedOptionIndex = Int.random(in: 0..<options.count)
                if options.count > 1 {
                    self.leftOptionIndex = self.getRandomIndex(options: options, excluding: [self.selectedOptionIndex])
                    if options.count > 2 {
                        self.rightOptionIndex = self.getRandomIndex(options: options, excluding: [self.selectedOptionIndex, self.leftOptionIndex])
                    }
                }
                if i == iterations - 1 {
                    self.isAnimating = false
                    self.recordDrawResult(option: options[self.selectedOptionIndex], question: question)
                }
            }
        }
    }
    
    /// Records the result of a draw by creating a new `DrawResult` and inserting it at the beginning of the `drawResults` array.
    /// - Parameter option: The selected option string.
    func recordDrawResult(option: String, question: Pointer<Question>) {
        let result = DrawResult(option: option, date: Date(), question: question)
        drawResults.insert(result, at: 0)
        saveDrawResult(result)
    }
    
    /// Returns a random index from the options array, excluding specified indices.
    /// - Parameters:
    ///   - options: An array of option strings to choose from.
    ///   - excludedIndices: An array of indices to exclude from the random selection.
    /// - Returns: A random index not present in `excludedIndices`.
    func getRandomIndex(options: [String], excluding excludedIndices: [Int]) -> Int {
        var newIndex: Int
        repeat {
            newIndex = Int.random(in: 0..<options.count)
        } while excludedIndices.contains(newIndex)
        return newIndex
    }
    
    /// Saves a draw result to Back4App.
    /// - Parameter result: The `DrawResult` to save.
    func saveDrawResult(_ result: DrawResult) {
        drawResultService.saveDrawResult(result) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                self.errorMessage = "\(ErrorMessage.failedToSaveQuestion.localized): \(error.localizedDescription)"
            }
        }
    }
    
    /// Loads the draw results from Back4App, filtered by the current question.
    /// - Parameter question: The `Pointer<Question>` representing the current question.
    func loadDrawResults(for question: Pointer<Question>) {
        drawResultService.loadDrawResults(for: question) { result in
            switch result {
            case .success(let drawResults):
                DispatchQueue.main.async {
                    self.drawResults = drawResults
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "\(ErrorMessage.failedToLoadQuestions.localized): \(error.localizedDescription)"
                }
            }
        }
    }
}
