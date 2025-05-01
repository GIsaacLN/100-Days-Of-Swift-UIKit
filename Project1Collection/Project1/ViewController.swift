//
//  ViewController.swift
//  Project1
//
//  Created by Gustavo Isaac Lopez Nunez on 20/03/25.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        performSelector(inBackground: #selector(fetchImages), with: nil)
    }
    
    @objc func fetchImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let files = try! fm.contentsOfDirectory(atPath: path)
        
        for file in files {
            if file.hasPrefix("nssl") {
                pictures.append(file)
            }
        }
        pictures.sort()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCell else { fatalError("Unable to dequeue Picture Cell") }
        cell.textLabel?.text = pictures[indexPath.item]
        cell.imageView.image = UIImage(named: pictures[indexPath.item])
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            vc.selectedImage = pictures[indexPath.item]
            vc.titleString = "Picture \(indexPath.item + 1) of \(pictures.count)"
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }

    }
}

