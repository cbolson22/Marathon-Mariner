//
//  CollectionController.swift
//  Runner
//
//  Created by Connor Olson on 8/5/23.
//

import Foundation
import UIKit

class CollectionController: UIViewController {    
    
    @IBOutlet var fish: [UIImageView]!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var pageNumberLabel: UILabel!
    
    var page = 1
    
    var indexForSegue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let buttonIndex = Int((sender.titleLabel?.text)!)!
        var fishIndex: Int
        if page == 1 || page == 2 {
            fishIndex = buttonIndex + ((page - 1) * 9)
            
        } else if page == 3 || page == 4 {
            if buttonIndex <= 5 {
                fishIndex = buttonIndex + 18 + ((page - 3) * 6)
            } else {
                fishIndex = -1
            }

        } else if page == 5 {
            if buttonIndex >= 3 && buttonIndex <= 5 {
                fishIndex = buttonIndex + 27
            } else {
                fishIndex = -1
            }
            
        } else {
            if buttonIndex == 1 {
                fishIndex = 33
            } else if buttonIndex >= 3 && buttonIndex <= 5 {
                fishIndex = 31 + buttonIndex
            } else if buttonIndex == 7 {
                fishIndex = 37
            } else {
                fishIndex = -1
            }
            
        }
        
        if fishIndex != -1 {
            if sharedData.sharedInstance.fishArray[fishIndex].amount > 0 {
                indexForSegue = fishIndex
                performSegue(withIdentifier: "goToCollectionFishView", sender: self)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToCollectionFishView" {
            let destinationVC = segue.destination as! CollectionFishViewController
            
            destinationVC.fishIndex = indexForSegue

        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let tabItems = tabBarController?.tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[3]
            tabItem.badgeValue = nil
        }
        page = 1
        refreshPage()
    }
    
    
    @IBAction func leftArrowPressed(_ sender: UIButton) {
        if page > 1 {
            page -= 1
            refreshPage()
        }
    }
    
    @IBAction func rightArrowPressed(_ sender: UIButton) {
        //**********
        //CHANGE TO RIGHT NUMBER OF PAGES
        //**********
        if page < 6 {
            page += 1
            refreshPage()
        }
    }
    
    func refreshPage() {
        updatePageLabel()
        
        if page == 1 || page == 2 {
            for i in 0...8 {
                showImage(fishIndex: i + ((page - 1) * 9), imageIndex: i)
                updateLabel(fishIndex: i + ((page - 1) * 9), labelIndex: i)
            }
        } else if page == 3 || page == 4 {
            for i in 0...5 {
                showImage(fishIndex: i + 18 + ((page - 3) * 6), imageIndex: i)
                updateLabel(fishIndex: i + 18 + ((page - 3) * 6), labelIndex: i)
            }
            for i in 6...8 {
                clearImageAndLabel(index: i)
            }
        } else if page == 5 {
            for i in 0...2 {
                clearImageAndLabel(index: i)
            }
            for i in 3...5 {
                showImage(fishIndex: i + 27, imageIndex: i)
                updateLabel(fishIndex: i + 27, labelIndex: i)
            }
            for i in 6...8 {
                clearImageAndLabel(index: i)
            }
        } else {
            //top row
            clearImageAndLabel(index: 0)
            
            showImage(fishIndex: 33, imageIndex: 1)
            updateLabel(fishIndex: 33, labelIndex: 1)
            
            clearImageAndLabel(index: 2)
            
            //middle row
            for i in 3...5 {
                showImage(fishIndex: i + 31, imageIndex: i)
                updateLabel(fishIndex: i + 31, labelIndex: i)
            }
            
            //top row
            clearImageAndLabel(index: 6)
            
            showImage(fishIndex: 37, imageIndex: 7)
            updateLabel(fishIndex: 37, labelIndex: 7)
            
            clearImageAndLabel(index: 8)
            
        }
        
    }
    
    
    func updatePageLabel() {

        switch page {
        case 1:
            pageNumberLabel.text = "Common"
            //pageNumberLabel.backgroundColor = UIColor.gray
        case 2:
            pageNumberLabel.text = "Uncommon"
            //pageNumberLabel.backgroundColor = UIColor.green
        case 3:
            pageNumberLabel.text = "Rare"
            //pageNumberLabel.backgroundColor = UIColor.blue
        case 4:
            pageNumberLabel.text = "Epic"
            //pageNumberLabel.backgroundColor = UIColor.purple
        case 5:
            pageNumberLabel.text = "Legendary"
            //pageNumberLabel.backgroundColor = UIColor.yellow
        case 6:
            pageNumberLabel.text = "Secret"
            //pageNumberLabel.backgroundColor = UIColor.systemMint
        default:
            pageNumberLabel.text = "Common"
            //pageNumberLabel.backgroundColor = UIColor.gray
        }

    }
    
    
    func showImage(fishIndex: Int, imageIndex: Int) {
        if sharedData.sharedInstance.fishArray[fishIndex].amount > 0 {
            fish[imageIndex].image = UIImage(imageLiteralResourceName: "fish_coin")
        } else {
            fish[imageIndex].image = UIImage(imageLiteralResourceName: "unknown_fish")
        }
    }
    
    
    func updateLabel(fishIndex: Int, labelIndex: Int) {
        if sharedData.sharedInstance.fishArray[fishIndex].amount > 0 {
            labels[labelIndex].text = sharedData.sharedInstance.fishArray[fishIndex].name
            if fishIndex == 4 || page == 6 && fishIndex != 36 {
                labels[labelIndex].font = UIFont(name: "Helvetica Neue", size: 15)
            } else if fishIndex == 36 {
                labels[labelIndex].font = UIFont(name: "Helvetica Neue", size: 13)
            } else {
                labels[labelIndex].font = UIFont(name: "Helvetica Neue", size: 17)
            }
        } else {
            labels[labelIndex].text = "???"
            labels[labelIndex].font = UIFont(name: "Helvetica Neue", size: 17)
        }
    }
    
    func clearImageAndLabel(index: Int) {
        fish[index].image = nil
        labels[index].text = nil
    }
    
    
}
