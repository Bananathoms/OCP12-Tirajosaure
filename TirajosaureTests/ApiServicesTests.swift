//
//  ApiServicesTests.swift
//  TirajosaureTests
//
//  Created by Thomas Carlier on 14/06/2024.
//

import Foundation
import XCTest
import Alamofire
import OHHTTPStubs
import ParseSwift
@testable import Tirajosaure

class ApiServiceTests: XCTestCase {
    
    var apiService: ApiService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        apiService = ApiService()
    }
    
    override func tearDownWithError() throws {
        apiService = nil
        HTTPStubs.removeAllStubs()
        try super.tearDownWithError()
    }
    
    func testSignUpWithDefaultValues() {
        stub(condition: isMethodPOST() && isPath("/users")) { request in
            guard let httpBody = request.ohhttpStubs_httpBody else {
                return HTTPStubsResponse(error: NSError(domain: "com.example", code: 400, userInfo: nil))
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: Any] {
                    XCTAssertEqual(json[APIConstants.Parameters.username] as? String, DefaultValues.emptyString)
                    XCTAssertEqual(json[APIConstants.Parameters.email] as? String, DefaultValues.emptyString)
                    XCTAssertEqual(json[APIConstants.Parameters.password] as? String, DefaultValues.emptyString)
                    XCTAssertEqual(json[APIConstants.Parameters.firstName] as? String, DefaultValues.emptyString)
                    XCTAssertEqual(json[APIConstants.Parameters.lastName] as? String, DefaultValues.emptyString)
                } else {
                    XCTFail("Request body is not valid JSON")
                }
            } catch {
                XCTFail("Failed to parse request body: \(error)")
            }
            
            let stubData = """
            {
                "objectId": "12345",
                "username": "testuser",
                "email": "testuser@example.com",
                "firstName": "Test",
                "lastName": "User"
            }
            """.data(using: .utf8)!
            return HTTPStubsResponse(data: stubData, statusCode: 201, headers: ["Content-Type": "application/json"])
        }
        
        let user = User(username: nil, email: nil, password: nil, firstName: nil, lastName: nil)
        let expectation = self.expectation(description: "SignUp with default values succeeds")
        
        apiService.signUp(user: user) { result in
            switch result {
            case .success(let returnedUser):
                XCTAssertEqual(returnedUser.objectId, "12345")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("SignUp failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
