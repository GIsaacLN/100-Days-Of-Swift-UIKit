//
//  ViewController.swift
//  ProjectConsolidation8
//
//  Created by Gustavo Isaac Lopez Nunez on 16/06/25.
//

import UIKit

class ViewController: UITableViewController {
    var text: UIBarButtonItem!
    var noteItems = [Note]() {
        didSet {
            text.title = "\(noteItems.count) Notes"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
                
        let defaults = UserDefaults.standard
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let newNote = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNewNote))
        text = UIBarButtonItem(title: "0 Notes", style: .plain, target: nil, action: nil)
        
        toolbarItems = [spacer, text, spacer, newNote]
        navigationController?.setToolbarHidden(false, animated: false)

        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                noteItems = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch {
                print("Failed to load notes")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteItems.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
            // 2: success! Set its text property
            let note = noteItems[indexPath.row]
            vc.note = note
            vc.noteItems = noteItems
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let note = noteItems[indexPath.row]
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.description
        
        return cell
    }
    
    @objc func createNewNote() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
            // 2: success! Set its text property
            let note = Note(id: UUID().uuidString)
            vc.note = note
            noteItems.insert(note, at: 0)
            vc.noteItems = noteItems
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                noteItems = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch {
                print("Failed to load notes")
            }
        }

        tableView.reloadData()
    }
}

