//
//  DetailViewController.swift
//  ProjectConsolidation8
//
//  Created by Gustavo Isaac Lopez Nunez on 16/06/25.
//

import UIKit

class DetailViewController: UIViewController {
    var note: Note!
    var noteItems = [Note]()
    @IBOutlet var textArea: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.wave.2.fill"), style: .plain, target: self, action: #selector(shareWithFriends))
        
        textArea.text = note.noteText
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeNote))
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))

        let bar = UIToolbar()
        bar.items = [spacer, done]
        bar.sizeToFit()
        textArea.inputAccessoryView = bar
        
        toolbarItems = [spacer, delete, compose]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if note.noteText == textArea.text { return }
        
        noteItems.removeAll { n in
            n.id == note.id
        }

        if !textArea.text.isEmpty {
            note.noteText = textArea.text.trimmingCharacters(in: .whitespacesAndNewlines)
            noteItems.insert(note, at: 0)
        }
                
        save()
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textArea.contentInset = .zero
        } else {
            textArea.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textArea.scrollIndicatorInsets = textArea.contentInset
        
        let selectedRange = textArea.selectedRange
        textArea.scrollRangeToVisible(selectedRange)
    }
    
    @objc func deleteNote() {
        let ac = UIAlertController(title: "Delete note", message: "Are you sure you want to delete this note?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.noteItems.removeAll { n in
                n.id == self?.note.id
            }
            
            self?.save()
            
            self?.navigationController?.popViewController(animated: true)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    @objc func composeNote() {
        textArea.becomeFirstResponder()
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(noteItems) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
        } else {
            print("Failed to save notes")
        }
    }

    @objc func shareWithFriends() {
        note.noteText = textArea.text
        let textToShare = note.noteText
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        present(activityViewController, animated: true)
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
