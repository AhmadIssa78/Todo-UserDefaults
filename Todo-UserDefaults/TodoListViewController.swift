//
//  ViewController.swift
//  Todo-UserDefaults
//
//  Created by Ahmad Issa on 1/15/18.
//  Copyright © 2018 Ahmad Issa. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //MARK:- Local Class Variables
    var itemArray = ["Ahmad Issa", "Welcome App", "Todo List"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        // makes row selection to deselected highlight and animate it
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- Action Events
    @IBAction func AddTodoItem(_ sender: UIBarButtonItem) {
        var txtAlertTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //this will be the action when the button is pressed
            //print(txtAlertTextField.text)
            let inText = (txtAlertTextField.text?.isEmpty)! ?  "New Todo Item" : txtAlertTextField.text
            self.itemArray.append(inText!)
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Todo Item Name"
            txtAlertTextField = alertTextField
        }
        
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
    
}

