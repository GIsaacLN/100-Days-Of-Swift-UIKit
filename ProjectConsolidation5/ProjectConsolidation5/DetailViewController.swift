//
//  DetailViewController.swift
//  ProjectConsolidation5
//
//  Created by Gustavo Isaac Lopez Nunez on 09/05/25.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedPicture: Picture?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedPicture?.caption
        
        if let selectedPicture = selectedPicture {
            let path = getDocumentsDirectory().appendingPathComponent(selectedPicture.image)

            imageView.image = UIImage(contentsOfFile: path.path())
        }
        // Do any additional setup after loading the view.
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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
