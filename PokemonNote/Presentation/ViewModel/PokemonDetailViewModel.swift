//
//  PokemonDetailViewModel.swift
//  PokemonNote
//
//  Created by 한아름 on 2021/03/16.
//

import Foundation
import RxSwift

struct PokemonDetailViewModelActions {
    let showPokemonMapView: (_ pokemonId: Int) -> Void
}

protocol PokemonDetailViewModelInput {
    func viewDidLoad()
    func didTapMapButton()
}

protocol PokemonDetailViewModelOutput {
    var pokemonModelSubject: PublishSubject<PokemonModel> { get }
    var noLocationSubject: BehaviorSubject<Bool> { get }
    var isLoadingSubject: PublishSubject<Bool> { get }
    var serverErrorSubject: PublishSubject<String> { get }
}

protocol PokemonDetailViewModel: PokemonDetailViewModelInput, PokemonDetailViewModelOutput {}

final class DefaultPokemonDetailViewModel: PokemonDetailViewModel {
    private let pokemonId: Int
    private let actions: PokemonDetailViewModelActions
    private let getPokemonDetailUseCase = DefaultGetPokemonDetailUseCase()
    private let bag = DisposeBag()
    
    // MARK: - OUTPUT
    let pokemonModelSubject = PublishSubject<PokemonModel>()
    let noLocationSubject = BehaviorSubject<Bool>(value: true)
    let isLoadingSubject = PublishSubject<Bool>()
    let serverErrorSubject = PublishSubject<String>()
    
    init(actions: PokemonDetailViewModelActions, pokemonId: Int) {
        self.actions = actions
        self.pokemonId = pokemonId
    }
}

extension DefaultPokemonDetailViewModel {
    func viewDidLoad() {
        isLoadingSubject.onNext(true)
        
        getPokemonDetailUseCase.execute(pokemonId: pokemonId)
            .subscribe { [weak self] (pokemonModel: PokemonModel) in
                self?.pokemonModelSubject.onNext(pokemonModel)
                self?.noLocationSubject.onNext(PokemonManager.cache.locationDict[self?.pokemonId ?? 0]?.isEmpty ?? true)
                self?.isLoadingSubject.onNext(false)
                
            } onFailure: { [weak self] (error: Error) in
                self?.isLoadingSubject.onNext(false)
                self?.serverErrorSubject.onNext(error.localizedDescription)
                
            } onDisposed: { [weak self]  in
                self?.isLoadingSubject.onNext(false)
                
            }.disposed(by: bag)
    }
    
    func didTapMapButton() {
        LogI("didTapMapButton: pokemonId: \(pokemonId)")
        actions.showPokemonMapView(pokemonId)
    }
}
