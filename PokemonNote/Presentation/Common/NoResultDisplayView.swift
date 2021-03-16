//
//  NoResultDisplayView.swift
//  PokemonNote
//
//  Created by 한아름 on 2021/03/16.
//

import Foundation
import UIKit

final class NoResultDisplayView: UIView {
    
    @IBOutlet var view: UIView!
    
    // MARK: Override functions

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
        addSubView(view: view)
    }

    private func loadViewFromNib() {
        Bundle.main.loadNibNamed("NoResultDisplayView", owner: self, options: nil)
        view.frame = bounds
        addSubView(view: view)
    }
}
