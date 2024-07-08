//
//  StatisticsController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 20/06/2024.
//

import Foundation
import SwiftUI

/// A controller responsible for managing the state and operations related to statistics in the Tirajosaure app.
class StatisticsController: ObservableObject {
    let statisticsModel = StatisticsModel()
    
    /// Counts the occurrences of a specific option in the draw results.
    /// - Parameters:
    ///   - option: The option string to count occurrences for.
    ///   - drawResults: An array of `DrawResult` objects to search within.
    /// - Returns: The count of occurrences of the specified option in the draw results.
    func countOccurrences(of option: String, in drawResults: [DrawResult]) -> Int {
        return statisticsModel.countOccurrences(of: option, in: drawResults)
    }
    
    /// Retrieves statistics for each option in the provided options array based on the draw results.
    /// - Parameters:
    ///   - options: An array of option strings to generate statistics for.
    ///   - drawResults: An array of `DrawResult` objects to base the statistics on.
    /// - Returns: An array of `OptionStatistics` containing the statistics for each option.
    func getStatistics(for options: [String], in drawResults: [DrawResult]) -> [OptionStatistics] {
        return statisticsModel.getStatistics(for: options, in: drawResults)
    }
}
