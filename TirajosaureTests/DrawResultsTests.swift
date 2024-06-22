//
//  DrawResultServiceTests.swift
//  TirajosaureTests
//
//  Created by Thomas Carlier on 22/06/2024.
//

import Foundation
import XCTest
@testable import Tirajosaure
import OHHTTPStubs
import Alamofire
import ParseSwift

class DrawResultServiceTests: XCTestCase {
    var drawResultService: DrawResultService!
    var apiService: ApiService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        drawResultService = DrawResultService()
        apiService = ApiService.current
        HTTPStubs.removeAllStubs()
    }
    
    override func tearDownWithError() throws {
        drawResultService = nil
        apiService = nil
        HTTPStubs.removeAllStubs()
        try super.tearDownWithError()
    }
    
    func testSaveDrawResultSuccess() {
        let drawResult = DrawResult(option: "TestOption", date: Date(), question: Pointer<Question>(objectId: "TestQuestion"))
        
        stub(condition: isPath("/classes/DrawResult")) { request in
            let stubData = """
            {
                "objectId": "91y2I4Hj7y",
                "createdAt": "2024-06-21T21:48:41.085Z",
                "option": "\(drawResult.option)",
                "date": {
                    "__type": "Date",
                    "iso": "\(DateFormatter.iso8601Full.string(from: drawResult.date))"
                },
                "question": {
                    "__type": "Pointer",
                    "className": "Question",
                    "objectId": "\(drawResult.question.objectId)"
                }
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 201, headers: ["Content-Type": "application/json"])
        }
        
        var mockDrawResult = MockDrawResult(drawResult: drawResult)
        mockDrawResult.saveCompletion = { completion in
            completion(.success(drawResult))
        }
        
        let expectation = self.expectation(description: "Save draw result succeeds")
        
        drawResultService.saveDrawResult(mockDrawResult.drawResult) { result in
            switch result {
            case .success(let savedResult):
                XCTAssertEqual(savedResult.objectId, "91y2I4Hj7y")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Save draw result failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSaveDrawResultFailure() {
        stub(condition: isPath("/classes/DrawResult")) { request in
            let stubData = """
            {
                "code": 101,
                "error": "Test error"
            }
            """.data(using: .utf8)!
            let response = HTTPStubsResponse(data: stubData, statusCode: 400, headers: ["Content-Type": "application/json"])
            return response
        }
        
        let drawResult = DrawResult(option: "TestOption", date: Date(), question: Pointer<Question>(objectId: "TestQuestion"))
        
        let expectation = self.expectation(description: "Save draw result fails")
        
        drawResultService.saveDrawResult(drawResult) { result in
            switch result {
            case .success:
                XCTFail("Save draw result succeeded unexpectedly")
            case .failure(let error):
                
                if case let .networkError(message) = error {
                    XCTAssertTrue(message.contains("Test error"))
                } else {
                    XCTFail("Expected networkError but got \(error)")
                }
                
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadDrawResultsSuccess() {
        let dateString = DateFormatter.iso8601Full.string(from: Date(timeIntervalSince1970: 1592677854.503))
        stub(condition: isPath("/classes/DrawResult")) { _ in
            let stubData = """
            {
                "results": [
                    {
                        "objectId": "123",
                        "option": "TestOption",
                        "date": {
                            "__type": "Date",
                            "iso": "\(dateString)"
                        },
                        "question": {
                            "__type": "Pointer",
                            "className": "Question",
                            "objectId": "TestQuestion"
                        }
                    }
                ]
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 200, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectation(description: "Load draw results succeeds")
        
        drawResultService.loadDrawResults(for: Pointer<Question>(objectId: "TestQuestion")) { result in
            switch result {
            case .success(let results):
                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(results.first?.objectId, "123")
                XCTAssertEqual(results.first?.option, "TestOption")
                XCTAssertEqual(results.first?.question.objectId, "TestQuestion")
                XCTAssertEqual(DateFormatter.iso8601Full.string(from: results.first?.date ?? Date()), dateString)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Load draw results failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadDrawResultsFailure() {
        stub(condition: isPath("/classes/DrawResult")) { _ in
            let stubData = """
            {
                "code": 101,
                "error": "Test error"
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 400, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectation(description: "Load draw results fails")
        
        drawResultService.loadDrawResults(for: Pointer<Question>(objectId: "TestQuestion")) { result in
            switch result {
            case .success:
                XCTFail("Load draw results succeeded unexpectedly")
            case .failure(let error):
                if case let .networkError(message) = error {
                    XCTAssertTrue(message.contains("Test error"))
                } else {
                    XCTFail("Expected networkError but got \(error)")
                }
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
