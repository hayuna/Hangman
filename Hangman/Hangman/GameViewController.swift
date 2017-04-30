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
    
    //group
    var selectedGroup : String = "";
    //category
    var selectedCategory : String = "";
    //answer
    var riddleWord : String = "";
    //array with riddle
    var unknownLetter : [String]?
    //used letters
    var usedLetters: [String] = []
    //count of found letters
    var foundCorrectLetter : Int = 0
    
    
    @IBOutlet weak var used: UILabel!
    @IBOutlet weak var inputLetter: UITextField!
    @IBOutlet weak var wordLabel: UILabel!
    
    @IBAction func checkLetter(_ sender: Any) {
    
        checkMyLetter(inputLetter.text!.uppercased())
        
    }
    
    func checkMyLetter(_ letter: String){
        /*
         inputWordLength - liczba znakow wpisanych w formularzu
         riddleWordLength - liczba znakow w hasle
         letter - wpisany ciag znakow w formularzu
         checkedLetter - pierwsza litera wpisanego ciagu w formularzu
         countOfTypeLetter - ilosc wystapien podanej litery w hasle
         usedLetters - tablica uzytych znakow
         */
        var checkedLetter: String
        var countOfTypeLetter: Int = 0
        var inputWordLength: Int = 0
        var riddleWordLength: Int = 0
        
        inputWordLength = letter.characters.count
        riddleWordLength = riddleWord.characters.count
        //wymazywanie wpisanego ciagu
        inputLetter.text = ""
        
        //jesli cos wpisalem to sprawdza pierwszy znak
        if(inputWordLength >= 1){
            checkedLetter = String(letter[letter.startIndex])
        //jesli nic nie wpisalem to nic nie rob
        }else{
            return
        }
        
        //jesli wpisana litera jest w tablicy uzytych liter - nic nie rob
        if(usedLetters.contains(checkedLetter)){
            return
        //w przeciwnym wypadku dodaj wpisana litere do tablicy uzytych liter
        }else{
            usedLetters.append(checkedLetter)
        }
        
        for i in 0..<riddleWordLength{
            let currentIndex = riddleWord.characters.index(riddleWord.startIndex, offsetBy: i)
            //szukanie litery w zagadce
            if(String(riddleWord.uppercased()[currentIndex]) == checkedLetter){
                foundCorrectLetter += 1
                unknownLetter![i] = checkedLetter
                countOfTypeLetter += 1
                
            }
            
        }
        if(usedLetters.count == 6){
            loseGame()
        }
        
        print("used:  \(usedLetters)")
        let unknownLetters = unknownLetter?.reduce("", { (result, value) -> String in
            result + "\(value)"
        })
        print("unknown:  \(unknownLetters!)")
        wordLabel.text! = unknownLetters!
        print(foundCorrectLetter*100, "/", riddleWordLength)
        if(foundCorrectLetter / riddleWordLength == 1){
            winGame()
        }

    }
    
    func winGame(){
        print("You won game")
        
    }
    
    func loseGame(){
        print("You lost game")
        
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
            wordLabel.text?.append(letter+" ")
        }
    }
    
}
