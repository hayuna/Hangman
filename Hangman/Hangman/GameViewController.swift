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
    var riddleWordLength : Int = 0
    var unknownLetter : [String]?
    var usedLetters: [String] = []
    var foundCorrectLetter : Int = 0
    var foundCorrectLetterWithoutRepeat : Int = 0
    var temp : Int = 0
    var errorLetters : Int = 0
    var time1 : Double = 0
    
    
    @IBOutlet weak var used: UILabel!
    @IBOutlet weak var inputLetter: UITextField!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var hangmanImage: UIImageView!
    
    @IBAction func checkLetter(_ sender: Any) {
    
        checkMyLetter(inputLetter.text!.uppercased())
        
    }
    
    func checkMyLetter(_ letter: String){
        /*
         checkedLetter - pierwsza litera wpisanego ciagu w formularzu
         countOfTypeLetter - ilosc wystapien podanej litery w hasle
         foundCorrectLetter - liczba znalezionych liter - razem z powtorzeniami
         foundCorrectLetterWithoutRepeat - liczba znalezionych liter - bez powtorzen
         inputWordLength - liczba znakow wpisanych w formularzu
         letter - wpisany ciag znakow w formularzu
         riddleWord - haslo
         riddleWordLength - liczba znakow w hasle
         selectedCategory - wybrana kategoria
         selectedGroup - wybrana grupa
         unknownLetter - tablica obecnie odgadnietego slowa
         usedLetters - tablica uzytych znakow
         */
        var checkedLetter: String
        var countOfTypeLetter: Int = 0
        var inputWordLength: Int = 0
        
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
            used.text?.append(checkedLetter+" ")
        }
        
        for i in 0..<riddleWordLength{
            let currentIndex = riddleWord.characters.index(riddleWord.startIndex, offsetBy: i)
            //szukanie litery w zagadce
            if(String(riddleWord.uppercased()[currentIndex]) == checkedLetter){
                foundCorrectLetter += 1
                unknownLetter![i] = checkedLetter
                countOfTypeLetter += 1
                temp = 1
                
            }
            
            
        }
        
        foundCorrectLetterWithoutRepeat += temp
        
        print("temp: \(temp) foundCorrectLetterWithoutRepeat: \(foundCorrectLetterWithoutRepeat)")
        
        
        errorLetters = usedLetters.count-foundCorrectLetterWithoutRepeat
        print("error: ", errorLetters)
        if(temp == 0){
            print("nie trafiles")
            changeImage()
        }
        temp = 0
        if(errorLetters == 9){
            loseGame()
        }
        
        print("used:  \(usedLetters)")
        let unknownLetters = unknownLetter?.reduce("", { (result, value) -> String in
            result + "\(value)"
        })
        print("unknown:  \(unknownLetters!)")
        wordLabel.text! = unknownLetters!
        print(foundCorrectLetter*100/riddleWordLength, "%")
        if(foundCorrectLetter / riddleWordLength == 1){
            winGame()
        }

    }
    
    func winGame(){
        //TODO Alert
        let time2 = NSDate().timeIntervalSince1970 - time1
        let gameTime = floor(time2)
        let score = Int(1000/(floor(time2)))+10*riddleWordLength
        let message = "czas: \(gameTime)\nliczba punktow: \(score)"
        print(message)
        
        showAlert(text: "Zwyciestwo", message: message)
        
        
        
        
        let highScore = score
        
        let defaults = UserDefaults.standard
        var arrayHighscore: [Int] = (defaults.array(forKey: "highscore") as? [Int]) ?? [Int]()
        arrayHighscore.append(highScore)
        arrayHighscore.sort { $0 > $1 }
        let maxIndex = min(arrayHighscore.count, 5)
        let tempArray = [Int](arrayHighscore[0..<maxIndex])
        defaults.set(tempArray, forKey: "highscore")
        defaults.synchronize()
        
        
        
        print("You won game")
        
    }
    
    func loseGame(){
        //TODO Alert
        showAlert(text : "Przegrana", message : "Nie udalo ci sie wygrac")
        print("You lost game")
        
    }
    
    func showAlert(text : String, message : String){
        let alertController = UIAlertController(title: text, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let go = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:
            UIAlertAction!) in
            print("clicked")
            self.performSegue(withIdentifier: "go_to_menu", sender: true)
        })
        alertController.addAction(go)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func changeImage(){
        let stringUrl = String(format: "http://zagraj-w-wisielca.pl/img/s%d.gif", errorLetters)
        if let url = URL(string: stringUrl) {
            if let data = NSData(contentsOf: url) {
                hangmanImage.image = UIImage(data: data as Data)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        time1 = NSDate().timeIntervalSince1970;
        getWord()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getWord(){
        let parameters = [
            "group": self.selectedGroup,
            "category": self.selectedCategory
        ]
        Alamofire
            .request("http://hayuna.pl/hangman/index.php", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseString {
                (response) in self.riddleWord = response.result.value!.uppercased()
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
