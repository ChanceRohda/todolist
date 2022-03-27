//
//  ViewController.swift
//  ToDoList
//
//  Created by Chance Rohda on 3/25/22.
//

import UIKit

struct ToDoItem {
    var title: String
    var description: String
    var isComplete: Bool = false
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var toDoItems: [ToDoItem] = [ToDoItem(title: "Walk the dog", description: "Walk the dog at 7"), ToDoItem(title: "Go to school", description: "Go to school at 8")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To Do List"
        tableView.dataSource = self
        tableView.delegate = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let toDoItem = toDoItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        cell.textLabel?.text = toDoItem.title
        cell.detailTextLabel?.text = toDoItem.description
        if toDoItem.isComplete {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoItems[indexPath.row].isComplete = !toDoItems[indexPath.row].isComplete
        tableView.reloadData()
        //ternary operator
        //toDoItems[indexPath.row].isComplete = toDoItems[indexPath.row].isComplete ? false : true
        
        /*if toDoItems[indexPath.row].isComplete {
            toDoItems[indexPath.row].isComplete = false
        } else {
            toDoItems[indexPath.row].isComplete = true
        }
        */
    }
    
    @IBAction func addButtonDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Add Task", message: "Add a new task", preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "Add Title"
        }
        alert.addTextField { textfield in
            textfield.placeholder = "Add Description"
        }
        let addTaskAction = UIAlertAction(title: "Add Task", style: .default) { action in
            if let textFields = alert.textFields {
                //nil coalescing
                let titleText = textFields[0].text ?? "No Title"
                let descriptionText = textFields[1].text ?? "No Description"
                let newToDoItem = ToDoItem(title: titleText, description: descriptionText)
                self.toDoItems.append(newToDoItem)
                self.tableView.reloadData()
                alert.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(addTaskAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
}

