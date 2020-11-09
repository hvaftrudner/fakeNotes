//
//  Note.swift
//  fakeNotes
//
//  Created by Kristoffer Eriksson on 2020-11-07.
//

import UIKit

class Note: NSObject, Codable {
    
    var title: String?
    var text: String?
    var time: Date?
    
    init(title: String, text: String){
        self.title = title
        self.text = text
        self.time = Date()
    }
    
}
