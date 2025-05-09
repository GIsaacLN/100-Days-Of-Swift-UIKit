//
//  ViewController.swift
//  Project1
//
//  Created by Gustavo Isaac Lopez Nunez on 20/03/25.
//

import UIKit

class ViewController: UITableViewController {
    var pictures: [PictureCount] = [PictureCount]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
                
        let defaults = UserDefaults.standard
        
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                pictures = try jsonDecoder.decode([PictureCount].self, from: savedPictures)
            } catch {
                
            }
        } else {
            performSelector(inBackground: #selector(fetchImages), with: nil)
        }
    }
    
    @objc func fetchImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let files = try! fm.contentsOfDirectory(atPath: path)
        
        for file in files {
            if file.hasPrefix("nssl") {
                let picture = PictureCount(name: file, viewCount: 0)
                pictures.append(picture)
            }
        }
        pictures.sort { $0.name > $1.name }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row].name
        cell.detailTextLabel?.text = "\(pictures[indexPath.row].viewCount) views"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            vc.selectedImage = pictures[indexPath.row].name
            vc.titleString = "Picture \(indexPath.row + 1) of \(pictures.count)"
            // 3: now push it onto the navigation controller
            pictures[indexPath.row].viewCount += 1
            save()
            tableView.reloadData()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedPictures = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedPictures, forKey: "pictures")
        }
    }
}

