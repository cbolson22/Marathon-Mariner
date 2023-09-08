//
//  CollectionFishViewController.swift
//  Runner
//
//  Created by Connor Olson on 8/6/23.
//

import Foundation

import UIKit

class CollectionFishViewController: UIViewController {
    
    var fishIndex = 0
    
    @IBOutlet weak var fishLabel: UILabel!
    @IBOutlet weak var numberCaughtLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fishLabel.text = sharedData.sharedInstance.fishArray[fishIndex].name!
        numberCaughtLabel.text = "Number Caught: \(sharedData.sharedInstance.fishArray[fishIndex].amount)"
        weightLabel.text = "Weight: \(sharedData.sharedInstance.fishArray[fishIndex].weight)"
        lengthLabel.text = "Length: \(sharedData.sharedInstance.fishArray[fishIndex].length)"
        
        //ALSO SHOW THE RARITY OF FISH WITH IF ELSE STATEMENT FOR
        //INDEX IN ARRAY AND THEN LABEL W RARITY AND COLOR BACKGROUND
        //FOR RARITY
    }
}
