//
//  GetPokemonDetailUseCase.swift
//  PokemonNote
//
//  Created by 한아름 on 2021/03/16.
//

import Foundation
import RxSwift

protocol GetPokemonDetailUseCase {
    func execute(pokemonId: Int) -> Single<PokemonModel>
}

final class DefaultGetPokemonDetailUseCase: GetPokemonDetailUseCase {
    func execute(pokemonId: Int) -> Single<PokemonModel> {
        return PokemonManager.requestGetPokemonDetail(pokemonId: pokemonId)
    }
}
