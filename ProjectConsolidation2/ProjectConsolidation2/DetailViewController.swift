//
//  DetailViewController.swift
//  ProjectConsolidation2
//
//  Created by Gustavo Isaac Lopez Nunez on 29/03/25.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedFlag: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedFlag = selectedFlag {
            title = selectedFlag.uppercased()
            imageView.image = UIImage(named: selectedFlag)
        }

        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareFlag))
    }
    
    @objc func shareFlag() {
        guard let image = imageView.image, let selectedFlag = selectedFlag else { return }
        let activityViewController = UIActivityViewController(activityItems: [image, selectedFlag], applicationActivities: nil)
        present(activityViewController, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
