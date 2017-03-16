//
//  GameViewController.swift
//  Hangman
//
//  Created by marek on 11.03.2017.
//  Copyright © 2017 marek. All rights reserved.
//

import UIKit
import Alamofire

class GameViewController: UIViewController {

    var selectedGroup : String = ""
    
    
    
    @IBOutlet weak var inputLetter: UITextField!
    @IBOutlet weak var usedLetters: UILabel!
    @IBAction func checkLetter(_ sender: Any) {
    }
    
    
    var selectedCategory : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
