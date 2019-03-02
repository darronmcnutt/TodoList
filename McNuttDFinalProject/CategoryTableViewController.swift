//
//  CategoryTableViewController.swift
//  McNuttDFinalProject
//
//  Created by Darron on 3/2/19.
//  Copyright © 2019 DePaul University. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
   
    let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    var resultsController: NSFetchedResultsController<NSManagedObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFetchedResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        

//        do {
//            try controller.performFetch()
//        } catch {
//            fatalError("Failed to fetch entities: \(error)")
//        }
        
        self.tableView.reloadData()
        
    }
    
    func initFetchedResultsController() {

        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        // Sort by date
        let sort = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: "category", cacheName: nil)
        
        do {
            try resultsController.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        
        resultsController.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return resultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = resultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtitle", for: indexPath)
        let object = resultsController.object(at: indexPath)
        cell.textLabel?.text = object.value(forKeyPath:"title") as? String
        
        let date = object.value(forKeyPath:"date") as? Date ?? Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        cell.detailTextLabel?.text = dateFormatter.string(from: date)
        
        return cell
        
    }
 
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = resultsController.sections?[section] else {
            return nil
        }
        return sectionInfo.name
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return resultsController.sectionIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        let result = resultsController.section(forSectionIndexTitle: title, at: index)
        return result
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Retrieve task object from results controller
            let object = resultsController.object(at: indexPath)
            
            // Delete object
            resultsController.managedObjectContext.delete(object)
            
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == .delete {
            if let indexPath = indexPath {
                if tableView.numberOfRows(inSection: indexPath.section) > 1 {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    tableView.deleteSections([indexPath.section], with: .fade)
                }
                
            }
        }
       
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }


}