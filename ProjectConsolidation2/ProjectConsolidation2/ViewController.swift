//
//  ViewController.swift
//  ProjectConsolidation2
//
//  Created by Gustavo Isaac Lopez Nunez on 29/03/25.
//

import UIKit

class ViewController: UITableViewController {
    var countries = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let files = try! fm.contentsOfDirectory(atPath: path)
        
        title = "Flags Of The World!"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        for file in files {
            if file.hasSuffix("2x.png") {
                countries.append(String(file.split(separator: "@")[0]))
            }
        }
        
        print(countries)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = countries[indexPath.row].uppercased()
        content.image = UIImage(named: countries[indexPath.row])
        content.imageProperties.maximumSize = CGSize(width: 44, height: 44)
        content.imageProperties.strokeWidth = 1
        content.imageProperties.strokeColor = .secondaryLabel
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedFlag = countries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

