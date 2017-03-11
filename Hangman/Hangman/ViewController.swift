//
//  ViewController.swift
//  Hangman
//
//  Created by marek on 10.03.2017.
//  Copyright © 2017 marek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var selectedGroup : Int = 0
    var selectedCategory : Int = 0
    
    var group = ["Biologia","Japonia","Motoryzacja","Muzyka","Rozrywka","Sport", "Technika"
    ]
    var category = [
        ["Anatomia", "Zwierzęta"],
        ["Anime"],
        ["Motocykle","Samochody"],
        ["Muzyka klasyczna", "Instrumenty"],
        ["Alkohol","Impreza"],
        ["Pilka nożna","Koszykówka"],
        ["IT","Web"]
    ]
    
    
    
    
    //Number of columns in PickerView
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //Number of rows in PickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        log("pickerView1")
        if(component == 0){
            return group.count
        }else{
            return category[pickerView.selectedRow(inComponent: 0)].count
        }
    }
    
    //The data to return for the row and column
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        log("pickerView2")
        print("l:", component, pickerView.selectedRow(inComponent: 0))
        if(component == 0){
            return group[row]
        }else{
            return category[pickerView.selectedRow(inComponent: 0)][row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        log("pickerView3")
        if(component == 0){
            selectedGroup = row
        } else if(component == 1) {
            selectedCategory = row
        }
        pickerView.reloadComponent(1)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! GameViewController
        dest.selectedGroup = group[selectedGroup]
        dest.selectedCategory = category[selectedGroup][selectedCategory]
        
    }

    func log(_ a : String){
        print(a);
    }

}

