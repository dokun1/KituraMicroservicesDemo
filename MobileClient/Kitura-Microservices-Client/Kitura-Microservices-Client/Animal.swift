//
//  Animal.swift
//  Kitura-Microservices-Client
//
//  Created by David Okun IBM on 1/24/17.
//  Copyright © 2017 David Okun IBM. All rights reserved.
//

import Foundation

extension Bool {
    var stringValue: String {
        if self == true {
            return "true"
        } else {
            return "false"
        }
    }
}

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}

public struct AnimalConstants {
    static let bear = "Bear"
    static let cat = "Cat"
}

public struct AnimalJSONConstants {
    static let id = "id"
    static let photoURL = "photoURL"
    static let looksFriendly = "looksFriendly"
    static let plural = "plural"
    static let type = "animalType"
}

class Animal: Equatable, CustomStringConvertible {
    enum AnimalType: String {
        case Cat = "Cat"
        case Bear = "Bear"
    }
    
    var description: String {
        let typeString = self.type == AnimalType.Bear ? "Bear" : "Cat"
        return "\n\nAnimal Type: \(typeString)\nID: \(self.animalID)\nPhotoURL: \(self.photoURL)\nLooks Friendly: \(self.looksFriendly.stringValue)\nPlural: \(self.plural.stringValue)"
    }
    
    var loadedImageData: Data?
    
    let animalID: Int
    let photoURL: String
    let looksFriendly: Bool
    let plural: Bool
    let type: AnimalType
    
    var json: [String: AnyObject] {
        let typeString = (type == AnimalType.Cat) ? "Cat" : "Bear"
        return [AnimalJSONConstants.id : animalID as AnyObject,
                AnimalJSONConstants.photoURL : photoURL as AnyObject,
                AnimalJSONConstants.looksFriendly : looksFriendly as AnyObject,
                AnimalJSONConstants.plural : plural as AnyObject,
                AnimalJSONConstants.type : typeString as AnyObject]
    }
    
    init (animalID: Int, photoURL: String, looksFriendly: Bool, plural: Bool, type: AnimalType) {
        self.animalID = animalID
        self.photoURL = photoURL
        self.looksFriendly = looksFriendly
        self.plural = plural
        self.type = type
    }
    
    init? (json: [String: AnyObject]) {
        if let animalID = json[AnimalJSONConstants.id] as? Int,
            let photoURL = json[AnimalJSONConstants.photoURL] as? String,
            let looksFriendly = json[AnimalJSONConstants.looksFriendly] as? Bool,
            let plural = json[AnimalJSONConstants.plural] as? Bool,
            let typeString = json[AnimalJSONConstants.type] as? String {
            self.animalID = animalID
            self.photoURL = photoURL
            self.looksFriendly = looksFriendly
            self.plural = plural
            self.type = typeString == AnimalConstants.bear ? AnimalType.Bear : AnimalType.Cat
        } else {
            return nil
        }
    }

    func loadImage(_ completion: @escaping (_ animal: Animal, _ error: NSError?) -> Void) {
        guard let url = URL(string:self.photoURL) else {
            DispatchQueue.main.async {
                completion(self, nil)
            }
            return
        }
        
        let loadRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: loadRequest, completionHandler: { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(self, error as NSError?)
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(self, nil)
                }
                return
            }
            self.loadedImageData = data
            DispatchQueue.main.async {
                completion(self, nil)
            }
        })
        task.resume()
    }

}

func == (lhs: Animal, rhs: Animal) -> Bool {
    return lhs.type == rhs.type && lhs.animalID == rhs.animalID
}
