//
//  sharedData.swift
//  Runner
//
//  Created by Connor Olson on 8/5/23.
//

import Foundation
import UIKit

class sharedData {
    
    static let sharedInstance = sharedData()
    
    //**********
    //get these from defaults!!
    //**********
    var totalMiles = 0.00
    var coins = 0.00
    
    var currentLevel = 0
    
    var fishArray = [Fish]()
    
}
