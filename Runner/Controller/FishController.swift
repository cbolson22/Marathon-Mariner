//
//  PalsController.swift
//  Runner
//
//  Created by Connor Olson on 7/20/23.
//

import UIKit
import CoreLocation

class FishController: UIViewController {
    
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var fishLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    
    @IBOutlet weak var fishImage: UIImageView!
    
    
    @IBOutlet weak var fishermanImage: UIImageView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var storedVals = [StoredVals]()
    
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fishLabel.text = ""
        weightLabel.text = ""
        lengthLabel.text = ""
        
        loadCoins()
        
        images.append(UIImage(named: "hook1")!)
        images.append(UIImage(named: "hook2")!)
        images.append(UIImage(named: "hook3")!)
        images.append(UIImage(named: "hook4")!)
        images.append(UIImage(named: "hook5")!)
        images.append(UIImage(named: "hook6")!)
        
        //**********
        //MAKE NEW ARRAY WITH IMAGES OF FISHERMAN BOUNCING UP AND DOWN
        //DOING NOTHING AND USE THAT FOR WHEN NO CAST HAS BEEN CLICKED
        //AND CONTINUOUSLY REPEAT THAT AND THEN USE THIS IMAGE ARRAY
        //(AND SET ANIMATION REPEAT COUNT TO 1) WHEN CAST IS PRESSED
        //AND THEN GO BACK
        //**********
        
        fishermanImage.animationImages = images
        fishermanImage.animationDuration = 1
        fishermanImage.animationRepeatCount = 1
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        coinsLabel.text = "\(Int(sharedData.sharedInstance.coins.rounded()))"
        
        //print(sharedData.sharedInstance.currentLevel)
    }
    
    
    func loadCoins() {
        do {
            storedVals = try context.fetch(StoredVals.fetchRequest())
        } catch {
            print("Error fetching data from context \(context)")
        }
    }
 
    @IBAction func castButtonPressed(_ sender: UIButton) {
        if sharedData.sharedInstance.coins >= 50 && !fishermanImage.isAnimating {
            
            sharedData.sharedInstance.coins -= 50
            coinsLabel.text = "\(Int(sharedData.sharedInstance.coins.rounded()))"
            
            storedVals[0].coins = Int16(sharedData.sharedInstance.coins)
            
            
            //ANIMATING
            fishermanImage.startAnimating()
            
            
            
            
            
            //****
            
        
            
            //GETTING FISH INDEX
            
            let index = getNewFishIndex()
            
            
            //GETTING FISH WEIGHT, LENGTH
            let weight = 6.2
            let length = 6.1
            
            
            
            
            
            //IF BOOT OR ROCK IS CAUGHT
            if index == -1 {
                fishLabel.text = "BOOT"
                
                fishImage.image = nil
                weightLabel.text = nil
                lengthLabel.text = nil
                
            } else {
                //SHOW FISH IMAGE HERE (AFTER ANIMATION DONE???
                //***********
                fishImage.image = UIImage(imageLiteralResourceName: "fish_coin")
                
             
                //MAYBE TRY TO DELAY FOLLOWING TO NOT SHOW UNTIL AFTER ANIMATION IS DONE
                //***********
                fishLabel.text = sharedData.sharedInstance.fishArray[index].name
                
                //ADD OTHER ATTRIBUTES TO NEW LABELS ON SCREEN
                weightLabel.text = "Weight: \(weight)"
                lengthLabel.text = "Length: \(length)"
                
                addFish(index: index, weight: weight, length: length)
            }
        

        }
    }
    
    
    
    func getNewFishIndex() -> Int {
        
        
        let rodLevel = sharedData.sharedInstance.currentLevel
        
        var rarity: Int
        
        if rodLevel == 0 {
            rarity = getRarity(common: 150, uncommon: 100, rare: 30, epic: 15, legendary: 5, secret: 0)
        } else if rodLevel == 1 {
            rarity = getRarity(common: 225, uncommon: 150, rare: 45, epic: 23, legendary: 7, secret: 0)
        } else if rodLevel == 2 {
            rarity = getRarity(common: 250, uncommon: 200, rare: 60, epic: 30, legendary: 10, secret: 0)
        } else if rodLevel == 3 {
            rarity = getRarity(common: 250, uncommon: 250, rare: 80, epic: 40, legendary: 30, secret: 0)
        } else if rodLevel == 4 {
            rarity = getRarity(common: 250, uncommon: 250, rare: 120, epic: 90, legendary: 39, secret: 1)
        } else if rodLevel == 5 {
            rarity = getRarity(common: 250, uncommon: 250, rare: 150, epic: 125, legendary: 70, secret: 5)
        } else if rodLevel == 6 {
            rarity = getRarity(common: 250, uncommon: 250, rare: 200, epic: 150, legendary: 80, secret: 20)
        } else if rodLevel == 7 {
            rarity = getRarity(common: 250, uncommon: 250, rare: 200, epic: 150, legendary: 100, secret: 50)
        } else {
            //default does no rod
            rarity = getRarity(common: 150, uncommon: 100, rare: 30, epic: 15, legendary: 5, secret: 0)
        }
    
        
        if rarity == -1 {
            return -1
        } else {
            return getRandomFishIndexOfRarity(rarity: rarity)
        }
        
    }
    
    
    
    func getRarity(common: Int, uncommon: Int, rare: Int, epic: Int, legendary: Int, secret: Int) -> Int {
        
        let randNum = Int.random(in: 1...1000)
        
        if randNum <= common {
            return 0
        } else if randNum <= common + uncommon {
            return 1
        } else if randNum <= common + uncommon + rare {
            return 2
        } else if randNum <= common + uncommon + rare + epic {
            return 3
        } else if randNum <= common + uncommon + rare + epic + legendary {
            return 4
        } else if randNum <= common + uncommon + rare + epic + legendary + secret {
            return 5
        } else {
            //if no fish caught
            return -1
        }
        
    }
    
    
    func getRandomFishIndexOfRarity(rarity rarityIndex: Int) -> Int {
        
        if rarityIndex == 0 {
            return Int.random(in: 0...8)
        } else if rarityIndex == 1 {
            return Int.random(in: 0...8) + 9
        } else if rarityIndex == 2 {
            return Int.random(in: 0...5) + 18
        } else if rarityIndex == 3 {
            return Int.random(in: 0...5) + 24
        } else if rarityIndex == 4 {
            return Int.random(in: 0...2) + 30
        } else if rarityIndex == 5 {
            return Int.random(in: 0...4) + 33
        } else {
            //deafult no fish
            return -1
        }
    
    }
    
    
    
    
    
    func addFish(index: Int, weight: Double, length: Double) {
        //Add 1
        sharedData.sharedInstance.fishArray[index].amount += 1
        
        //WEIGHT and LENGTH
        if weight + length > sharedData.sharedInstance.fishArray[index].weight + sharedData.sharedInstance.fishArray[index].length {
            sharedData.sharedInstance.fishArray[index].weight = weight
            sharedData.sharedInstance.fishArray[index].length = length
            
            //MAKE LABEL FOR YOU HAVE NEW BIGGEST FISH!!
            //SO MAYBE WHEN AMOUNT IS NOW ONE (SO ITS NEW TYPE OF FISH) OR WHEN THIS IS ACTIVATED (NEW BIG FISH) THEN MAKE THE BADGE FOR
            //COLLECTION TAB =+ 1
        }
        
        //BADGE ICON ON COLLECTION
        
        //*********MAKE IT SO BADGE ONLY COMES UP IF AMOUNT IS NOW 1 (Since it means its a new fish type caught)
        if sharedData.sharedInstance.fishArray[index].amount == 1{
            if let tabItems = tabBarController?.tabBar.items {
                // In this case we want to modify the badge number of the third tab:
                let tabItem = tabItems[3]
                //MAKE IT PLUS ONE NOT JUST SET TO 1
                tabItem.badgeValue = "1"
                tabItem.badgeColor = UIColor.blue
            }
        }
        
        //SAVE CONTEXT TO CORE DATA *******
        //***********
        saveContext()
    }
    
    
    func saveContext() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    
    }

    
}
