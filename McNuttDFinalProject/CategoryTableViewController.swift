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
    
    var tasks: [[NSManagedObject]] = Array(repeating: [], count: categories.count)
    var taskCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTasks()
        self.tableView.reloadData()
    }
    
    func fetchTasks() {
        // Clear the tasks array
        tasks = Array(repeating: [], count: categories.count)
        
        var uncategorizedTasks: [NSManagedObject] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        // Sort tasks by date
        let sort = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        // Perform fetch request
        do {
            uncategorizedTasks = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Fetching from Core Data failed. Error details: \(error), \(error.userInfo)")
        }
        
        taskCount = uncategorizedTasks.count
        
        // Categorize tasks
        for task in uncategorizedTasks {
            if let category = task.value(forKeyPath:"category") as? Int {
                tasks[category].append(task)
            }
        }
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
        let object = tasks[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = object.value(forKeyPath:"title") as? String
        
//        if let date = object.value(forKeyPath:"date") as? Date {
//            let dateFormatter = DateFormatter()
//            dateFormatter.locale = Locale(identifier: "en_US")
//            dateFormatter.dateStyle = .medium
//            dateFormatter.timeStyle = .short
//            
//            cell.detailTextLabel?.text = dateFormatter.string(from: date)
//        }
        
        return cell

    }
 
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["W", "H", "S", "O"]
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }

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
            
            // Update tasks array and table view
            tasks[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? TodoDetailViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                detailViewController.taskObject = tasks[indexPath.section][indexPath.row]
                detailViewController.taskCount = taskCount
            }
        }
        
        if let editTaskViewController = segue.destination as? EditTaskViewController {
            editTaskViewController.taskCount = tasks.count
        }
    }
    


}
