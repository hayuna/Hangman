import UIKit

class GameViewControllerPlayers: UIViewController {
    var riddleWord : String = "";
    var riddleWordLength : Int = 0
    var unknownLetter : [String]?
    var usedLetters: [String] = []
    var foundCorrectLetter : Int = 0
    var foundCorrectLetterWithoutRepeat : Int = 0
    var temp : Int = 0
    var errorLetters : Int = 0
    var time1 : Double = 0
    
    @IBOutlet weak var hangmanImage: UIImageView!
    @IBOutlet weak var used: UILabel!
    @IBOutlet weak var inputLetter: UITextField!
    @IBOutlet weak var wordLabel: UILabel!
    @IBAction func checkLetter(_ sender: Any) {
        checkMyLetter(inputLetter.text!.uppercased())
    }
    
    
    func checkMyLetter(_ letter: String){
        var checkedLetter: String
        var countOfTypeLetter: Int = 0
        var inputWordLength: Int = 0
        inputWordLength = letter.characters.count
        riddleWordLength = riddleWord.characters.count
        inputLetter.text = ""
        if(inputWordLength >= 1){
            checkedLetter = String(letter[letter.startIndex])
        }else{
            return
        }
        if(usedLetters.contains(checkedLetter)){
            return
        }else{
            usedLetters.append(checkedLetter)
            used.text?.append(checkedLetter+" ")
        }
        for i in 0..<riddleWordLength{
            let currentIndex = riddleWord.characters.index(riddleWord.startIndex, offsetBy: i)
            if(String(riddleWord.uppercased()[currentIndex]) == checkedLetter){
                foundCorrectLetter += 1
                unknownLetter![i] = checkedLetter
                countOfTypeLetter += 1
                temp = 1
            }
        }
        foundCorrectLetterWithoutRepeat += temp
        errorLetters = usedLetters.count-foundCorrectLetterWithoutRepeat
        if(temp == 0){
            changeImage()
        }
        temp = 0
        if(errorLetters == 9){
            loseGame()
        }
        
        let unknownLetters = unknownLetter?.reduce("", { (result, value) -> String in
            result + "\(value)"
        })
        wordLabel.text! = unknownLetters!
        print(foundCorrectLetter*100/riddleWordLength, "%")
        if(foundCorrectLetter / riddleWordLength == 1){
            winGame()
        }
    }
    
    func winGame(){
        let time2 = NSDate().timeIntervalSince1970 - time1
        let gameTime = floor(time2)
        let score = Int(1000/(floor(time2)))+10*riddleWordLength
        let message = "czas: \(gameTime)\nliczba punktow: \(score)"
        showAlert(text: "Zwyciestwo", message: message)
    }
    
    func loseGame(){
        showAlert(text : "Przegrana", message : "Nie udalo ci sie wygrac")
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
        //riddleWord = self.riddleWord
        print(riddleWord)
        startUnknownLetters()
    }
    
    func startUnknownLetters(){
        unknownLetter = [String](repeating: "_", count: riddleWord.characters.count);
        for letter in unknownLetter! {
            wordLabel.text?.append(letter+" ")
        }
    }


}
