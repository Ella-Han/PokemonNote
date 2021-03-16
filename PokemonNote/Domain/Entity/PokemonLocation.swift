//
//  PokemonLocation.swift
//  PokemonNote
//
//  Created by 한아름 on 2021/03/16.
//

import Foundation

struct PokemonLocation: Codable {
    let pokemonId: Int
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case pokemonId = "id"
        case latitude = "lat"
        case longitude = "lng"
    }
}
