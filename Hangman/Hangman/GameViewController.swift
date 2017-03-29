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
    
    var selectedGroup : String = "";
    var selectedCategory : String = "";
    var riddleWord : String = "";
    var unknownLetter : [String]?;
    
    
    
    @IBOutlet weak var riddle: UILabel!
    @IBOutlet weak var used: UILabel!
    @IBOutlet weak var inputLetter: UITextField!
    
    @IBOutlet weak var wordLabel: UILabel!
    
    @IBAction func checkLetter(_ sender: Any) {
        
    }
    
    
    
    override func viewDidLoad() {
        print(selectedGroup, selectedCategory)
        getWord()
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getWord(){
        let parameters = [
            "group": self.selectedGroup,
            "category": self.selectedCategory
        ]
        Alamofire.request("http://hayuna.pl/hangman/index.php", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseString { (response) in
            self.riddleWord = response.result.value!.uppercased()
            print(self.riddleWord)
            self.startUnknownLetters()
            
        }
    }

    func startUnknownLetters(){
        unknownLetter = [String](repeating: "_", count: riddleWord.characters.count);
        for letter in unknownLetter! {
            riddle.text?.append(letter+" ")
        }
        
        //
    }
    
}
