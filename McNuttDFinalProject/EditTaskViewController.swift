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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func editEnded(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
    @IBAction func saveTask(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
        
        // Modifies the taskObject or creates a new object if nil
        let task = taskObject ?? NSManagedObject(entity: entity, insertInto: managedContext)
        
        task.setValue(titleField.text ?? "", forKeyPath: "title")
        task.setValue(descriptionField.text ?? "", forKeyPath: "descript")
        task.setValue(categorySelector.selectedSegmentIndex, forKeyPath: "category")
        task.setValue(datePicker.date, forKeyPath: "date")
        
        do {
            try managedContext.save()
            taskObject = task
        } catch let error as NSError {
            print("Save to Core Data failed. Error details: \(error), \(error.userInfo)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let task = taskObject {
            titleField.text = task.value(forKeyPath:"title") as? String
            descriptionField.text = task.value(forKeyPath:"descript") as? String
            datePicker.date = task.value(forKeyPath:"date") as? Date ?? Date()
            categorySelector.selectedSegmentIndex = (task.value(forKeyPath:"category") as? Int) ?? 3
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
