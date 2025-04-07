//
//  ViewController.swift
//  Project6b
//
//  Created by Gustavo Isaac Lopez Nunez on 07/04/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label1 = UILabel()
        let label2 = UILabel()
        let label3 = UILabel()
        let label4 = UILabel()
        let label5 = UILabel()

        let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]

        for label in viewsDictionary.values {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.sizeToFit()
        }
        label1.backgroundColor = UIColor.red
        label1.text = "THESE"

        label2.backgroundColor = UIColor.cyan
        label2.text = "ARE"

        label3.backgroundColor = UIColor.yellow
        label3.text = "SOME"
        
        label4.backgroundColor = UIColor.green
        label4.text = "AWESOME"

        label5.backgroundColor = UIColor.orange
        label5.text = "LABELS"
        
        for label in viewsDictionary.values {
            view.addSubview(label)
        }

        for label in viewsDictionary.keys {
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
        }
        
        view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1]-[label2]-[label3]-[label4]-[label5]", options: [], metrics: nil, views: viewsDictionary))
    }


}

