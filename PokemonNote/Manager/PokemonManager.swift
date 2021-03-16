//
//  PokemonManager.swift
//  PokemonNote
//
//  Created by 한아름 on 2021/03/16.
//

import Foundation
import RxAlamofire
import RxSwift

final class PokemonManager {
    static let manager: PokemonManager = PokemonManager()
    private var cache: PokemonStorage!
    static var cache: PokemonStorage { return manager.cache }
    
    func initialize() {
        cache = PokemonStorage()
    }
    
    func destroy() {
        cache = nil
    }
    
    static func requestGetPokemonList() -> Single<[PokemonModel]> {
        RxAlamofire.requestJSON(.get, PokemonAPI.getAllPokemonList.asURL())
            .asSingle()
            .map({ (obj) ->[PokemonModel] in
                if let dictList = (obj.1 as? NSDictionary)?["pokemons"] as? [NSDictionary] {
                    let allPokemons = dictList.compactMap { PokemonManager.cache.buildPokemonModel(dict: $0) }
                    PokemonManager.cache.buildPokemonTrie()
                    return allPokemons
                } else {
                    return []
                }
            })
    }
    
    static func requestGetPokemonDetail(pokemonId: Int) -> Single<PokemonModel> {
        RxAlamofire.requestJSON(.get, PokemonAPI.getPokemonDetail(pokemonId: pokemonId).asURL())
            .asSingle()
            .map { (obj) -> PokemonModel in
                if let dict = obj.1 as? NSDictionary,
                   let pokemonModel = PokemonManager.cache.buildPokemonModel(dict: dict) {
                    return pokemonModel
                } else {
                    return PokemonModel(pokemonId: -1, names: ["dummy pokemon"], height: nil, weight: nil, sprites: nil)
                }
            }
    }
    
    static func requestGetPokemonLocations() -> Single<[PokemonLocation]> {
        RxAlamofire.requestJSON(.get, PokemonAPI.getAllPokemonLocations.asURL())
            .asSingle()
            .map { (obj) -> [PokemonLocation] in
                if let dictList = (obj.1 as? NSDictionary)?["pokemons"] as? [NSDictionary] {
                    return dictList.compactMap { PokemonManager.cache.buildPokemonLocations(dict: $0) }
                } else {
                    return []
                }
            }
    }
}
