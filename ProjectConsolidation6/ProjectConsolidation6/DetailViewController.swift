//
//  DetailViewController.swift
//  ProjectConsolidation6
//
//  Created by Gustavo Isaac Lopez Nunez on 27/05/25.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var capitalLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var populationLabel: UILabel!
    @IBOutlet var presidentLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    
    var country: Country!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = country.name
        if let url = URL(string: self.country.flag) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url){
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.imageView.image = image
                        }
                    }
                }
            }
        }
        imageView.contentMode = .scaleAspectFill
        
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.gray.cgColor
        
        nameLabel.text = country.name
        capitalLabel.text = country.capital
        sizeLabel.text = country.size
        populationLabel.text = "\(String(describing: country.population)) people"
        presidentLabel.text = "President: \(String(describing: country.president))"
        currencyLabel.text = "Currency: \(String(describing: country.currency))"
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
