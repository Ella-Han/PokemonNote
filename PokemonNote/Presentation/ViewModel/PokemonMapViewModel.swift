//
//  PokemonMapViewModel.swift
//  PokemonNote
//
//  Created by 한아름 on 2021/03/16.
//

import Foundation
import RxSwift

struct PokemonMapViewModelActions {
    
}

protocol PokemonMapViewModelInput {
    func viewDidLoad()
}

protocol PokemonMapViewModelOutput {
    var locationSubject: PublishSubject<[PokemonLocation]> { get }
}

protocol PokemonMapViewModel: PokemonMapViewModelInput, PokemonMapViewModelOutput {}

final class DefaultPokemonMapViewModel: PokemonMapViewModel {
    private let pokemonId: Int
    private let actions: PokemonMapViewModelActions
    private let bag = DisposeBag()
    
    // MARK: - OUTPUT
    let locationSubject = PublishSubject<[PokemonLocation]>()
    
    init(actions: PokemonMapViewModelActions, pokemonId: Int) {
        self.actions = actions
        self.pokemonId = pokemonId
    }
}

extension DefaultPokemonMapViewModel {
    func viewDidLoad() {
        let locations = PokemonManager.cache.locationDict[pokemonId] ?? []
        locationSubject.onNext(locations)
    }
}

