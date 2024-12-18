//
//  Extension+ApiService.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 21/06/2024.
//

import Foundation

extension ApiService {
    func pointerParams(className: String, objectId: String) -> [String: Any] {
        APIConstants.Parameters.pointerParams(className: className, objectId: objectId)
    }
    
    func wherePointer(type: APIConstants.Parameters.PointerType, objectId: String) -> [String: Any] {
        APIConstants.Parameters.wherePointer(type: type, objectId: objectId)
    }
    
    func dateParameter(from date: Date) -> [String: Any] {
        APIConstants.Parameters.dateParameter(from: date)
    }
}
