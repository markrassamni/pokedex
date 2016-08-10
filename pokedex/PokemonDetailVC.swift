//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Mark Rassamni on 8/8/16.
//  Copyright © 2016 markrassamni. All rights reserved.
//

import UIKit



class PokemonDetailVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var currentEvo: UIImageView!
    @IBOutlet weak var nextEvo: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var evoArrow: UIImageView!
    @IBOutlet var hiddenLabels: [UILabel]!
    @IBOutlet weak var grayBar: UIView!
    
    
    
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name.capitalizedString
        mainImg.image = UIImage(named: "\(pokemon.pokedexId)")
        currentEvo.image = mainImg.image
        
        
        pokemon.downloadPokemonDetails { () -> () in
            self.updateUI()
        }
    }
    
    func updateUI(){
        
        descLbl.text = pokemon.desc
        typeLbl.text = pokemon.type
        idLbl.text = "\(pokemon.pokedexId)"
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        //currentEvo.image = UIImage(named: "\(pokemon.pokedexId)")
        if "\(pokemon.nextEvoId)" == "\(pokemon.pokedexId + 1)" {
            nextEvo.image = UIImage(named: "\(pokemon.nextEvoId)")
            evoLbl.text = "Next Evolution: \(pokemon.nextEvoText) at level \(pokemon.nextEvoLvl)"
            nextEvo.hidden = false
            evoArrow.hidden = false
        } else {
            evoLbl.text = "Final Evolution"
        }
        for label in hiddenLabels {
            label.hidden = false
        }
        grayBar.hidden = false
        loadingIndicator.hidden = true
    }

    @IBAction func backPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }


}
