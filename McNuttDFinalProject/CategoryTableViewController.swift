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
    
    var tasks: [[NSManagedObject]] = Array(repeating: [], count: categories.count)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTasks()
        self.tableView.reloadData()
    }
    
    func fetchTasks() {
        var unclassifiedTasks: [NSManagedObject] = []
        tasks = Array(repeating: [], count: categories.count)
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        // Sort by date
        let sort = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            unclassifiedTasks = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Fetching from Core Data failed. Error details: \(error), \(error.userInfo)")
        }
        
        for task in unclassifiedTasks {
            let category = (task.value(forKeyPath:"category") as? Int) ?? 3
            tasks[category].append(task)
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtitle", for: indexPath)
        let object = tasks[indexPath.section][indexPath.row]
        
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
        return categories[section]
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return categories
    }
    
//    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        return categories.firstIndex(of: title)
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Retrieve task object from array
            let task = tasks[indexPath.section][indexPath.row]
            
            // Delete task object
            managedContext.delete(task)
            
            // Save changes to Core Data
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Save to Core Data failed. Error details: \(error), \(error.userInfo)")
            }
            
            tasks[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? TodoDetailViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                detailViewController.taskObject = tasks[indexPath.section][indexPath.row]
            }
        }
    }
    


}
