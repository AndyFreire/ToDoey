//
//  ViewController.swift
//  ToDoey
//
//  Created by Andrew Freire on 6/11/20.
//  Copyright © 2020 Andrew Freire. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var toDoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Make sure we reuse cells as we scroll
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        if let item = toDoItems?[indexPath.row]{
            //set the text of the cell equal to the Index path row number equivalent to our item array
            cell.textLabel?.text = item.title
            
            //set the checkmark on if status of the object is "done" using ternary operator
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    //MARK: Table View Delegate Methods
    
    //This calls when we select a cell in the table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do{
                try realm.write{
                    item.done = !item.done
                }
            } catch {
                print("Error saving item status: \(error)")
            }
        }
        
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
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        //What will happen once the user clicks Add Item on the UI Alert
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error adding new item: \(error)")
                }
            }
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

    
    func loadItems(){
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        

//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate{
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        //Fetch the request inside a do catch block to accommodate for errors
//        do{
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data: \(error)")
//        }
//
//        tableView.reloadData()
        
    }
    
}

//MARK: Search Bar functionality

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
        
//        //tell Xcode what type of request we are fetching and from which Entity
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        //Create a predicate with the arguments of our request
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        //Assign the predicate we created to our request value
//        request.predicate = predicate
//
//        //Sort the results by title in Alphabetical order
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//
//        //Pass in any sort descriptors we want. In this case, there is only one but you can do many within the array
//        request.sortDescriptors = [sortDescriptor]
//
//        loadItems(with: request, predicate: predicate)
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

