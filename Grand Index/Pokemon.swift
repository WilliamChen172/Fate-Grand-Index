//
//  Pokemon.swift
//  Fate Grand Index
//
//  Created by William Chen on 21/09/2017.
//  Copyright © 2017 William Chen. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{
    private var _name: String!
    private var _pokedexId: Int!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _prevEvol: String!
    private var _prevEvolId: Int!
    private var _pokemonURL: String!
    
    var name: String {
         return _name.capitalized
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var type: String {
        return _type
    }
    
    var defense: String {
        return _defense
    }
    
    var height: String {
        return _height
    }
    
    var weight: String {
        return _weight
    }
    
    var attack: String {
        return _attack
    }
    
    var preEvol: String {
        return _prevEvol
    }
    
    var preEvolId: Int {
        return _prevEvolId
    }
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId!)"
        self._type = ""
        self._defense = ""
        self._height = ""
        self._weight = ""
        self._attack = ""
        self._prevEvol = ""
        self._prevEvolId = 0
    }
    
    func downloadPokemonDetails(complete: @escaping DownloadComplete) {
        let url = URL(string: _pokemonURL)!
        Alamofire.request(url).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? Int {
                    self._weight = "\(weight)"
                }
                if let height = dict["height"] as? Int {
                    self._height = "\(height)"
                }
                if let stats = dict["stats"] as? [Dictionary<String, AnyObject>] {
                    if let attack = stats[5]["base_stat"] as? Int {
                        self._attack = "\(attack)"
                    }
                }
                if let stats = dict["stats"] as? [Dictionary<String, AnyObject>] {
                    if let defense = stats[4]["base_stat"] as? Int {
                        self._defense = "\(defense)"
                    }
                }
                if let types = dict["types"] as? [Dictionary<String, AnyObject>] {
                    if let type = types[0]["type"] as? Dictionary<String, AnyObject> {
                        if let name = type["name"] as? String {
                            self._type = name
                        }
                    }
                    if types.count > 1 {
                        for i in 1...types.count - 1 {
                            if let type = types[i]["type"] as? Dictionary<String, AnyObject> {
                                if let name = type["name"] as? String {
                                    self._type! += "/\(name)"
                                }
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
            }
            complete()
        }
    }
    func downloadPokemonSpeciesDetails(complete: @escaping DownloadComplete) {
        let specUrl = URL(string: "\(URL_BASE)\(URL_POKEMON_SPECIES)\(self._pokedexId!)")!
        Alamofire.request(specUrl).responseJSON(completionHandler: { response in
            let specResult = response.result
            if let specDict = specResult.value as? Dictionary<String, AnyObject> {
                if let specEvol = specDict["evolves_from_species"] as? Dictionary<String, AnyObject> {
                    if let specName = specEvol["name"] as? String {
                        self._prevEvol = specName
                    }
                    if let specId = specEvol["url"] as? String {
                        self._prevEvolId = Int(specId.dropFirst(URL_BASE.count + URL_POKEMON_SPECIES.count).dropLast())
                    }
                } else {
                    self._prevEvol = ""
                    self._prevEvolId = 0
                }
            }
            complete()
        })
    }
}
