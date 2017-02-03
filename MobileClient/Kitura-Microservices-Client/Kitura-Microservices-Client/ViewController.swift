//
//  ViewController.swift
//  Kitura-Microservices-Client
//
//  Created by David Okun IBM on 1/24/17.
//  Copyright © 2017 David Okun IBM. All rights reserved.
//

import UIKit

extension UIAlertController {
    func addCancelButton() {
        addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
    
    func addOKButton(_ withAction : ((UIAlertAction) -> Swift.Void)?) {
        addAction(UIAlertAction(title: "OK", style: .default, handler: withAction))
    }
}

enum AnimalAPIError: Error {
    case NoData
    case CouldNotParse
    case NoResponse
    case OtherError
}

// MARK: Class Assignments
final class ViewController: UICollectionViewController {
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 10.0, right: 10.0)
    fileprivate var loadedAnimals = [Animal]()
    
    private func requestPath() -> URL? {
        let defaults = UserDefaults.standard
        if let animalChoice = defaults.string(forKey: DefaultQueryOptions.animalChoiceDefaultKey),
            let friendlyChoice = defaults.string(forKey: DefaultQueryOptions.friendlyChoiceDefaultKey),
            let pluralChoice = defaults.string(forKey: DefaultQueryOptions.pluralChoiceDefaultKey),
            let host = defaults.string(forKey: DefaultQueryOptions.hostURLDefaultKey) {
            return URL(string: "\(host)/animals/\(animalChoice)/friendly/\(friendlyChoice)/plural/\(pluralChoice)")
        } else {
            return nil
        }
    }
    
    private func makeRequest() {
        guard let url = requestPath() else {
            // show an error
            let alert = UIAlertController.init(title: "Error", message: "Could not construct URL", preferredStyle: .alert)
            alert.addOKButton(nil)
            present(alert, animated: true, completion: nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            self.handleResponse(data: data, response: response, error: error)
        }.resume()
    }
    
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?) {
        do {
            if let _ = error {
                throw AnimalAPIError.OtherError
            }
            guard let _ = response else {
                throw AnimalAPIError.NoResponse
            }
            guard let data = data else {
                throw AnimalAPIError.NoData
            }
            guard let results = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: AnyObject]] else {
                throw AnimalAPIError.CouldNotParse
            }
            parse(results)
        } catch AnimalAPIError.NoData {
            showError("Could not handle response")
        } catch AnimalAPIError.NoResponse {
            showError("No response received")
        } catch AnimalAPIError.CouldNotParse {
            showError("Could not parse response")
        } catch AnimalAPIError.OtherError {
            showError("Received server error")
        } catch {
            showError("Unknown error")
        }
    }
    
    private func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
            alert.addOKButton(nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func parse(_ results: [[String: AnyObject]]) {
        loadedAnimals = [Animal]()
        for result in results {
            if let animal = Animal.init(json: result) {
                loadedAnimals.append(animal)
            }
        }
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    @IBAction private func getAnimalsButtonTapped() {
        makeRequest()
    }
    
    @IBAction private func makeSampleRequest() {
        loadedAnimals = [Animal]()
        let firstAnimal = Animal.init(animalID: 1, photoURL: "https://img.buzzfeed.com/buzzfeed-static/static/2014-04/enhanced/webdr02/9/12/enhanced-buzz-11844-1397060009-22.jpg?no-auto", looksFriendly: true, plural: true, type: Animal.AnimalType.Cat)
        let secondAnimal = Animal.init(animalID: 2, photoURL: "http://static.boredpanda.com/blog/wp-content/uploads/2016/09/mother-bear-cubs-animal-parenting-21-57e3a2161d7f7__880.jpg", looksFriendly: true, plural: true, type: Animal.AnimalType.Bear)
        let thirdAnimal = Animal.init(animalID: 3, photoURL: "https://img.buzzfeed.com/buzzfeed-static/static/2014-04/enhanced/webdr07/9/14/enhanced-18799-1397069418-11.jpg?no-auto", looksFriendly: false, plural: false, type: Animal.AnimalType.Cat)
        let fourthAnimal = Animal.init(animalID: 4, photoURL: "https://i.imgur.com/AOJJDhu.jpg", looksFriendly: true, plural: false, type: Animal.AnimalType.Bear)
        loadedAnimals.append(firstAnimal)
        loadedAnimals.append(secondAnimal)
        loadedAnimals.append(thirdAnimal)
        loadedAnimals.append(fourthAnimal)
        collectionView?.reloadData()
    }
}

// MARK: Datasource
extension ViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loadedAnimals.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "animalCell", for: indexPath) as! AnimalCell
        let animal = loadedAnimals[indexPath.item]
        cell.backgroundColor = UIColor.lightGray
        cell.friendlyLabel.text = animal.looksFriendly ? "Yes :)" : "No :("
        cell.pluralLabel.text = animal.plural ? "Yes" : "No"
        cell.animalIDLabel.text = String(animal.animalID)
        animal.loadImage { animal, error in
            if let data = animal.loadedImageData {
                cell.imageView.image = UIImage(data: data)
            }
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
