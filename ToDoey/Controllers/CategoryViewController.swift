//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Andrew Freire on 6/20/20.
//  Copyright © 2020 Andrew Freire. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()

    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    
    //MARK: Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
    }
    
    //MARK: Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    //MARK: Data Manipulation Methods
    
    func save(category: Category){
        //Save our data from the context to our data model
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print ("Error saving context: \(error)")
        }
        
    }
    
    func loadCategories(){
        
        //pull out all the items inside our realm with the Category object type
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
        
    
    
    //MARK: Add New Categories
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //Create a UI Alert window
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        //Creation an option/action for the above alert window
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks Add Item on the UI Alert
            
            //Create a new item from the above context
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)

            //Once we append the new item to our array, we need to reload the entire table view to update the UI
            self.tableView.reloadData()
        }
        
        //This adds a text field to our UI Alert
        alert.addTextField { (alertTextField) in
            //Modify the placeholder text
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        //Add the "Add Item" action to the above Alert controller
        alert.addAction(action)
        
        //Present the UI Alert we created to the user
        present(alert, animated: true, completion: nil)
    }
    
}
