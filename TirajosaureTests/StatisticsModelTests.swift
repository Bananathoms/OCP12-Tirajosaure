//
//  StatisticsModelTests.swift
//  TirajosaureTests
//
//  Created by Thomas Carlier on 21/06/2024.
//

import Foundation
import XCTest
import ParseSwift
@testable import Tirajosaure

class StatisticsModelTests: XCTestCase {

    var statisticsModel: StatisticsModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        statisticsModel = StatisticsModel()
    }

    override func tearDownWithError() throws {
        statisticsModel = nil
        try super.tearDownWithError()
    }

    func testCountOccurrences() {
        let drawResults = [
            DrawResult(option: "A", date: Date(), question: Pointer<Question>(objectId: "1")),
            DrawResult(option: "B", date: Date(), question: Pointer<Question>(objectId: "1")),
            DrawResult(option: "A", date: Date(), question: Pointer<Question>(objectId: "1")),
            DrawResult(option: "C", date: Date(), question: Pointer<Question>(objectId: "1"))
        ]
        
        let countA = statisticsModel.countOccurrences(of: "A", in: drawResults)
        let countB = statisticsModel.countOccurrences(of: "B", in: drawResults)
        let countC = statisticsModel.countOccurrences(of: "C", in: drawResults)
        let countD = statisticsModel.countOccurrences(of: "D", in: drawResults)
        
        XCTAssertEqual(countA, 2, "Expected 2 occurrences of option A")
        XCTAssertEqual(countB, 1, "Expected 1 occurrence of option B")
        XCTAssertEqual(countC, 1, "Expected 1 occurrence of option C")
        XCTAssertEqual(countD, 0, "Expected 0 occurrences of option D")
    }
    
    func testGetStatistics() {
        let drawResults = [
            DrawResult(option: "A", date: Date(), question: Pointer<Question>(objectId: "1")),
            DrawResult(option: "B", date: Date(), question: Pointer<Question>(objectId: "1")),
            DrawResult(option: "A", date: Date(), question: Pointer<Question>(objectId: "1")),
            DrawResult(option: "C", date: Date(), question: Pointer<Question>(objectId: "1"))
        ]
        let options = ["A", "B", "C", "D"]
        
        let statistics = statisticsModel.getStatistics(for: options, in: drawResults)
        
        XCTAssertEqual(statistics.count, 4, "Expected statistics for 4 options")
        
        XCTAssertEqual(statistics[0].option, "A", "Expected option A")
        XCTAssertEqual(statistics[0].count, 2, "Expected 2 occurrences of option A")
        XCTAssertEqual(statistics[0].percentage, 50.0, accuracy: 0.001, "Expected 50% for option A")
        
        XCTAssertEqual(statistics[1].option, "B", "Expected option B")
        XCTAssertEqual(statistics[1].count, 1, "Expected 1 occurrence of option B")
        XCTAssertEqual(statistics[1].percentage, 25.0, accuracy: 0.001, "Expected 25% for option B")
        
        XCTAssertEqual(statistics[2].option, "C", "Expected option C")
        XCTAssertEqual(statistics[2].count, 1, "Expected 1 occurrence of option C")
        XCTAssertEqual(statistics[2].percentage, 25.0, accuracy: 0.001, "Expected 25% for option C")
        
        XCTAssertEqual(statistics[3].option, "D", "Expected option D")
        XCTAssertEqual(statistics[3].count, 0, "Expected 0 occurrences of option D")
        XCTAssertEqual(statistics[3].percentage, 0.0, "Expected 0% for option D")
    }
}
