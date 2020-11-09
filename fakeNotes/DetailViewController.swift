//
//  DetailViewController.swift
//  fakeNotes
//
//  Created by Kristoffer Eriksson on 2020-11-07.
//

import UIKit

class DetailViewController: UIViewController, UINavigationControllerDelegate {
    
    weak var delegate: ViewController!

    @IBOutlet weak var text: UITextView!
    
    var notes = [Note]()
    var thisNote : Note!
    var noteIndex : Int!
    
    override func viewWillDisappear(_ animated: Bool) {
        thisNote.text = text.text
        
        save()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        title = thisNote?.title
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "delete", style: .plain, target: self, action: #selector(deleteNote))
        
        view.backgroundColor = .yellow
        text.backgroundColor = .yellow
        text.text = thisNote?.text
        
        setTitle()
        
    }
    
    @objc func deleteNote(){
        notes.remove(at: noteIndex)
        noteIndex = nil
        navigationController?.popViewController(animated: true)
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
    
    func setTitle(){
        if thisNote.title == ""{
            let ac = UIAlertController(title: "Set title", message: "Set title", preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "OK", style: .default) {
                [weak self, weak ac] _ in
                guard let newTitle = ac?.textFields?[0].text else {return}
                self?.thisNote.title = newTitle
                self?.viewDidLoad()
                
            })
            present(ac, animated: true)
        }
        //add option to change title or autoadd title with first sentence
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if let vc = viewController as? ViewController {
            
            vc.notes = notes
            vc.save()
            vc.tableView.reloadData()
            
        }
    }
}
