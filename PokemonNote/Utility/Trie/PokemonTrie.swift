//
//  PokemonTrie.swift
//  PokemonNote
//
//  Created by 한아름 on 2021/03/16.
//

import Foundation

class PokemonTrie {
    typealias Node = TrieNode<Character>
      fileprivate let root: Node

      init() {
        root = Node()
      }
}

extension PokemonTrie {
    func insert(pokemon: PokemonModel) {
        pokemon.names?.forEach({
            let originName = $0
            for i in 0..<$0.count {
                guard let range = Range(NSRange(location: i, length: $0.count - i), in: $0) else { continue }
                let word = String($0[range])
                guard !word.isEmpty else { continue }
                insert(word: word, pokemonId: pokemon.pokemonId, originName: originName)
            }
        })
    }
    
    private func insert(word: String, pokemonId: Int, originName: String) {
        guard !word.isEmpty else { return }

        var currentNode = root
        let characters = Array(word.lowercased().map({ $0 }))
        var currentIndex = 0

        while currentIndex < characters.count {
            let character = characters[currentIndex]
            if let child = currentNode.children[character] {
                currentNode = child
            } else {
                currentNode.add(child: character)
                currentNode = currentNode.children[character]!
            }
            currentNode.pokemonDict[pokemonId] = originName
            currentIndex += 1
        }
        currentNode.isTerminating = true
    }
    
    func filter(query: String) -> [Int:String] {
        guard !query.isEmpty else { return [:] }
        var currentNode = root
        
        let characters = Array(query.lowercased().map({ $0 }))
        var currentIndex = 0

        while currentIndex < characters.count, let child = currentNode.children[characters[currentIndex]] {
            currentIndex += 1
            currentNode = child
        }
        
        if currentIndex == characters.count {
            return currentNode.pokemonDict
        } else {
            return [:]
        }
    }
    
    func contains(word: String) -> Bool {
        guard !word.isEmpty else { return false }
        var currentNode = root

        let characters = Array(word.lowercased().map({ $0 }))
        var currentIndex = 0

        while currentIndex < characters.count, let child = currentNode.children[characters[currentIndex]] {
            currentIndex += 1
            currentNode = child
        }
        
        if currentIndex == characters.count && currentNode.isTerminating {
            return true
        } else {
            return false
        }
    }
}

class TrieNode<T: Hashable> {
    var value: T?
    weak var parent: TrieNode?
    var children: [T: TrieNode] = [:]
    var pokemonDict: [Int:String] = [:] // pokemonId:name
    var isTerminating = false

    init(value: T? = nil, parent: TrieNode? = nil) {
        self.value = value
        self.parent = parent
    }
    
    func add(child: T) {
        guard children[child] == nil else { return }
        children[child] = TrieNode(value: child, parent: self)
    }
}
