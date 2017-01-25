//
//  SettingsController.swift
//  Kitura-Microservices-Client
//
//  Created by David Okun IBM on 1/24/17.
//  Copyright © 2017 David Okun IBM. All rights reserved.
//

import UIKit

public struct DefaultQueryOptions {
    static let hostURLDefaultKey = "com.ibm.cloud.kituraDemo.hostURLKey"
    static let animalChoiceDefaultKey = "com.ibm.cloud.kituraDemo.animalChoiceKey"
    static let friendlyChoiceDefaultKey = "com.ibm.cloud.kituraDemo.friendlyChoiceKey"
    static let pluralChoiceDefaultKey = "com.ibm.cloud.kituraDemo.pluralChoiceKey"
    
    static let animalsBearsOnlyDefault = "com.ibm.cloud.kituraDemo.pluralChoiceKey"
}

class SettingsController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
