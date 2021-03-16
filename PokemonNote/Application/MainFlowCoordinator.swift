//
//  MainFlowCoordinator.swift
//  PokemonNote
//
//  Created by 한아름 on 2021/03/16.
//

import Foundation
import UIKit

final class MainFlowCoordinator {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = DefaultPokemonListViewModel(actions: PokemonListViewModelActions(showPokemonDetailView: showPokemonDetailView(pokemonId:)))
        let vc = PokemonListViewController.create(with: viewModel)
        vc.navigationItem.title = "포켓몬 목록"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showPokemonDetailView(pokemonId: Int) {
        let viewModel = DefaultPokemonDetailViewModel(actions: PokemonDetailViewModelActions(showPokemonMapView: showPokemonMapView(pokemonId:)), pokemonId: pokemonId)
        let vc = PokemonDetailViewController.create(with: viewModel)
        
        vc.navigationItem.title = "상세 정보"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showPokemonMapView(pokemonId: Int) {
        let viewModel = DefaultPokemonMapViewModel(actions: PokemonMapViewModelActions(), pokemonId: pokemonId)
        let vc = PokemonMapViewController.create(with: viewModel)
        let presentativeName = PokemonManager.cache.pokemonDict[pokemonId]?.names?.first ?? "포켓몬"
        vc.navigationItem.title = "\(presentativeName) 서식지"
        navigationController?.pushViewController(vc, animated: true)
    }
}
