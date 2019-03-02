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
    
    //TODO: Add function that extracts the category based on int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let task = taskObject {
            
            taskName.text = task.value(forKeyPath:"title") as? String
            descriptionContent.text = task.value(forKeyPath:"descript") as? String
            
            let date = task.value(forKeyPath:"date") as? Date ?? Date()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            
            timeContent.text = dateFormatter.string(from: date)
            
            let category = task.value(forKeyPath:"category") as? Int ?? 3
            categoryContent.text = getCategoryString(categoryInt: category)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? EditTaskViewController {
            destinationViewController.taskObject = taskObject
        }
    }
    
    func getCategoryString(categoryInt: Int) -> String {
        var category = ""
        
        switch categoryInt {
            case 0: category = "Work"
            case 1: category = "Home"
            case 2: category = "Social"
            case 3: category = "Other"
            default: category = "Other"
        }
        
        return category
    }

}

