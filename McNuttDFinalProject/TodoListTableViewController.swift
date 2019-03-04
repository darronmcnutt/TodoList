//
//  TodoListTableViewController.swift
//  McNuttDFinalProject
//
//  Created by Darron on 2/25/19.
//  Copyright © 2019 DePaul University. All rights reserved.
//

import UIKit
import CoreData

// Global variables
let categories = ["Work", "Home", "Social", "Other"]
let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext

class TodoListTableViewController: UITableViewController {

    var tasks: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        // Sort tasks by date
        let sort = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            tasks = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Fetching from Core Data failed. Error details: \(error), \(error.userInfo)")
        }
        
        self.tableView.reloadData()
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
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? TodoDetailViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                detailViewController.taskObject = tasks[indexPath.row]
            }
        }
    }
    
}


