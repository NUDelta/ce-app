//
//  Experience.swift
//  ce-app
//
//  Created by Kevin Chen on 2/5/16.
//  Copyright © 2016 delta. All rights reserved.
//

class Experience {
    var name: String
    var author: String
    var description: String
    var startEmailText: String
    var modules: [String]
    var requirements: [String]
    
    init(name: String, author: String, description: String, startEmailText: String, modules: [String], requirements: [String]) {
        self.name = name
        self.author = author
        self.description = description
        self.startEmailText = startEmailText
        self.modules = modules
        self.requirements = requirements
    }
}