//
//  Animal.swift
//  Kitura-Microservices-Client
//
//  Created by David Okun IBM on 1/24/17.
//  Copyright © 2017 David Okun IBM. All rights reserved.
//

import UIKit

class Animal: Equatable {
    enum AnimalType {
        case Cat
        case Bear
    }
    var loadedImage: UIImage?
    let animalID: Int
    let photoURL: String
    let looksFriendly: Bool
    let plural: Bool
    let type: AnimalType
    
    init (animalID: Int, photoURL: String, looksFriendly: Bool, plural: Bool, type: AnimalType) {
        self.animalID = animalID
        self.photoURL = photoURL
        self.looksFriendly = looksFriendly
        self.plural = plural
        self.type = type
    }

    func loadImage(_ completion: @escaping (_ animal: Animal, _ error: NSError?) -> Void) {
        guard let url = URL(string:self.photoURL) else {
            DispatchQueue.main.async {
                completion(self, nil)
            }
            return
        }
        
        let loadRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: loadRequest, completionHandler: { (data, response, error) in
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
            
            let returnedImage = UIImage(data: data)
            self.loadedImage = returnedImage
            DispatchQueue.main.async {
                completion(self, nil)
            }
        }).resume()
    }

}

func == (lhs: Animal, rhs: Animal) -> Bool {
    return lhs.type == rhs.type && lhs.animalID == rhs.animalID
}