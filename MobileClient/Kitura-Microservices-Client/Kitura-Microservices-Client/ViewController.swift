//
//  ViewController.swift
//  Kitura-Microservices-Client
//
//  Created by David Okun IBM on 1/24/17.
//  Copyright © 2017 David Okun IBM. All rights reserved.
//

import UIKit

// MARK: Class Assignments
final class ViewController: UICollectionViewController {
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 10.0, right: 10.0)
    fileprivate var animals = [Animal]()
    
    @IBAction private func makeRequest() {
        // this is where we will start working with our params
        let defaults = UserDefaults.standard
        print("defaults loaded")
    }
    
    @IBAction private func makeSampleRequest() {
        animals = [Animal]()
        let firstAnimal = Animal.init(animalID: 1, photoURL: "https://img.buzzfeed.com/buzzfeed-static/static/2014-04/enhanced/webdr02/9/12/enhanced-buzz-11844-1397060009-22.jpg?no-auto", looksFriendly: true, plural: true, type: Animal.AnimalType.Cat)
        let secondAnimal = Animal.init(animalID: 2, photoURL: "http://static.boredpanda.com/blog/wp-content/uploads/2016/09/mother-bear-cubs-animal-parenting-21-57e3a2161d7f7__880.jpg", looksFriendly: true, plural: true, type: Animal.AnimalType.Bear)
        let thirdAnimal = Animal.init(animalID: 3, photoURL: "https://img.buzzfeed.com/buzzfeed-static/static/2014-04/enhanced/webdr07/9/14/enhanced-18799-1397069418-11.jpg?no-auto", looksFriendly: false, plural: false, type: Animal.AnimalType.Cat)
        let fourthAnimal = Animal.init(animalID: 4, photoURL: "https://i.imgur.com/AOJJDhu.jpg", looksFriendly: true, plural: false, type: Animal.AnimalType.Bear)
        animals.append(firstAnimal)
        animals.append(secondAnimal)
        animals.append(thirdAnimal)
        animals.append(fourthAnimal)
        collectionView?.reloadData()
    }
}

// MARK: Datasource
extension ViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animals.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "animalCell", for: indexPath) as! AnimalCell
        let animal = animals[indexPath.item]
        cell.backgroundColor = UIColor.lightGray
        cell.friendlyLabel.text = animal.looksFriendly ? "Yes :)" : "No :("
        cell.pluralLabel.text = animal.plural ? "Yes" : "No"
        cell.animalIDLabel.text = String(animal.animalID)
        animal.loadImage { animal, error in
            cell.imageView.image = animal.loadedImage
        }
        return cell
    }
}

// MARK: Flow Layout Delegate
extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * 2
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
