//
//  PokemonModel.swift
//  PokemonNote
//
//  Created by 한아름 on 2021/03/16.
//

import Foundation

struct PokemonModel: Codable {
    let pokemonId: Int
    let names: [String]?
    let height: Int?
    let weight: Int?
    let sprites: [PokemonSprites:String?]?
    
    private enum CodingKeys: String, CodingKey {
        case pokemonId = "id"
        case names
        case height
        case weight
        case sprites
    }
}

enum PokemonSprites: String, Codable {
    case front_default
    case front_shiny
    case front_female
    case front_shiny_female
    case back_default
    case back_shiny
    case back_female
    case back_shiny_female
}
