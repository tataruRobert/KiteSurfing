//
//  ConfigureViewController.swift
//  KiteSurfing
//
//  Created by Tataru Robert on 03/04/2019.
//  Copyright © 2019 Tataru Robert. All rights reserved.
//

import UIKit

class ConfigureViewController: UIViewController {
    
    var Countries : [String] = ["None"]
    
    @IBOutlet weak var windInput: UITextField!
    @IBOutlet weak var countryPicker: UIPickerView!
    
    var windProb : String = ""
    var countryPicked : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.windInput.delegate = self
        Country.getCountries { (results : [Country]) in
           
            for result in results {
                self.Countries.append(result.country)
            }
            
            DispatchQueue.main.async {
               self.updateUI()
            }
           
        }
        
    }
    
    func updateUI() {
        self.windInput.delegate = self
        self.countryPicker.delegate = self
        self.countryPicker.delegate = self
        self.countryPicker.dataSource = self
        self.windInput.keyboardType = UIKeyboardType.numberPad
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let input = windInput.text {
            windProb = input
        }
    }
    
        @IBAction func Cancel(_ sender: Any) {
        
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to discard modified filter information?", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (_)in
                self.performSegue(withIdentifier: "undwindToList", sender: self)
        })
        alert.addAction(OKAction)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}


extension ConfigureViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate  {
        func numberOfComponents(in countryPicker: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ countryPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return Countries.count
        }
    
        func pickerView(_ countryPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return Countries[row]
        }
        
        func pickerView(_ countryPicker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            windInput.resignFirstResponder()
            countryPicked = Countries[row]
        }
    
        func textFieldShouldReturn(_ windInput: UITextField) -> Bool {
            windInput.resignFirstResponder()
            return true
        }
    
        func textFieldDidEndEditing(_ windInput: UITextField) {
            windProb = String (windInput.text!)
            
        }
    
    }

