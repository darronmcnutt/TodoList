//
//  PriorityTableViewController.swift
//  McNuttDFinalProject
//
//  Created by Darron on 3/4/19.
//  Copyright © 2019 DePaul University. All rights reserved.
//

import UIKit
import CoreData

class PriorityTableViewController: UITableViewController {
    
    var tasks: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        // Sort tasks by priority
        let sort = NSSortDescriptor(key: "displayPriority", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            tasks = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Fetching from Core Data failed. Error details: \(error), \(error.userInfo)")
        }
        
        self.tableView.reloadData()
    }
    
    
    @IBAction func toggleEdit(_ sender: UIBarButtonItem) {
        isEditing = !isEditing
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
        
        cell.textLabel?.text = task.value(forKeyPath:"title") as? String
        
        if let date = task.value(forKeyPath:"date") as? Date {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Retrieve task object from array
            let task = tasks[indexPath.row]
            
            // Delete task object
            managedContext.delete(task)
            
            // Save changes to Core Data
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Save to Core Data failed. Error details: \(error), \(error.userInfo)")
            }
            
            // Remove task from array and update table view
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateDisplayPriority()
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let task = tasks[sourceIndexPath.row]
        
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(task, at: destinationIndexPath.row)
        
        updateDisplayPriority()
        
    }
    
    func updateDisplayPriority() {
        for (i, task) in tasks.enumerated() {
            task.setValue(i, forKey: "displayPriority")
        }
        
        // Save changes to Core Data
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Save to Core Data failed. Error details: \(error), \(error.userInfo)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? TodoDetailViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                detailViewController.taskObject = tasks[indexPath.row]
                detailViewController.taskCount = tasks.count 
            }
        }
        
        if let editTaskViewController = segue.destination as? EditTaskViewController {
            editTaskViewController.taskCount = tasks.count
        }
    }
    
}
