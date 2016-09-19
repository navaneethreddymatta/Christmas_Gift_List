//
//  SignUpViewController.swift
//  FinalApp
//
//  Created by student on 8/9/16.
//  Copyright © 2016 MNR_iOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBAction func cancelUserCreation(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func submitUserCreation(sender: UIButton) {
        let fName = firstName.text
        let lName = lastName.text
        let emailID = email.text
        let password = passwordField.text
        let confirmPassword = confirmPasswordField.text
        if fName == nil || fName == "" || lName == nil || lName == "" || emailID == nil || emailID == "" || password == nil || password == "" || confirmPassword == nil || confirmPassword == "" {
            let alert = UIAlertController(title: "Alert", message: "Enter Your Details", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if password != confirmPassword {
            let alert = UIAlertController(title: "Alert", message: "Passwords do not match", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.createUserWithEmail(emailID!, password: password!, completion: { (newUser, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    let ref = FIRDatabase.database().reference()
                    ref.child("Users").child((newUser?.uid)!).setValue(["firstName": fName!,"lastName": lName!,"email": emailID!,"password": password!])
                    // --------- login from here --------------
                    FIRAuth.auth()?.signInWithEmail(emailID!, password: password!, completion: { (newUser, error) in
                        if error != nil {
                            let alert = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                            alert.addAction(action)
                            self.presentViewController(alert, animated: true, completion: nil)
                        } else {
                            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc : UIViewController = storyboard.instantiateViewControllerWithIdentifier("ChristmasListStoryBoard") as UIViewController
                            self.presentViewController(vc, animated: true, completion: nil)
                        }
                    })
                    
                }
            })
        }
    }
}
