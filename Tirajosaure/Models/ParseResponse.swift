//
//  ParseResponse.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 21/06/2024.
//


/// A generic struct to handle Parse API responses.
struct ParseResponse<T: Codable>: Codable {
    let results: [T]
}
