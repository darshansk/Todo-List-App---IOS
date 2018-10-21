//
//  ViewController.swift
//  Todoey
//
//  Created by Darshan Sk on 10/20/18.
//  Copyright © 2018 Darshan Sk. All rights reserved.
//

import UIKit

class TodoeyListViewController: UITableViewController {
    //MARK: - Initailization
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let encoder = PropertyListEncoder()
    let decoder = PropertyListDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    // MARK: - TableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoeyItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    // MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - ADD items button
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add new ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.saveItems()
                    }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Func to save items in plist
    func saveItems(){
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        }
        catch{
            print("Error in encoding item array , \(error)")
        }
      tableView.reloadData()

    }
    
    //MARK: - Load the data from the plist file
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
           do{
            itemArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("Error while decoding the data \(error)")
            }
        }
        
    }
}

