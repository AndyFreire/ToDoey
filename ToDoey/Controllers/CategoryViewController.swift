//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Andrew Freire on 6/20/20.
//  Copyright © 2020 Andrew Freire. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    
    //MARK: Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    //MARK: Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    
    //MARK: Data Manipulation Methods
    
    func saveCategories(){
        //Save our data from the context to our data model
        do {
            try context.save()
        } catch {
            print ("Error saving context: \(error)")
        }
        
    }
    
    func loadCategories(request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        //Initialize a fetch request and let Xcode know the type of object/data type you are requesting and the entity you are requesting from
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //Fetch the request inside a do catch block to accommodate for errors
        do{
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
        }
        
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
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategories()

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
