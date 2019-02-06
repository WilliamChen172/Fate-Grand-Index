//
//  PokemonDetailVC.swift
//  Fate Grand Index
//
//  Created by William Chen on 2018/5/27.
//  Copyright © 2018 William Chen. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var indexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentAvatarImg: UIImageView!
    @IBOutlet weak var prevAvatarImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    
    var pokemon: Pokemon!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name
        avatarImg.image = UIImage(named: "\(pokemon.pokedexId)")
        
        pokemon.downloadPokemonDetails {
            self.updateUI()
        }
        
        pokemon.downloadPokemonSpeciesDetails {
            self.updateSpecUI()
        }
    }

    func updateUI() {
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        indexLbl.text = "\(pokemon.pokedexId)"
        weightLbl.text = pokemon.weight
        attackLbl.text = pokemon.attack
        currentAvatarImg.image = UIImage(named: "\(pokemon.pokedexId)")
    }
    
    func updateSpecUI() {
        if pokemon.preEvolId == 0 {
            prevAvatarImg.removeFromSuperview()
            evoLbl.text = "Base Form"
        } else {
            prevAvatarImg.image = UIImage(named: "\(pokemon.preEvolId)")
            evoLbl.text = "Evolved From \(pokemon.preEvol.capitalized)"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}
