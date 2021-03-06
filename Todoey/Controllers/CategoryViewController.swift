//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Yosef Ben Zaken on 24/10/2021.
//  Copyright © 2021 Yossi Ben Zaken. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var catArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    // MARK: - Add New Category
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var txtField = UITextField();
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let category = Category(context: self.context)
            category.name = txtField.text!
            self.catArray.append(category)
            self.saveCategories()
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            txtField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = catArray[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectCategory = catArray[indexPath.row]
        }
    }
    // MARK: - Model Manipulation Methods
    func saveCategories() {
        do {
            try self.context.save()
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            catArray = try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }
        tableView.reloadData()
    }
}
