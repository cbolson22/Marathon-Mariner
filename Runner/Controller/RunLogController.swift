//
//  RunLogController.swift
//  Runner
//
//  Created by Connor Olson on 7/20/23.
//

import UIKit
import CoreData
import SwipeCellKit


class RunLogController: UITableViewController {
    
    var runArray = [Run]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var storedVals = [StoredVals]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var profileTab = self.tabBarController?.viewControllers![0] as! ProfileController
//        profileTab.arrayPassed = runArray
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadMilesAndCoins()
        
        loadRuns()
        
        tableView.rowHeight = 60.0
        
    }
    
    func loadMilesAndCoins() {
        do {
            storedVals = try context.fetch(StoredVals.fetchRequest())
        } catch {
            print("Error fetching data from context \(context)")
        }
    }

    
    
    // MARK: TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RunLogItemCell", for: indexPath) as! SwipeTableViewCell
    
        cell.textLabel?.text = runArray[indexPath.row].title
        
        cell.delegate = self

        return cell
        
    }
    
    
    
    // MARK: TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToRunSession", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToRunSession" {
            let destinationVC = segue.destination as! RunSessionController

            if let indexPath = tableView.indexPathForSelectedRow {
        
     //***************************************************************************
                destinationVC.selectedRun = runArray[indexPath.row]
                
                destinationVC.date = runArray[indexPath.row].date ?? Date()
                
                destinationVC.hours = runArray[indexPath.row].hours
                destinationVC.minutes = runArray[indexPath.row].minutes
                destinationVC.seconds = runArray[indexPath.row].seconds
                destinationVC.timeString = runArray[indexPath.row].timeString!
                
                destinationVC.distance = runArray[indexPath.row].distance
            }
        }
        
        
    }
    
    
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewRunSessionController {
            let newRun = Run(context: self.context)
            newRun.title = sourceViewController.name
            
            newRun.distance = (sourceViewController.miles * 100).rounded() / 100
            //newRun.distance = sourceViewController.miles
            //print(newRun.distance)
            
            newRun.hours = sourceViewController.hours
            newRun.minutes = sourceViewController.minutes
            newRun.seconds = sourceViewController.seconds
            newRun.timeString = sourceViewController.timeString
            
            newRun.date = sourceViewController.date
            
           
            var index = 0
            for coord in sourceViewController.coordinates {
                let newCoordinate = Coordinate(context: self.context)
                newCoordinate.latitude = coord.latitude
                newCoordinate.longitude = coord.longitude
                newCoordinate.order = Int16(index)
                newCoordinate.parentRun = newRun
                
                index += 1
                
            }
            
            sharedData.sharedInstance.totalMiles += newRun.distance
            storedVals[0].totalMiles = sharedData.sharedInstance.totalMiles
            
            //COINSSS*******
            sharedData.sharedInstance.coins += newRun.distance * 100
            storedVals[0].coins = Int16(sharedData.sharedInstance.coins)
            
            self.runArray.append(newRun)
            self.saveRuns()
        }
        
    }

    
    
    
    // MARK: Model Manipulation Methods
    
    func saveRuns() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        
        self.tableView.reloadData()
        
    }
    
    
    func loadRuns(with request: NSFetchRequest<Run> = Run.fetchRequest()) {
    
        do {
            runArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(context)")
        }
        
        tableView.reloadData()
    }
    
}

    
// MARK: Search Bar Methods

extension RunLogController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Run> = Run.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadRuns(with: request)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadRuns()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
        
    }
}



// MARK:  Swipe Cell Delegate Methods


extension RunLogController: SwipeTableViewCellDelegate  {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            let objects = self.runArray[indexPath.row].coordinates!.allObjects
            objects.forEach { element in
                self.context.delete(element as! NSManagedObject)
            }
            
            
            //delete run
            self.context.delete(self.runArray[indexPath.row])
            self.runArray.remove(at: indexPath.row)
            
            
            self.saveRuns()
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
}
