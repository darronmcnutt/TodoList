//
//  TodoListTableViewController.swift
//  McNuttDFinalProject
//
//  Created by Darron on 2/25/19.
//  Copyright © 2019 DePaul University. All rights reserved.
//

import UIKit
import CoreData

class TodoListTableViewController: UITableViewController {

    var tasks: [NSManagedObject] = []
    let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        do {
            tasks = try managedContext?.fetch(fetchRequest) ?? []
        } catch let error as NSError {
            print("Fetching from Core Data failed. Error details: \(error), \(error.userInfo)")
        }
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

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
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Retrieve task object from array
            let task = tasks[indexPath.row]
            
            // Delete task object
            managedContext?.delete(task)
            
            // Save changes to Core Data
            do {
                try managedContext?.save()
            } catch let error as NSError {
                print("Save to Core Data failed. Error details: \(error), \(error.userInfo)")
            }
            
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? TodoDetailViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                detailViewController.taskObject = tasks[indexPath.row]
        }
    }


    }
    
}
