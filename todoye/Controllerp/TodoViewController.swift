//
//  ViewController.swift
//  todoye
//
//  Created by Syed on 18/12/17.
//  Copyright © 2017 Syed. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    var itemArray = [Item]()
    //let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(dataFilePath)
        
        loadItems()
      //if  let items = defaults.array(forKey: "TodoListArray") as? [String]
      //{
       // itemArray = items
       // }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        //let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        itemArray[indexPath.row].done  = !itemArray[indexPath.row].done
        saveItems()
        //tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey list", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "AddItem", style: .default) { (action) in
           //print("Success!")
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            let encoder = PropertyListEncoder()
            do{
                let data = try encoder.encode(self.itemArray)
                try data.write(to: self.dataFilePath!)
            } catch {
                print("error is .\(error)")
            }
            
            self.tableView.reloadData()
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
           alertTextField.placeholder = "Create New Item"
           // print(alertTextField.text)
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
func saveItems()
{
    let encoder = PropertyListEncoder()
    do{
        let data = try encoder.encode(itemArray)
        try data.write(to: dataFilePath!)
    } catch {
        print("error is .\(error)")
    }
}
func loadItems()
{
    if let data = try? Data(contentsOf:dataFilePath!){
        let decode = PropertyListDecoder()
        do{
             itemArray = try decode.decode([Item].self, from: data)
        } catch {
            print("error decoding is ,\(error)")
        }
    }
}
}
