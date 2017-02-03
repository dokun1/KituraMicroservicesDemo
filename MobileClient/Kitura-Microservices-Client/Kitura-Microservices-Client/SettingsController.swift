//
//  SettingsController.swift
//  Kitura-Microservices-Client
//
//  Created by David Okun IBM on 1/24/17.
//  Copyright © 2017 David Okun IBM. All rights reserved.
//

import UIKit

public struct DefaultQueryOptions {
    static let hostURLDefaultKey = "com.ibm.cloud.kituraAnimalsDemo.hostURLKey"
    static let animalChoiceDefaultKey = "com.ibm.cloud.kituraAnimalsDemo.animalChoiceKey"
    static let friendlyChoiceDefaultKey = "com.ibm.cloud.kituraAnimalsDemo.friendlyChoiceKey"
    static let pluralChoiceDefaultKey = "com.ibm.cloud.kituraAnimalsDemo.pluralChoiceKey"
    
    static let animalsBearsOnly = AnimalConstants.bear
    static let animalsCatsOnly = AnimalConstants.cat
    static let animalsAll = "all"
    
    static let friendlyAnimalsOnly = "true"
    static let unfriendlyAnimalsOnly = "false"
    static let allFriendlyAnimals = "all"

    static let pluralAnimalsOnly = "true"
    static let singleAnimalsOnly = "false"
    static let allNumberedAnimals = "all"
}

final class SettingsController: UIViewController {
    @IBOutlet weak var hostTextField: UITextField!
    @IBOutlet weak var animalChoiceControl: UISegmentedControl!
    @IBOutlet weak var friendlyChoiceControl: UISegmentedControl!
    @IBOutlet weak var pluralChoiceControl: UISegmentedControl!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDefaults()
    }
    
    @IBAction fileprivate func segmentedControlValueChanged() {
        saveDefaults()
    }
    
    fileprivate func loadDefaults() {
        let defaults = UserDefaults.standard
        self.hostTextField.text = defaults.string(forKey: DefaultQueryOptions.hostURLDefaultKey)
        
        if let animalChoiceString = defaults.string(forKey: DefaultQueryOptions.animalChoiceDefaultKey) {
            if animalChoiceString == DefaultQueryOptions.animalsCatsOnly {
                animalChoiceControl.selectedSegmentIndex = 0
            } else if animalChoiceString == DefaultQueryOptions.animalsBearsOnly {
                animalChoiceControl.selectedSegmentIndex = 1
            } else {
                animalChoiceControl.selectedSegmentIndex = 2
            }
        } else {
            animalChoiceControl.selectedSegmentIndex = 2
        }
        
        if let friendlyChoiceString = defaults.string(forKey: DefaultQueryOptions.friendlyChoiceDefaultKey) {
            if friendlyChoiceString == DefaultQueryOptions.friendlyAnimalsOnly {
                friendlyChoiceControl.selectedSegmentIndex = 0
            } else if friendlyChoiceString == DefaultQueryOptions.unfriendlyAnimalsOnly {
                friendlyChoiceControl.selectedSegmentIndex = 1
            } else {
                friendlyChoiceControl.selectedSegmentIndex = 2
            }
        } else {
            friendlyChoiceControl.selectedSegmentIndex = 2
        }
        
        if let pluralChoiceString = defaults.string(forKey: DefaultQueryOptions.pluralChoiceDefaultKey) {
            if pluralChoiceString == DefaultQueryOptions.singleAnimalsOnly {
                pluralChoiceControl.selectedSegmentIndex = 0
            } else if pluralChoiceString == DefaultQueryOptions.pluralAnimalsOnly {
                pluralChoiceControl.selectedSegmentIndex = 1
            } else {
                pluralChoiceControl.selectedSegmentIndex = 2
            }
        } else {
            pluralChoiceControl.selectedSegmentIndex = 2
        }
        
    }
    
    fileprivate func saveDefaults() {
        let defaults = UserDefaults.standard
        guard let hostText = self.hostTextField.text else {
            return;
        }
        defaults.set(hostText, forKey: DefaultQueryOptions.hostURLDefaultKey)
        
        switch animalChoiceControl.selectedSegmentIndex {
            case 0:
                defaults.set(DefaultQueryOptions.animalsCatsOnly, forKey: DefaultQueryOptions.animalChoiceDefaultKey)
                break
            case 1:
                defaults.set(DefaultQueryOptions.animalsBearsOnly, forKey: DefaultQueryOptions.animalChoiceDefaultKey)
                break
            default:
                defaults.set(DefaultQueryOptions.animalsAll, forKey: DefaultQueryOptions.animalChoiceDefaultKey)
                break
        }
        
        switch friendlyChoiceControl.selectedSegmentIndex {
        case 0:
            defaults.set(DefaultQueryOptions.friendlyAnimalsOnly, forKey: DefaultQueryOptions.friendlyChoiceDefaultKey)
            break
        case 1:
            defaults.set(DefaultQueryOptions.unfriendlyAnimalsOnly, forKey: DefaultQueryOptions.friendlyChoiceDefaultKey)
            break
        default:
            defaults.set(DefaultQueryOptions.allFriendlyAnimals, forKey: DefaultQueryOptions.friendlyChoiceDefaultKey)
            break
        }
        
        switch pluralChoiceControl.selectedSegmentIndex {
        case 0:
            defaults.set(DefaultQueryOptions.singleAnimalsOnly, forKey: DefaultQueryOptions.pluralChoiceDefaultKey)
            break
        case 1:
            defaults.set(DefaultQueryOptions.pluralAnimalsOnly, forKey: DefaultQueryOptions.pluralChoiceDefaultKey)
            break
        default:
            defaults.set(DefaultQueryOptions.allNumberedAnimals, forKey: DefaultQueryOptions.pluralChoiceDefaultKey)
            break
        }
        
        defaults.synchronize()
    }
}

extension SettingsController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveDefaults()
        textField.resignFirstResponder()
        return true
    }
}
