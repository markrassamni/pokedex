//
//  Pokemon.swift
//  pokedex
//
//  Created by Mark Rassamni on 8/8/16.
//  Copyright © 2016 markrassamni. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _desc: String!
    private var _attack: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _type: String!
    private var _nextEvoText: String!
    private var _pokemonUrl: String!
    private var _nextEvoId: String!
    private var _nextEvoLvl: String!
    
    var name: String {
        return _name
    }
    var pokedexId: Int {
        return _pokedexId
    }
    var desc: String {
        if _desc == nil {
            _desc = "Failed to load http://pokeapi.co"
        }
        return _desc
    }
    var attack: String{
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    var nextEvoText: String {
        if _nextEvoText == nil {
            _nextEvoText = "Could not load evolutions!"
        }
        return _nextEvoText
    }
    var nextEvoId: String {
        if _nextEvoId == nil {
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    var nextEvoLvl: String {
        if _nextEvoLvl == nil {
            _nextEvoLvl = ""
        }
        return _nextEvoLvl
    }
    
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete){
        let url = NSURL(string: _pokemonUrl)
        Alamofire.request(.GET, url!).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject>{
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                if let types = dict["types"] as? [Dictionary<String, String>] {
                    if types.count == 0 {
                        self._type = "No Type"
                    } else {
                        if let name = types[0]["name"] {
                            self._type = name.capitalizedString
                        }
                        if types.count > 1 {
                            for x in 1..<types.count{
                                if let name = types[x]["name"] {
                                    self._type! += "/\(name.capitalizedString)"
                                }
                            }
                        }
                    }
                } //end types
                if let descArr = dict["descriptions"] as? [Dictionary<String, AnyObject>]{
                    if descArr.count == 0{
                        self._desc = "No descriptipn available for this Pokemon"
                    } else {
                        if let url = descArr[0]["resource_uri"] {
                            let nsurl = NSURL(string: "\(URL_BASE)\(url)")
                            Alamofire.request(.GET, nsurl!).responseJSON { response in
                                let descResult = response.result
                                if let descDict = descResult.value as? Dictionary<String, AnyObject>{
                                    if let desc = descDict["description"] as? String{
                                        self._desc = desc
                                        print(self._desc)
                                    }
                                }
                                completed() // MIGHT NEED MOVED DOWN?!
                            } // end closure
                        }
                    }
                  
                } // end desc
            
                if let evoArr = dict["evolutions"] as? [Dictionary<String, AnyObject>] {
                    if evoArr.count == 0 {
                        //no image no text
                        
                    } else {
                        if let to = evoArr[0]["to"] as? String {
                            //program cannot support mega pokemon although the api does
                            if to.rangeOfString("mega") == nil {
                                if let uri = evoArr[0]["resource_uri"] as? String{
                                    let stripUri = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon", withString: "")
                                    let nextEvoId = stripUri.stringByReplacingOccurrencesOfString("/", withString: "")
                                    self._nextEvoId = nextEvoId
                                    //self._nextEvoId = "serverDown"
                                    self._nextEvoText = to.capitalizedString
                                    
                                    if let level = evoArr[0]["level"] as? Int {
                                        self._nextEvoLvl = "\(level)"
                                    } // what if no level? 
                                }
                            } else {
                                // if mega pokemon
                               
                            }
                        }
                    }
                } // end evo
                
            } // end parsing
            
        } // end closure
    } // end func
    
} // end class

