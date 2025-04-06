//
//  ViewController.swift
//  Project5
//
//  Created by Gustavo Isaac Lopez Nunez on 04/04/25.
//

import UIKit

enum GameError: Error {
    case notValid
    case notUnique
    case notAWord
}

extension GameError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notValid:
            return "Word can't be built out of the letters from the current word."
        case .notUnique:
            return "Be more original! That word has already been used."
        case .notAWord:
            return "Words must be real English words."
        }
    }
}

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Restart", style: .plain, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["apple", "banana", "cherry"]
        }
        
        startGame()
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter a word", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?.first?.text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        do {
            if try checkWord(lowerAnswer) {
                usedWords.insert(lowerAnswer, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
                return
            }
        } catch {
            guard let error = error as? GameError else { return }
            showErrorMessage(error)
        }
    }
    
    func showErrorMessage(_ error: GameError) {
        let errorTitle: String
        let errorMessage = error.localizedDescription
        
        switch error {
        case .notValid:
            errorTitle =  "Not a valid word."
        case .notUnique:
            errorTitle = "Word has already been used."
        case .notAWord:
            errorTitle = "Not a real word."
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func checkWord(_ word: String) throws -> Bool {
        if !isPossible(word: word) {
            throw GameError.notValid
        }
        if !isOriginal(word: word) {
            throw GameError.notUnique
        }
        if !isReal(word: word) {
            throw GameError.notAWord
        }
        return true
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for char in word {
            if let position = tempWord.firstIndex(of: char) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        if word == title?.lowercased() { return false }
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool{
        if word.count < 3 { return false }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
}

