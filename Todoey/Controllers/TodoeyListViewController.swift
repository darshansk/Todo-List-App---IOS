//
//  ViewController.swift
//  Todoey
//
//  Created by Darshan Sk on 10/20/18.
//  Copyright © 2018 Darshan Sk. All rights reserved.
//

import UIKit
import CoreData
class TodoeyListViewController: UITableViewController {
    //MARK: - Initailization
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let encoder = PropertyListEncoder()
    let decoder = PropertyListDecoder()
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
           
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
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
        try context.save()
            
        }
        catch{
            print("Error in context , \(error)")
        }
      tableView.reloadData()

    }
    
    //MARK: - Load the data from the plist file
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do{
           itemArray = try context.fetch(request)
        } catch{
            print("Error in fetching data \(error)")
        }

    }
  
    //MARK: -Delete items
//    func deleteItems(){
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
   // saveItems()
//    }
    
   
}
//MARK: - Search Button Functions
extension TodoeyListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
 request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
      request.sortDescriptors = [NSSortDescriptor.init(key: "title", ascending: true)]
        
        loadItems(with: request)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
           
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }
        }
    }
    
}
