//
//  PokemonAPI.swift
//  PokemonNote
//
//  Created by 한아름 on 2021/03/16.
//

import Foundation

enum PokemonAPI {
    case getAllPokemonList
    case getPokemonDetail(pokemonId: Int)
    case getAllPokemonLocations
    
    func asURL() -> URL {
        switch self {
        case .getAllPokemonList:
            return URL(string: "https://demo0928971.mockable.io/pokemon_name")!
            
        case .getAllPokemonLocations:
            return URL(string: "https://demo0928971.mockable.io/pokemon_locations")!
            
        case .getPokemonDetail(let pokemonId):
            return URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonId)")!
        }
    }
}
