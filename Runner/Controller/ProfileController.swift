//
//  ViewController.swift
//  Runner
//
//  Created by Connor Olson on 7/19/23.
//

import UIKit
import CoreData

class ProfileController: UIViewController {


    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var coinsLabel: UILabel!
    
    
    @IBOutlet weak var currentRodLevelLabel: UILabel!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var toGoalLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    ///FOR NOW TO KEEP MILES ***********
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var storedVals = [StoredVals]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        loadMilesAndCoins()

        //get FISH
        loadFish()
        
        //ADD ONE HERE?
        //updateLevel()
        
        saveContext()
        
    }
    
    func loadMilesAndCoins() {
        
        do {
            storedVals = try context.fetch(StoredVals.fetchRequest())
        } catch {
            print("Error fetching data from context \(context)")
        }
        
        if storedVals.isEmpty {
            let newSV = StoredVals(context: self.context)
            newSV.coins = 50
            newSV.totalMiles = 0
            storedVals.append(newSV)
        }
        
        sharedData.sharedInstance.totalMiles = Double(storedVals[0].totalMiles)
        sharedData.sharedInstance.coins = Double(storedVals[0].coins)
    }
    
    
    @IBAction func plusCoinsPressed(_ sender: UIButton) {
        sharedData.sharedInstance.coins += 50
        storedVals[0].coins = Int16(sharedData.sharedInstance.coins)
        
        coinsLabel.text = "\(Int(sharedData.sharedInstance.coins.rounded()))"
        
        saveContext()
    }
    
    @IBAction func plusMilesPressed(_ sender: UIButton) {
        sharedData.sharedInstance.totalMiles += 10
        storedVals[0].totalMiles = sharedData.sharedInstance.totalMiles
        
        milesLabel.text = "Total Miles Run: \((sharedData.sharedInstance.totalMiles * 100).rounded() / 100)"
        updateLevel()
        
        saveContext()
    }
    
    
    @IBAction func addFishPressed(_ sender: UIButton) {
        for i in 0...37 {
            sharedData.sharedInstance.fishArray[i].amount = 1
            sharedData.sharedInstance.fishArray[i].weight = 3
            sharedData.sharedInstance.fishArray[i].length = 2
        }
        
        saveContext()
    }
    
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        sharedData.sharedInstance.coins = 50
        storedVals[0].coins = Int16(sharedData.sharedInstance.coins)
        
        sharedData.sharedInstance.totalMiles = 0
        storedVals[0].totalMiles = sharedData.sharedInstance.totalMiles
        
        coinsLabel.text = "\(Int(sharedData.sharedInstance.coins.rounded()))"
        
        milesLabel.text = "Total Miles Run: \((sharedData.sharedInstance.totalMiles * 100).rounded() / 100)"
        updateLevel()
        
        
        for i in 0...37 {
            sharedData.sharedInstance.fishArray[i].amount = 0
            sharedData.sharedInstance.fishArray[i].weight = 0
            sharedData.sharedInstance.fishArray[i].length = 0
        }
        
        saveContext()
    }
    
    
    func saveContext() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    
    }
    
    
    func loadFish() {
        let request = Fish.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            sharedData.sharedInstance.fishArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(context)")
        }
        
        if sharedData.sharedInstance.fishArray.count == 0 {
            
            //**************** COMMON ****************
            //row 1 ******
            addFishToArray("Blue Fish")
            addFishToArray("Yellow Fish")
            addFishToArray("Red Fish")
            
            //row 2 ******
            addFishToArray("Blue Pufferfish")
            addFishToArray("Yellow Pufferfish")
            addFishToArray("Red Pufferfish")
            
            //row 3 ******
            addFishToArray("Blue Marlin")
            addFishToArray("Yellow Marlin")
            addFishToArray("Red Marlin")
            
            
            //**************** UNCOMMON ****************
            //row 1 ******
            addFishToArray("Orange Tuna")
            addFishToArray("Green Tuna")
            addFishToArray("Purple Tuna")
            
            //row 2 ******
            addFishToArray("Orange Salmon")
            addFishToArray("Green Salmon")
            addFishToArray("Purple Salmon")
            
            //row 3 ******
            addFishToArray("Orange Shark")
            addFishToArray("Green Shark")
            addFishToArray("Purple Shark")
            
            
            //************** RARE ****************
            //row 1 ******
            addFishToArray("Teal Whale")
            addFishToArray("Pink Whale")
            addFishToArray("Cream Whale")
            
            //row 2 ******
            addFishToArray("Teal Turtle")
            addFishToArray("Pink Turtle")
            addFishToArray("Cream Turtle")
            
            
            //************** EPIC ****************
            //row 1 ******
            addFishToArray("Bronze Starfish")
            addFishToArray("Silver Starfish")
            addFishToArray("Gold Starfish")
            
            //row 2 ******
            addFishToArray("Bronze Sunfish")
            addFishToArray("Silver Sunfish")
            addFishToArray("Gold Sunfish")
            
            
            //************** LEGENDARY ****************
            //row 1 ******
            addFishToArray("Clownfish")
            addFishToArray("Tiger Shark")
            addFishToArray("Baracuda")
            
            
            //************** SECRET ****************
            //row 1 ******
            addFishToArray("Flounder")
            
            //row 2 ******
            addFishToArray("Old Flounder")
            addFishToArray("Young Flounder")
            addFishToArray("Confused Flounder")
            
            //row 3 ******
            addFishToArray("Angsty Flounder")
            
        }
    
    }
    
    var order = 0
    
    func addFishToArray(_ fishName: String) {
        let newFish = Fish(context: context.self)
        newFish.name = fishName
        newFish.order = Int16(order)
        order += 1
        sharedData.sharedInstance.fishArray.append(newFish)
    }
    
    
    
    ///FOR NOW TO KEEP MILES ***********
    override func viewWillAppear(_ animated: Bool) {
        
        milesLabel.text = "Total Miles Run: \((sharedData.sharedInstance.totalMiles * 100).rounded() / 100)"
        coinsLabel.text = "\(Int(sharedData.sharedInstance.coins.rounded()))"
        
        //UPDATE PROGRESS BAR/LEVEL
        updateLevel()
    }
    
    
    func updateLevel() {

        let currentLevel = getLevel(currentMiles: sharedData.sharedInstance.totalMiles)
        
        if currentLevel == 0 {
            currentRodLevelLabel.text = "Current Rod Level: None"
        } else {
            currentRodLevelLabel.text = "Current Rod Level: \(getNextLevelString(currentLevel: currentLevel - 1))"
        }
        
        sharedData.sharedInstance.currentLevel = currentLevel
        
        let nextLevelString = getNextLevelString(currentLevel: currentLevel)
        if nextLevelString == "end" {
            progressLabel.text = "At Diamond!"
        } else {
            progressLabel.text = "Progress to \(nextLevelString)"
        }
        
        let nextMilestone = getNextLevelMilestone(currentLevel: currentLevel)
        if nextMilestone == -1 {
            toGoalLabel.text = nil
            progressBar.progress = 1.0
        } else {
            toGoalLabel.text = "(\((sharedData.sharedInstance.totalMiles * 100).rounded() / 100) out of \(nextMilestone) Miles)"
            progressBar.progress = Float(sharedData.sharedInstance.totalMiles / Double(nextMilestone))
        }
        
    }
    
    func getLevel(currentMiles cm: Double) -> Int {

        if cm < 10 {
            return 0
        } else if cm < 30 {
            return 1
        } else if cm < 75 {
            return 2
        } else if cm < 125 {
            return 3
        } else if cm < 200 {
            return 4
        } else if cm < 300 {
            return 5
        } else if cm < 500 {
            return 6
        } else {
            return 7
        }
        
    }
    
    func getNextLevelMilestone(currentLevel cl: Int) -> Int {
        switch cl {
        case 0:
            return 10
        case 1:
            return 30
        case 2:
            return 75
        case 3:
            return 125
        case 4:
            return 200
        case 5:
            return 300
        case 6:
            return 500
        default:
            return -1
        }
    }
    
    func getNextLevelString(currentLevel cl: Int) -> String {
        switch cl {
        case 0:
            return "Bronze"
        case 1:
            return "Silver"
        case 2:
            return "Gold"
        case 3:
            return "Platnum"
        case 4:
            return "Ruby"
        case 5:
            return "Emerald"
        case 6:
            return "Diamond"
        default:
            return "end"
        }
        
        //REFERENCE ******
//        no rod - 0
//        bronze - 10
//        silver - 30
//        gold - 75
//        platnum - 125
//        ruby - 200
//        emerald - 300
//        diamond - 500
    }
    
    
}

