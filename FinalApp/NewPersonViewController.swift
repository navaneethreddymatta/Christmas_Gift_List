//
//  NewPersonViewController.swift
//  FinalApp
//
//  Created by student on 8/9/16.
//  Copyright © 2016 MNR_iOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class NewPersonViewController: UIViewController {
    let currentUser = FIRAuth.auth()?.currentUser
    let personImage = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var personImageField: UIImageView!
    
    @IBOutlet weak var personNameField: UITextField!
    
    @IBOutlet weak var budgetField: UITextField!
    
    @IBAction func cancelPersonCreation(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func submitPersonCreation(sender: AnyObject) {
        let name = personNameField.text
        let budget = budgetField.text
        
        if name == nil || name == "" || budget == nil || budget == "" {
            let alertController = UIAlertController(title: "Alert", message: "Enter The Details", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alertController.addAction(action)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else if let budgetVal = Double(budget!) {
            let ref = FIRDatabase.database().reference()
            ref.child("Users").child((currentUser?.uid)!).child("People").childByAutoId().setValue(["name":name!,"budgetAllocated":budgetVal,"budgetUsed":0,"profileImage":personImage])
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("ChristmasListStoryBoard")
            self.presentViewController(vc, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Alert", message: "Enter Valid Budget", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alertController.addAction(action)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
