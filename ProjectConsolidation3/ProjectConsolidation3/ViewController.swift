//
//  ViewController.swift
//  ProjectConsolidation3
//
//  Created by Gustavo Isaac Lopez Nunez on 13/04/25.
//

import UIKit

class ViewController: UITableViewController {
    private var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearList))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Add Item", message: "Save your shopping item to the list", preferredStyle: .alert)
        ac.addTextField()
        
        let add = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] _ in
            guard let item = ac?.textFields?.first?.text else { return }
            self?.submit(item)
        }
        
        ac.addAction(add)
        present(ac, animated: true)
    }

    func submit(_ item: String){
        shoppingList.insert(item, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func clearList() {
        shoppingList.removeAll()
        tableView.reloadData()
    }
}

