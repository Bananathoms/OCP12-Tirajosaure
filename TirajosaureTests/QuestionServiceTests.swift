//
//  QuestionServiceTests.swift
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

class QuestionServiceTests: XCTestCase {
    
    var questionService: QuestionService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        questionService = QuestionService.shared
    }

    override func tearDownWithError() throws {
        questionService = nil
        HTTPStubs.removeAllStubs()
        try super.tearDownWithError()
    }
    
    func testFetchQuestionsSuccess() {
        stub(condition: isPath("/classes/Question") && isMethodGET()) { _ in
            let stubData = """
            {
                "results": [
                    {
                        "objectId": "12345",
                        "title": "Test Question",
                        "options": ["Option1", "Option2"],
                        "user": {
                            "__type": "Pointer",
                            "className": "_User",
                            "objectId": "TestUserId"
                        }
                    }
                ]
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 200, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectation(description: "Fetch questions succeeds")
        
        questionService.fetchQuestions(for: "TestUserId") { result in
            switch result {
            case .success(let questions):
                XCTAssertEqual(questions.count, 1)
                XCTAssertEqual(questions.first?.objectId, "12345")
                XCTAssertEqual(questions.first?.title, "Test Question")
                XCTAssertEqual(questions.first?.options, ["Option1", "Option2"])
                XCTAssertEqual(questions.first?.user.objectId, "TestUserId")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Fetch questions failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchQuestionsFailure() {
        stub(condition: isPath(APIConstants.Endpoints.questionsBase) && isMethodGET()) { _ in
            let stubData = """
            {
                "code": 101,
                "error": "Test error"
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 400, headers: ["Content-Type": "application/json"])
        }

        let expectation = self.expectation(description: "Fetch questions fails")

        questionService.fetchQuestions(for: "TestUserId") { result in
            switch result {
            case .success:
                XCTFail("Fetch questions succeeded unexpectedly")
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

    func testSaveQuestionSuccess() {
        stub(condition: isMethodPOST() && isPath(APIConstants.Endpoints.questionsBase)) { _ in
            let stubData = """
            {
                "objectId": "12345",
                "createdAt": "2024-06-21T21:48:41.085Z",
                "updatedAt": "2024-06-21T21:48:41.085Z"
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 201, headers: ["Content-Type": "application/json"])
        }

        let question = Question(title: "New Question", options: ["Option1", "Option2"], user: Pointer<User>(objectId: "TestUserId"))
        let expectation = self.expectation(description: "Save question succeeds")

        questionService.saveQuestion(question) { result in
            switch result {
            case .success(let savedQuestion):
                XCTAssertEqual(savedQuestion.objectId, "12345")
                XCTAssertNotNil(savedQuestion.createdAt)
                XCTAssertNotNil(savedQuestion.updatedAt)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Save question failed with error: \(error)")
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSaveQuestionFailure() {
        stub(condition: isPath(APIConstants.Endpoints.questionsBase) && isMethodPOST()) { _ in
            let stubData = """
            {
                "code": 101,
                "error": "Test error"
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 400, headers: ["Content-Type": "application/json"])
        }

        let question = Question(title: "Test Question", options: ["Option1", "Option2"], user: Pointer<User>(objectId: "TestUserId"))
        let expectation = self.expectation(description: "Save question fails")

        questionService.saveQuestion(question) { result in
            switch result {
            case .success:
                XCTFail("Save question succeeded unexpectedly")
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

    func testSaveQuestionWithObjectIdSuccess() {
        let objectId = "12345"
        var question = Question(title: "Test Question", options: ["Option1", "Option2"], user: Pointer<User>(objectId: "TestUserId"))
        question.objectId = objectId

        stub(condition: isPath("\(APIConstants.Endpoints.questionsBase)/\(objectId)") && isMethodPUT()) { request in
            let requestBody = try? JSONSerialization.jsonObject(with: request.ohhttpStubs_httpBody ?? Data(), options: []) as? [String: Any]
            
            XCTAssertEqual(requestBody?[DefaultValues.objectId] as? String, objectId)
            XCTAssertEqual(requestBody?[APIConstants.Parameters.title] as? String, question.title)
            XCTAssertEqual(requestBody?[APIConstants.Parameters.options] as? [String], question.options)
            XCTAssertEqual((requestBody?[APIConstants.Parameters.user] as? [String: String])?["objectId"], question.user.objectId)
            
            let stubData = """
            {
                "objectId": "\(objectId)",
                "createdAt": "2024-06-21T22:08:04.465Z",
                "updatedAt": "2024-06-21T22:08:04.465Z"
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 200, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectation(description: "Save question with objectId succeeds")
        
        questionService.saveQuestion(question) { result in
            switch result {
            case .success(let savedQuestion):
                XCTAssertEqual(savedQuestion.objectId, objectId)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Save question failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSaveQuestionWithoutUpdatedAtSuccess() {
        let objectId = "12345"
        var question = Question(title: "Test Question", options: ["Option1", "Option2"], user: Pointer<User>(objectId: "TestUserId"))
        question.objectId = objectId
        
        stub(condition: isPath("\(APIConstants.Endpoints.questionsBase)/\(objectId)") && isMethodPUT()) { _ in
            let stubData = """
            {
                "objectId": "\(objectId)",
                "createdAt": "2024-06-21T22:08:04.465Z"
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 200, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectation(description: "Save question without updatedAt succeeds")
        
        questionService.saveQuestion(question) { result in
            switch result {
            case .success(let savedQuestion):
                XCTAssertEqual(savedQuestion.objectId, objectId)
                XCTAssertEqual(savedQuestion.createdAt, DateFormatter.iso8601Full.date(from: "2024-06-21T22:08:04.465Z"))
                XCTAssertNil(savedQuestion.updatedAt)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Save question failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDeleteQuestionSuccess() {
        let objectId = "12345"
        var question = Question(title: "Test Question", options: ["Option1", "Option2"], user: Pointer<User>(objectId: "TestUserId"))
        question.objectId = objectId
        
        stub(condition: isPath("/classes/Question/12345") && isMethodDELETE()) { _ in
            return HTTPStubsResponse(data: Data(), statusCode: 200, headers: nil)
        }
        
        let expectation = self.expectation(description: "Delete question succeeds")
        
        questionService.deleteQuestion(question) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Delete question failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDeleteQuestionFailure() {
        let objectId = "12345"
        var question = Question(title: "Test Question", options: ["Option1", "Option2"], user: Pointer<User>(objectId: "TestUserId"))
        question.objectId = objectId // Assigner l'objectId ici

        stub(condition: isPath(APIConstants.Endpoints.questionById.replacingOccurrences(of: FormatConstants.objectIdPlaceholder, with: objectId)) && isMethodDELETE()) { _ in
            let stubData = """
            {
                "code": 101,
                "error": "Test error"
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 400, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectation(description: "Delete question fails")
        
        questionService.deleteQuestion(question) { result in
            switch result {
            case .success:
                XCTFail("Delete question succeeded unexpectedly")
            case .failure(let error):
                switch error {
                case .networkError(let message):
                    XCTAssertTrue(message.contains("Test error"))
                default:
                    XCTFail("Expected networkError but got \(error)")
                }
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testDeleteQuestionValidationError() {
        let question = Question(title: "Test Question", options: ["Option1", "Option2"], user: Pointer<User>(objectId: "TestUserId"))
        
        let expectation = self.expectation(description: "Delete question fails with validation error")
        
        questionService.deleteQuestion(question) { result in
            switch result {
            case .success:
                XCTFail("Delete question succeeded unexpectedly")
            case .failure(let error):
                XCTAssertEqual(error, .validationError(ErrorMessage.invalidQuestionID.localized))
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

}
