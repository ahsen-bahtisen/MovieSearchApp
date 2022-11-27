//
//  Movie.swift
//  InvioChallenge
//
//  Created by invio on 13.11.2022.
//

import Foundation

struct Movie: Codable, Equatable {
    var id: String
    var title: String
    var year: String
    var type: String
    var poster: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}
