//
//  GetPokemonListUseCase.swift
//  PokemonNote
//
//  Created by 한아름 on 2021/03/16.
//

import Foundation
import RxSwift

protocol GetPokemonListUseCase {
    func execute() -> Single<[PokemonModel]>
}
//PokemonManager.Repository.makePokemonTrie()
final class DefaultGetPokemonListUseCase: GetPokemonListUseCase {
    func execute() -> Single<[PokemonModel]> {
        PokemonManager.requestGetPokemonLocations()
            .flatMap { (_) in
                PokemonManager.requestGetPokemonList()
            }
    }
}
