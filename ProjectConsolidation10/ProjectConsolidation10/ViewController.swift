//
//  ViewController.swift
//  ProjectConsolidation10
//
//  Created by Gustavo Isaac Lopez Nunez on 03/07/25.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    var originalImage: UIImage?
    var curTopText: String?
    var curBottomText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MemeGen"

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Import Photo", style: .plain, target: self, action: #selector(promptImport))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(promptShare))
    }

    @IBAction func setTopTextTapped(_ sender: Any) {
        guard originalImage != nil else { return }

        let ac = UIAlertController(title: "Set top message", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
            self.curTopText = ac.textFields?.first?.text
            self.setText()
        }))
        
        present(ac, animated: true)
    }
        
    @IBAction func setBottomTextTapped(_ sender: Any) {
        guard originalImage != nil else { return }

        let ac = UIAlertController(title: "Set bottom message", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
            self.curBottomText = ac.textFields?.first?.text
            self.setText()
        }))
        
        present(ac, animated: true)

    }
    
    @objc func promptImport() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc func promptShare() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image to share")
            return
        }
        
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityController, animated: true)
    }
    
    func setText() {
        guard let image = originalImage else {
            print("No image to set text to")
            return
        }
                
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let editedImage = renderer.image { ctx in
            image.draw(at: CGPointZero)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .paragraphStyle: paragraphStyle,
                .font: UIFont(name: "Impact", size: 76) ?? UIFont.systemFont(ofSize: 76),
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .strokeWidth: -5
            ]
            
            if let topText = curTopText {
                let attributedString = NSAttributedString(string: topText, attributes: attrs)
                attributedString.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height/2).insetBy(dx: 20, dy: 20))
            }
            
            if let bottomText = curBottomText {
                let attributed = NSAttributedString(string: bottomText, attributes: attrs)
                let maxWidth = image.size.width - 40
                let maxHeight = image.size.height / 2 - 40

                let measured = attributed.boundingRect(
                    with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    context: nil
                )

                let drawRect = CGRect(
                    x: 20,
                    y: image.size.height - 20 - measured.height,
                    width: maxWidth,
                    height: measured.height
                )

                // 3. Draw
                attributed.draw(in: drawRect)
            }
        }
        
        imageView.image = editedImage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        originalImage = image
        imageView.image = originalImage
    }
}

