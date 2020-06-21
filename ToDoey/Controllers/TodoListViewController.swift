//
//  ViewController.swift
//  ToDoey
//
//  Created by Andrew Freire on 6/11/20.
//  Copyright © 2020 Andrew Freire. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
            
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //Grab the persistent container viewcontext from the instance of our App Delegate at runtime
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        //If there is an array with the name "TodoListArray" in our user defaults, set the itemArray equal to it
        loadItems()
    }
    
    //MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Make sure we reuse cells as we scroll
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        let item = itemArray[indexPath.row]
        //set the text of the cell equal to the Index path row number equivalent to our item array
        cell.textLabel?.text = item.title
        
        
        //Ternary operator
        //value = condition ? valueifTrue : valueifFalse

        
        //set the checkmark on if status of the object is "done" using ternary operator
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        //Delete from the context and save
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
//
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        //return the cell
        return cell
    }
    
    //MARK: Table View Delegate Methods
    
    //This calls when we select a cell in the table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Print the name of the row we selected
        //print(itemArray[indexPath.row])
        
        //if our item.done is true, make it false and vice versa
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //Reload the table to see the status update
        tableView.reloadData()
        
        //deselect the cell after it has been tapped so it doesn't remaoin highlighted. And animate the resule
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: Add Items to our list
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        //Create a UI Alert window
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
        
        //Creation an option/action for the above alert window
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks Add Item on the UI Alert
            
            //Create a new item from the above context
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()

            //Once we append the new item to our array, we need to reload the entire table view to update the UI
            self.tableView.reloadData()
        }
        
        //This adds a text field to our UI Alert
        alert.addTextField { (alertTextField) in
            //Modify the placeholder text
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        //Add the "Add Item" action to the above Alert controller
        alert.addAction(action)
        
        //Present the UI Alert we created to the user
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Save Data Methods
    
    func saveItems(){
        //Save our data from the context to our data model
        do {
            try context.save()
        } catch {
            print ("Error saving context: \(error)")
        }
        
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        //Fetch the request inside a do catch block to accommodate for errors
        do{
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
}

//MARK: Search Bar functionality

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //tell Xcode what type of request we are fetching and from which Entity
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //Create a predicate with the arguments of our request
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //Assign the predicate we created to our request value
        request.predicate = predicate
        
        //Sort the results by title in Alphabetical order
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        //Pass in any sort descriptors we want. In this case, there is only one but you can do many within the array
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request, predicate: predicate)
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

