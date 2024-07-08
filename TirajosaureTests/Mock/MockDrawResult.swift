//
//  MockDrawResult.swift
//  TirajosaureTests
//
//  Created by Thomas Carlier on 20/06/2024.
//

import Foundation
import ParseSwift
@testable import Tirajosaure

struct MockDrawResult {
    var drawResult: DrawResult
    var saveCompletion: ((@escaping (Result<DrawResult, AppError>) -> Void) -> Void)?
    
    func save(completion: @escaping (Result<DrawResult, AppError>) -> Void) {
        if let saveCompletion = saveCompletion {
            saveCompletion(completion)
        } else {
            completion(.success(drawResult))
        }
    }
}

