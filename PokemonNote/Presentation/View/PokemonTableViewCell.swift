//
//  PokemonTableViewCell.swift
//  PokemonNote
//
//  Created by 한아름 on 2021/03/16.
//

import UIKit
import RxSwift
import Kingfisher

class PokemonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    private (set) var bag = DisposeBag()
    
    override func prepareForReuse() {
        bag = DisposeBag()
        super.prepareForReuse()
    }
    
    func configure(viewModel: PokemonItemViewModel) {
        nameLabel.text = viewModel.displayName
    }
}
