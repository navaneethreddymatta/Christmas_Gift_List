//
//  ChristamasListTableViewController.swift
//  FinalApp
//
//  Created by student on 8/9/16.
//  Copyright © 2016 MNR_iOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ChristamasListTableViewController: UITableViewController {
    let currentUser = FIRAuth.auth()?.currentUser
    let ref = FIRDatabase.database().reference()
    var peopleList = [Person]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData() {
        ref.child("Users").child((currentUser?.uid)!).child("People").observeEventType(.Value, withBlock: { (snapshot) in
            self.peopleList.removeAll()
            let enumerator = snapshot.children
            while let personObj = enumerator.nextObject() as? FIRDataSnapshot {
                let personName = personObj.value!["name"] as? String
                let personImage = personObj.value!["profileImage"] as? String
                let allocatedBudget = personObj.value!["budgetAllocated"] as? Double
                let usedBudget = personObj.value!["budgetUsed"] as? Double
                let keyVal = personObj.key
                let newPersonObj = Person(name: personName!, image: personImage!, allocatedBudget: allocatedBudget!, usedBudget: usedBudget!, key: keyVal)
                self.peopleList.append(newPersonObj)
            }
            self.tableView.reloadData()
        })
    }

    @IBAction func logoutUser(sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : UIViewController = storyboard.instantiateViewControllerWithIdentifier("SignInStoryBoard") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("christmasListIdentifier", forIndexPath: indexPath) as? ChristmasListTableViewCell
        cell!.thisPerson = peopleList[indexPath.row]
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = self.tableView.indexPathForSelectedRow
        if let destVC = segue.destinationViewController as? MyGiftsTableViewController {
            destVC.thisPerson = peopleList[indexPath!.row]
            destVC.navigationItem.title = peopleList[indexPath!.row].name
        }
    }
    
}

struct Person {
    var name: String
    var image: String
    var allocatedBudget: Double
    var usedBudget: Double
    var key: String
}
