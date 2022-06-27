//
//  Preference.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi on 27/06/22.
//

import Foundation

struct Preference{
    let _defaults = UserDefaults()
    
    var requestToken: String?{
        set{
            _defaults.set(newValue, forKey: "requestToken")
        }get{
            _defaults.string(forKey: "requestToken")
        }
    }
    
    var sessionID: String?{
        set{
            _defaults.set(newValue, forKey: "sessionID")
        }get{
            _defaults.string(forKey: "sessionID")
        }
    }
}
