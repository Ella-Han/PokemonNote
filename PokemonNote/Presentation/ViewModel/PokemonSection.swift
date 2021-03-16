//
//  PokemonSection.swift
//  PokemonNote
//
//  Created by 한아름 on 2021/03/16.
//

import Foundation
import RxDataSources

struct PokemonSection {
    var header: Int
    var items: [Item]
}

extension PokemonSection: AnimatableSectionModelType {
    typealias Item = PokemonItemViewModel
    var identity: Int { header }
    
    init(original: PokemonSection, items: [Item]) {
        self = original
        self.items = items
    }
}

struct PokemonItemViewModel: Equatable, IdentifiableType {
    let pokemonId: Int
    let displayName: String
    
    typealias Identity = Int
    var identity: Int { return pokemonId }
}
