//
//  ViewController.swift
//  Todo-UserDefaults
//
//  Created by Ahmad Issa on 1/15/18.
//  Copyright © 2018 Ahmad Issa. All rights reserved.
//

import UIKit


class TodoListViewController: UITableViewController {
    //MARK:- General Comment
    /*
     In this code we initial user the userdefaults to store the item to do list, then we upgrade it to set checkmark with each item, at this point to store the checkmark with the data since make it on the level of the cell will not save it. So we switch the store from on variable to make datamodel (custom object) to save both item and its check make.
     But at this point the userdefault will fail in store custom object it is only for simple variable so we will store as file system not as userdefault.
     Note both will be in the system as plist file but one is formated for userdefault other open plist file we formatted as data dictionary
    */
    //MARK:- Local Class Variables
    let defaults = UserDefaults.standard
    var itemArray = [String]()
    var itemArrayObj = [Item]()
    var dataFilePath : URL?// = URL(fileURLWithPath: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*
        defaults.data(forKey: <#T##String#>)
        defaults.object(forKey: <#T##String#>)
        defaults.stringArray(forKey: <#T##String#>)
        defaults.string(forKey: <#T##String#>)
        defaults.double(forKey: <#T##String#>)
        defaults.dictionary(forKey: <#T##String#>)
        defaults.bool(forKey: <#T##String#>)
*/
        if let items = defaults.array(forKey: "TodoListArray"){
            itemArray = items as! [String]
        }
        
        let newItem = Item()
        newItem.titleItem = "Ahmad M. Issa"
        newItem.done = true
        itemArrayObj.append(newItem)
        
        dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
        loadItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return itemArray.count
        return itemArrayObj.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Using the below function will create new cell each item a cell needed and will not make use of any created cell, but in this case each time the data will be reset and any change will go.
        // on the other hand any attribute on the cell need to be set on the data and not on the cell caues this will case when reusing the cell will make this attribute display with the new cell for new data (since it is reusable cell).
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        //cell.textLabel?.text = itemArray[indexPath.row]
        
        cell.textLabel?.text = itemArrayObj[indexPath.row].titleItem
        if itemArrayObj[indexPath.row].done {
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    //MARK:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
         // this section when we did the selection on the level of cell not data.
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        */
        
        itemArrayObj[indexPath.row].done = !itemArrayObj[indexPath.row].done
    
        tableView.reloadData()
        saveItemsToFile(newItemArray: itemArrayObj)

        // we make this animation since after we put the reloadData the delection method not animate anymore since reload data remove row selection so we put the selection back then remove it to animate it.
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }) { (true) in
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //MARK:- Action Events
    @IBAction func AddTodoItem(_ sender: UIBarButtonItem) {
        var txtAlertTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //this will be the action when the button is pressed
            let inText = (txtAlertTextField.text?.isEmpty)! ?  "New Todo Item" : txtAlertTextField.text
            
            self.itemArray.append(inText!)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            let newItem = Item()
            newItem.titleItem = inText!
            self.itemArrayObj.append(newItem)
            
            // For File store method Codable this in swift 4 only
            self.saveItemsToFile(newItemArray: self.itemArrayObj)
            
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Todo Item Name"
            txtAlertTextField = alertTextField
        }
        
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Utilities Function
    func saveItemsToFile(newItemArray: [Item]){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(newItemArray)
            try data.write(to: dataFilePath!)
        }
        catch{
            print("Error in Encoding")
        }
    }
    
    func loadItems(){
        let decoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: dataFilePath!){
            do{
                // the inside paratmeter is the one which we will decode to its type
                itemArrayObj = try decoder.decode([Item].self, from: data)
            }
            catch{
                print("Error in Decoding")
            }
        }
    }

}

