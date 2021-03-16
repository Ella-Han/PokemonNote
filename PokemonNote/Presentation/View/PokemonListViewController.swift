//
//  PokemonListViewController.swift
//  PokemonNote
//
//  Created by 한아름 on 2021/03/16.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxGesture

class PokemonListViewController: UIViewController {

    @IBOutlet weak var pokemonTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noResultDisplayView: UIView!
    
    static func create(with viewModel: PokemonListViewModel) -> PokemonListViewController {
        let vc = PokemonListViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    // MARK: - Life Cycle
    private var viewModel: PokemonListViewModel!
    private var bag = DisposeBag()
    private var dataSource: RxTableViewSectionedAnimatedDataSource<PokemonSection>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        makeDataSource()
        bindUI()
        viewModel.viewDidLoad()
    }
    
    private func makeDataSource() {
        dataSource = RxTableViewSectionedAnimatedDataSource<PokemonSection> (animationConfiguration: AnimationConfiguration(insertAnimation: .none, reloadAnimation: .none, deleteAnimation: .none), configureCell: { [weak self] (dataSource: TableViewSectionedDataSource<PokemonSection>, tableView: UITableView, indexPath: IndexPath, itemViewModel: TableViewSectionedDataSource<PokemonSection>.Item) -> UITableViewCell in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonTableViewCell", for: indexPath) as? PokemonTableViewCell else { return UITableViewCell() }
            cell.configure(viewModel: itemViewModel)
            cell.rx.tapGesture().when(.ended).subscribe { [unowned self] (event: Event<UITapGestureRecognizer>) in
                self?.viewModel.didTapPokemonItem(pokemonId: itemViewModel.pokemonId)
            }.disposed(by: cell.bag)
            
            return cell
        })
    }
    
    private func registerCell() {
        pokemonTableView.register(UINib(nibName: "PokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "PokemonTableViewCell")
    }
    
    private func bindUI() {
        // Sections
        viewModel.sectionsSubject
            .bind(to: pokemonTableView.rx.items(dataSource: dataSource!))
            .disposed(by: bag)
        
        // No Search Result
        viewModel.isHiddenNoResultViewSubject
            .bind(to: noResultDisplayView.rx.isHidden)
            .disposed(by: bag)
        
        noResultDisplayView.rx.panGesture().when(.recognized).subscribe { [weak self] _ in
            self?.searchBar.resignFirstResponder()
        }.disposed(by: bag)
        
        // Loading
        viewModel.isLoadingSubject.observe(on: MainScheduler.instance).subscribe { (event: Event<Bool>) in
            guard let isLoading = event.element else { return }
            if isLoading {
                LoadingView.show(.general(title: "포켓몬 목록을 구성중입니다."))
            } else {
                LoadingView.hide()
            }
        }.disposed(by: bag)
        
        // Server Error
        viewModel.serverErrorSubject.observe(on: MainScheduler.instance).subscribe { [weak self] (event: Event<String>) in
            guard let errorMsg = event.element else { return }
            let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }.disposed(by: bag)
        
        // Search
        searchBar.rx.text
            .orEmpty
            .changed
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe { [weak self] (event: Event<String>) in
                guard let query = event.element else { return }
                self?.viewModel.didChageSearchText(query: query)
            }.disposed(by: bag)
    }
}
