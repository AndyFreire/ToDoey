//
//  ViewController.swift
//  ToDoey
//
//  Created by Andrew Freire on 6/11/20.
//  Copyright © 2020 Andrew Freire. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
            
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

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
            let newItem = Item()
            newItem.title = textField.text!
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
        
        //Create a pList encoder
        let encoder = PropertyListEncoder()
        
        //Encode our data. We need to include try statements because it can throw an error
        do {
            //Encode the itemArray as a pList
            let data = try encoder.encode(self.itemArray)
            //Writ the pList to the filepath
            try data.write(to: self.dataFilePath!)
        } catch {
            print ("Error encoding item Array: \(error)")
        }
        
    }
    
    func loadItems(){
        //If there is a file at this filepath
        if let data = try? Data(contentsOf: dataFilePath!){
            //Initialize a Decoder
            let decoder = PropertyListDecoder()
            do {
                //Decode the PList as an array of items from our filepath
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding: \(error)")
            }
        }
    }
    
}

