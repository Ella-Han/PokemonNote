//
//  PokemonListViewModel.swift
//  PokemonNote
//
//  Created by 한아름 on 2021/03/16.
//

import Foundation
import RxSwift

struct PokemonListViewModelActions {
    let showPokemonDetailView: (_ pokemonId: Int) -> Void
}

protocol PokemonListViewModelInput {
    func viewDidLoad()
    func didTapPokemonItem(pokemonId: Int)
    func didChageSearchText(query: String)
}

protocol PokemonListViewModelOutput {
    var sectionsSubject: BehaviorSubject<[PokemonSection]> { get }
    var isHiddenNoResultViewSubject: PublishSubject<Bool> { get }
    var isLoadingSubject: PublishSubject<Bool> { get }
    var serverErrorSubject: PublishSubject<String> { get }
}

protocol PokemonListViewModel: PokemonListViewModelInput, PokemonListViewModelOutput {}

final class DefaultPokemonListViewModel: PokemonListViewModel {
    private let actions: PokemonListViewModelActions
    private let getPokemonListUseCase = DefaultGetPokemonListUseCase()
    private var allPokemonModels: [PokemonModel]
    private let bag = DisposeBag()
    
    // MARK: - OUTPUT
    let sectionsSubject = BehaviorSubject<[PokemonSection]>(value: [])
    let isHiddenNoResultViewSubject = PublishSubject<Bool>()
    let isLoadingSubject = PublishSubject<Bool>()
    let serverErrorSubject = PublishSubject<String>()
    
    init(actions: PokemonListViewModelActions) {
        self.actions = actions
        self.allPokemonModels = []
    }
    
    private func fetchPokemonListFromServer() {
        isLoadingSubject.onNext(true)
        getPokemonListUseCase.execute().subscribe { [weak self] (models: [PokemonModel]) in
            self?.allPokemonModels = models
            self?.isLoadingSubject.onNext(false)
            self?.filterPokemonList(query: "")
            
        } onFailure: { [weak self] (error: Error) in
            self?.isLoadingSubject.onNext(false)
            self?.serverErrorSubject.onNext(error.localizedDescription)
            self?.isHiddenNoResultViewSubject.onNext(false)
            
        } onDisposed: { [weak self] in
            self?.isLoadingSubject.onNext(false)
        }.disposed(by: bag)
    }
    
    private func filterPokemonList(query: String) {
        if query.isEmpty {
            let itemViewModels = allPokemonModels.map {
                PokemonItemViewModel(pokemonId: $0.pokemonId, displayName: ($0.names ?? []).joined(separator: " / "))
            }
            sectionsSubject.onNext([PokemonSection(header: 0, items: itemViewModels)])
            isHiddenNoResultViewSubject.onNext(!itemViewModels.isEmpty)
            
        } else {
            // 포켓몬 수: N, 각 포켓몬의 이름수: M, 이름 길이: N
            // 최초 포켓몬 Trie 구성 시O(N*M*L^2), 검색 시 : O(L)
            let itemViewModels = PokemonManager.cache.trie.filter(query: query)
                .map { (data) -> PokemonItemViewModel in
                    PokemonItemViewModel(pokemonId: data.key, displayName: data.value)
                }.sorted { (item1, item2) -> Bool in
                    return item1.pokemonId < item2.pokemonId
                }
            
            // 검색 시 O(N*M*L)
//            let itemViewModels = allPokemonModels.compactMap { (pokemonModel: PokemonModel) -> PokemonItemViewModel? in
//                if let idx = pokemonModel.names?.firstIndex(where: { $0.lowercased().contains(query.lowercased()) }) {
//                    return PokemonItemViewModel(pokemonId: pokemonModel.pokemonId, displayName: pokemonModel.names?[idx] ?? "")
//                } else {
//                    return nil
//                }
//            }
            
            sectionsSubject.onNext([PokemonSection(header: 0, items: itemViewModels)])
            isHiddenNoResultViewSubject.onNext(!itemViewModels.isEmpty)
        }
    }
}

extension DefaultPokemonListViewModel {
    func viewDidLoad() {
        fetchPokemonListFromServer()
    }
    
    func didTapPokemonItem(pokemonId: Int) {
        LogI("didTapPokemonItem: pokemonId: \(pokemonId)")
        actions.showPokemonDetailView(pokemonId)
    }
    
    func didChageSearchText(query: String) {
        LogI("didChageSearchText: query: \(query)")
        filterPokemonList(query: query)
    }
}
