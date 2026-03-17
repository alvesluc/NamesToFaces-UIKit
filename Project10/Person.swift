//
//  Person.swift
//  Project10
//
//  Created by Lucas Macêdo on 14/03/26.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
