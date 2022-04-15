//
//  ViewController.swift
//  ToDoList
//
//  Created by Chance Rohda on 3/25/22.
//

import UIKit
import Firebase


/*
 root
    tasks
        id1
            title: Actual Title
            description: Actual Description
        id2
        1d3
    users
        id1
            name
            age
        id2
 */
struct ToDoItem {
    var id: String
    var title: String
    var description: String
    var isComplete: Bool = false
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var toDoItems: [ToDoItem] = [ToDoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("The view has loaded!!!")
        title = "To Do List"
        tableView.dataSource = self
        tableView.delegate = self
        getTasks()
    }
    
    func getTasks() {
        let ref = Database.database().reference()
        let tasksRef = ref.child("tasks")
        tasksRef.observeSingleEvent(of: .value) { snapshot in
            for item in snapshot.children {
                guard let data = item as? DataSnapshot else {
                    print("no value")
                    continue
                }
                let key = data.key
                guard let value = data.value as? [String: Any] else {
                    print("no value")
                    continue
                }
                guard let title = value["title"] as? String else {
                    continue
                }
                guard let description = value["description"] as? String else {
                    continue
                }
                let isComplete = value["isComplete"] as? Bool ?? false
                let toDoItem = ToDoItem(id: key, title: title, description: description, isComplete: isComplete)
                self.toDoItems.append(toDoItem)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
        let task = toDoItems[indexPath.row]
        let taskKey = toDoItems[indexPath.row].id
        let databaseRef = Database.database().reference()
        let tasksRef = databaseRef.child("tasks")
        let taskValue: [String: Any] = ["isComplete": task.isComplete, "title": task.title, "description": task.description]
        tasksRef.updateChildValues([taskKey: taskValue])
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let taskKey = toDoItems[indexPath.row].id
            toDoItems.remove(at: indexPath.row)
            let databaseRef = Database.database().reference()
            let tasksRef = databaseRef.child("tasks")
            let taskToDelete = tasksRef.child(taskKey)
            taskToDelete.removeValue()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
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
                let databaseRef = Database.database().reference()
                let tasksRef = databaseRef.child("tasks")
                guard let tasksKey = tasksRef.childByAutoId().key else {return}
                let taskValue = ["title": titleText, "description": descriptionText]
                tasksRef.updateChildValues([tasksKey: taskValue])
                let newToDoItem = ToDoItem(id: tasksKey, title: titleText, description: descriptionText)
                self.toDoItems.append(newToDoItem)
                self.tableView.reloadData()
                alert.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(addTaskAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
}

