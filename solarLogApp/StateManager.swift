//
//  StateManager.swift
//  solarLogApp
//
//  Created by Holger Preu on 28.04.21.
//

import Foundation

class StateManager {
    
    static var solarLogAddressKey = "SolarLogAddress"
    
    static func saveSettings(solarLogAddress:String) {
        
        // Get a reference to the user defaults
        let defaults = UserDefaults.standard
        
        // Save the settings
        defaults.set(solarLogAddress, forKey: solarLogAddressKey)
    }
    
    static func retrieveSettings(key:String) -> Any? {
        
        // Get a reference to the user defaults
        let defaults = UserDefaults.standard
        
        return defaults.value(forKey: key)
    }
}
