//
//  ViewController.swift
//  ToDoey
//
//  Created by Andrew Freire on 6/11/20.
//  Copyright © 2020 Andrew Freire. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let itemArray = ["Find Mikey", "Buy Eggos", "Destroy the Demigorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Make sure we reuse cells as we scroll
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //set the text of the cell equal to the Index path row number equivalent to our item array
        cell.textLabel?.text = itemArray[indexPath.row]
        
        //return the cell
        return cell
    }
    
    //MARK: Table View Delegate Methods
    
    //This calls when we select a cell in the table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Print the name of the row we selected
        //print(itemArray[indexPath.row])
        
        //deselect the cell after it has been tapped so it doesn't remaoin highlighted. And animate the resule
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            //Grab the cell we selected and change its accessory type to checkmark
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }

}

