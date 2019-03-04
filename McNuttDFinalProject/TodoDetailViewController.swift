//
//  ViewController.swift
//  McNuttDFinalProject
//
//  Created by Darron on 2/25/19.
//  Copyright © 2019 DePaul University. All rights reserved.
//

import UIKit
import CoreData

class TodoDetailViewController: UIViewController {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var descriptionContent: UILabel!
    @IBOutlet weak var timeContent: UILabel!
    @IBOutlet weak var categoryContent: UILabel!
    
    var taskObject: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let task = taskObject {
            
            taskName.text = task.value(forKeyPath:"title") as? String
            descriptionContent.text = task.value(forKeyPath:"descript") as? String
            
            if let date = task.value(forKeyPath:"date") as? Date {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US")
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .short
                
                timeContent.text = dateFormatter.string(from: date)
            }

            if let category = task.value(forKeyPath:"category") as? Int {
                categoryContent.text = categories[category]
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? EditTaskViewController {
            destinationViewController.taskObject = taskObject
        }
    }
    
}

