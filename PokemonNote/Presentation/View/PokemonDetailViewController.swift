//
//  PokemonDetailViewController.swift
//  PokemonNote
//
//  Created by 한아름 on 2021/03/16.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class PokemonDetailViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var noLocationLabel: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var basicInfoStackView: UIStackView!
    
    
    //MARK: - Life Cycle
    
    private var viewModel: PokemonDetailViewModel!
    private let bag = DisposeBag()
    
    static func create(with viewModel: PokemonDetailViewModel) -> PokemonDetailViewController {
        let vc = PokemonDetailViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        viewModel.viewDidLoad()
    }
    
    private func bindUI() {
        // Pokemon Model
        viewModel.pokemonModelSubject.observe(on: MainScheduler.instance).subscribe { [weak self] (event: Event<PokemonModel>) in
            guard let pokemonModel = event.element else { return }
            self?.nameLabel.text = (pokemonModel.names ?? []).joined(separator: " / ")
            self?.heightLabel.text = String(format: "키: %d", pokemonModel.height ?? 0)
            self?.weightLabel.text = String(format: "몸무게: %d", pokemonModel.weight ?? 0)
            
            if let frontDefaultUrl = pokemonModel.sprites?[.front_default] as? String {
                self?.profileImageView.kf.indicatorType = .activity
                self?.profileImageView.kf.setImage(with: URL(string: frontDefaultUrl)!, placeholder: nil, options: [.transition(.fade(0.3))], completionHandler: nil)
            } else if let randomUrl = pokemonModel.sprites?.values.compactMap({ $0
            }).first {
                self?.profileImageView.kf.indicatorType = .activity
                self?.profileImageView.kf.setImage(with: URL(string: randomUrl)!, placeholder: nil, options: [.transition(.fade(0.3))], completionHandler: nil)
            } else {
                
            }
            
            self?.basicInfoStackView.isHidden = false
        }.disposed(by: bag)
        
        // Map Button
        mapButton.rx.tap.subscribe { [weak self] (_) in
            self?.viewModel.didTapMapButton()
        }.disposed(by: bag)
        
        viewModel.noLocationSubject.observe(on: MainScheduler.instance).subscribe { [weak self] (event: Event<Bool>) in
            guard let isNoLocation = event.element else { return }
            self?.noLocationLabel.isHidden = !isNoLocation
            self?.mapButton.isHidden = isNoLocation
        }.disposed(by: bag)
        
        // Loading
        viewModel.isLoadingSubject.observe(on: MainScheduler.instance).subscribe { (event: Event<Bool>) in
            guard let isLoading = event.element else { return }
            if isLoading {
                LoadingView.show(.general(title: "상세 정보를 불러옵니다."))
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
    }
}
