//
//  ViewController.swift
//  fakeNotes
//
//  Created by Kristoffer Eriksson on 2020-11-04.
//

import UIKit

class ViewController: UITableViewController {
    
    var notes = [Note]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .yellow
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        
        deleteEmpty()
        
        load()
    }
    
    func deleteEmpty(){
        for (index, note) in notes.enumerated() {
            if note.text == nil{
                notes.remove(at: index)
            }
        }
    }
    
    //testfunction
    func seed(title: String, text: String){
        notes.append(Note(title: title, text: text))
        
    }
    
    func save(){
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(notes){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
        } else {
            print("failed to save notes")
        }
    }
    
    func load(){
        let defaults = UserDefaults.standard
        if let savedNotes = defaults.object(forKey: "notes") as? Data{
            let jsonDecoder = JSONDecoder()
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch {
                print("failed to load notes")
            }
            
        }
    }
    
    @objc func addNote(){
        
        if let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
            
            let newNote = Note(title: "", text: "")
            notes.insert(newNote, at: 0)
            vc.thisNote = newNote
            vc.noteIndex = notes.firstIndex(of: newNote)
            
            vc.delegate = self
            vc.notes = notes
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.reloadData()
    }
    
    func dateConverter(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let stringDate = formatter.string(from: date)
        
        return stringDate
    }
    
    
    //Table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = dateConverter(date: note.time!)
        cell.backgroundColor = .yellow
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
            
            vc.thisNote = notes[indexPath.row]
            vc.noteIndex = notes.firstIndex(of: notes[indexPath.row])
            vc.notes = notes
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}

