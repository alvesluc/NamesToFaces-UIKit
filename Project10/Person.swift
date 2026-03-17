//
//  Person.swift
//  Project10
//
//  Created by Lucas Macêdo on 14/03/26.
//

import UIKit

class Person: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(of: NSString.self, forKey: "name") as? String ?? ""
        image = coder.decodeObject(of: NSString.self, forKey: "image") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(image, forKey: "image")
    }
}
