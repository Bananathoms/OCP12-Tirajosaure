//
//  StatisticsModel.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 20/06/2024.
//

import Foundation

/// A model responsible for performing calculations and data processing related to statistics in the Tirajosaure app.
class StatisticsModel {
    /// Counts the occurrences of a specific option in the draw results.
    /// - Parameters:
    ///   - option: The option string to count occurrences for.
    ///   - drawResults: An array of `DrawResult` objects to search within.
    /// - Returns: The count of occurrences of the specified option in the draw results.
    func countOccurrences(of option: String, in drawResults: [DrawResult]) -> Int {
        return drawResults.filter { $0.option == option }.count
    }
    
    /// Generates statistics for each option in the provided options array based on the draw results.
    /// - Parameters:
    ///   - options: An array of option strings to generate statistics for.
    ///   - drawResults: An array of `DrawResult` objects to base the statistics on.
    /// - Returns: An array of `OptionStatistics` containing the statistics for each option.
    func getStatistics(for options: [String], in drawResults: [DrawResult]) -> [OptionStatistics] {
        let total = drawResults.count
        return options.map { option in
            let count = countOccurrences(of: option, in: drawResults)
            let percentage = total > 0 ? (Double(count) / Double(total)) * 100 : 0.0
            return OptionStatistics(option: option, count: count, percentage: percentage)
        }
    }
}

/// A struct representing statistical data for a specific option.
struct OptionStatistics {
    let option: String
    let count: Int
    let percentage: Double
}
