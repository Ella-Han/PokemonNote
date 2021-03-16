//
//  PokemonStorage.swift
//  PokemonNote
//
//  Created by 한아름 on 2021/03/16.
//

import Foundation

final class PokemonStorage {
    
    private (set) var pokemonDict: [Int:PokemonModel] = [:]
    private (set) var locationDict: [Int:[PokemonLocation]] = [:]
    private (set) var trie = PokemonTrie()
    
    func buildPokemonModel(dict: NSDictionary) -> PokemonModel? {
        guard let pokemonId = dict["id"] as? Int else { return nil }
        let oldPokemon = pokemonDict[pokemonId]
        
        var sprites: [PokemonSprites:String?] = [:]
        if let spritesDict = dict["sprites"] as? [String:Any] {
            spritesDict.compactMap {
                PokemonSprites(rawValue: $0.key)
            }.forEach {
                sprites[$0] = spritesDict[$0.rawValue] as? String
            }
        }
        
        let pokemonModel = PokemonModel(pokemonId: pokemonId,
                                        names: dict["names"] as? [String] ?? oldPokemon?.names,
                                        height: dict["height"] as? Int ?? oldPokemon?.height,
                                        weight: dict["weight"] as? Int ?? oldPokemon?.weight,
                                        sprites: sprites)
        pokemonDict[pokemonId] = pokemonModel
        return pokemonModel
    }
    
    func buildPokemonLocations(dict: NSDictionary) -> PokemonLocation? {
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else { return nil }
        guard let pokemonLoc = try? JSONDecoder().decode(PokemonLocation.self, from: data) else { return nil }
        
        if locationDict[pokemonLoc.pokemonId] == nil {
            locationDict[pokemonLoc.pokemonId] = [PokemonLocation]()
        }
        locationDict[pokemonLoc.pokemonId]?.append(pokemonLoc)
        return pokemonLoc
    }
    
    func buildPokemonTrie() {
        pokemonDict.values.forEach {
            trie.insert(pokemon: $0)
        }
    }
}
