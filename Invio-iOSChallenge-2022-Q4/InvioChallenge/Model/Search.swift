//
//  Search.swift
//  InvioChallenge
//
//  Created by invio on 13.11.2022.
//

import Foundation

struct Search: Codable {
    var movies: [Movie]?
    var totalResults: String?
    var response: String
    var error: String?
    
    enum CodingKeys: String, CodingKey {
        case movies = "Search"
        case totalResults = "totalResults"
        case response = "Response"
        case error = "Error"
    }
}
