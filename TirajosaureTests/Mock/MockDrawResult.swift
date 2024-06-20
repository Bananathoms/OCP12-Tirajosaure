//
//  MockDrawResult.swift
//  TirajosaureTests
//
//  Created by Thomas Carlier on 20/06/2024.
//

import Foundation
import ParseSwift
@testable import Tirajosaure

class MockDrawResult {
    var drawResult: DrawResult
    var saveCompletion: ((@escaping (Result<DrawResult, ParseError>) -> Void) -> Void)?
    
    init(drawResult: DrawResult) {
        self.drawResult = drawResult
    }
    
    func save(completion: @escaping (Result<DrawResult, ParseError>) -> Void) {
        if let saveCompletion = saveCompletion {
            saveCompletion(completion)
        } else {
            completion(.failure(ParseError(code: .unknownError, message: "No saveCompletion closure defined")))
        }
    }
}
