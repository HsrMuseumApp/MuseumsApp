//
//  Location.swift
//  MuseumApp
//
//  Created by Hans Muster on 27/11/14.
//  Copyright (c) 2014 HSR. All rights reserved.
//

import Foundation

class Location: NSObject {
    var id: Int
    var name: String
    var questions: [Task]
    
    init(id: Int, name: String, questions: [Task]) {
        self.id = id
        self.name = name
        self.questions = questions
    }
}