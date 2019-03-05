//
//  EditTaskViewController.swift
//  McNuttDFinalProject
//
//  Created by Darron on 3/1/19.
//  Copyright © 2019 DePaul University. All rights reserved.
//

import UIKit
import CoreData

class EditTaskViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var categorySelector: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var taskObject: NSManagedObject?
    var taskCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func editEnded(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func saveTask(_ sender: UIButton) {
        
        // Display alert if title or description fields blank
        if titleField.text == "" || descriptionField.text == "" {
            let alertController = UIAlertController(title: "Invalid Input", message: "Title and description fields are required", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
        
        let displayPriority = (taskObject?.value(forKeyPath:"displayPriority") as? Int) ?? taskCount ?? 0
        
        // Modifies the taskObject or creates a new object if nil
        let task = taskObject ?? NSManagedObject(entity: entity, insertInto: managedContext)
        
        task.setValue(titleField.text!, forKeyPath: "title")
        task.setValue(descriptionField.text!, forKeyPath: "descript")
        task.setValue(categorySelector.selectedSegmentIndex, forKeyPath: "category")
        task.setValue(datePicker.date, forKeyPath: "date")
        task.setValue(displayPriority, forKeyPath: "displayPriority")
        
        do {
            // Save to Core Data
            try managedContext.save()
            
            taskObject = task
            
            // Display success message
            let alertController = UIAlertController(title: "Success", message: "Your changes have been saved", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
        } catch let error as NSError {
            print("Save to Core Data failed. Error details: \(error), \(error.userInfo)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let task = taskObject {
            titleField.text = task.value(forKeyPath:"title") as? String
            descriptionField.text = task.value(forKeyPath:"descript") as? String
            
            if let date = task.value(forKeyPath:"date") as? Date {
                datePicker.date = date
            }
            
            if let category = task.value(forKeyPath:"category") as? Int {
                categorySelector.selectedSegmentIndex = category
            }
        }
    }
}
