//
//  SettingsViewController.swift
//  solarLogApp
//
//  Created by Holger Preu on 28.04.21.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var solarLogAddress: UITextField!
    
    var solarLogURL:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        solarLogURL = StateManager.retrieveSettings(key: StateManager.solarLogAddressKey) as? String
        
        solarLogAddress.text = solarLogURL
    }
    
    @IBAction func solarLogAddressChanged(_ sender: Any) {
        print("Address has changed!")
        solarLogURL = solarLogAddress.text
        StateManager.saveSettings(solarLogAddress: solarLogURL ?? "")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
