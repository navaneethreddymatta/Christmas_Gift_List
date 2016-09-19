//
//  MyGiftsTableViewController.swift
//  FinalApp
//
//  Created by student on 8/9/16.
//  Copyright © 2016 MNR_iOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MyGiftsTableViewController: UITableViewController {
    var thisPerson:Person?
    let currentUser = FIRAuth.auth()?.currentUser
    let ref = FIRDatabase.database().reference()
    var myGiftsList = [Gift]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.ref.child("Users").child((self.currentUser?.uid)!).child("People").child(self.thisPerson!.key).observeEventType(.Value, withBlock: { (snapshot) in
            let bdtUsed = snapshot.value!["budgetUsed"] as? Double
            let newPersonObj = Person(name: (self.thisPerson?.name)!, image: (self.thisPerson?.image)!, allocatedBudget: (self.thisPerson?.allocatedBudget)!, usedBudget: bdtUsed!, key: self.thisPerson!.key)
            self.thisPerson = newPersonObj
        })
    }

    func fetchData() {
        ref.child("Users").child((currentUser?.uid)!).child("People").child(thisPerson!.key).child("Gifts").observeEventType(.Value, withBlock: { (snapshot) in
            self.myGiftsList.removeAll()
            let enumerator = snapshot.children
            while let giftObj = enumerator.nextObject() as? FIRDataSnapshot {
                let giftName = giftObj.value!["name"] as? String
                let giftImage = giftObj.value!["url"] as? String
                let giftPrice = giftObj.value!["price"] as? Double
                let newGiftObj = Gift(name: giftName!, price: giftPrice!, imageUrl: giftImage!)
                self.myGiftsList.append(newGiftObj)
            }
            self.tableView.reloadData()
        })
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGiftsList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AllGiftsIdentifier", forIndexPath: indexPath) as? MyGiftsTableViewCell
        cell!.giftObj = self.myGiftsList[indexPath.row]
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let balanceBudget = (thisPerson?.allocatedBudget)! - (thisPerson?.usedBudget)!
        if let destVC = segue.destinationViewController as? AllGiftsTableViewController {
            destVC.balanaceBudget = balanceBudget
            destVC.thisPerson = thisPerson
        }
    }
}
