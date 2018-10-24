//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Darshan Sk on 10/22/18.
//  Copyright © 2018 Darshan Sk. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
     //MARK: - Initialization
var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
loadCategories()
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    

    //MARK: - Add new catergoies

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textfield = UITextField()
    let alert = UIAlertController.init(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Add Category", style: .default) { (action) in
             let newCategory = Category(context: self.context)
            newCategory.name = textfield.text!
            self.categoryArray.append(newCategory)
               self.saveCategories()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textfield = alertTextField
        }
        alert.addAction(action)
            present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate Methods
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoeyListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    //MARK: - Data Manupliation
    func saveCategories(){
        
        do{
            try context.save()
            
        }
        catch{
            print("Error in context , \(error)")
        }
        tableView.reloadData()
    }
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            categoryArray = try context.fetch(request)
        } catch{
            print("Error in fetching data \(error)")
        }
tableView.reloadData()
    }
}
