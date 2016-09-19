//
//  AllGiftsTableViewController.swift
//  FinalApp
//
//  Created by student on 8/9/16.
//  Copyright © 2016 MNR_iOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AllGiftsTableViewController: UITableViewController {
    let currentUser = FIRAuth.auth()?.currentUser
    var thisPerson:Person?
    let ref = FIRDatabase.database().reference()
    var giftsList = [Gift]()
    var balanaceBudget:Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData() {
        ref.child("gifts").observeEventType(.Value, withBlock: { (snapshot) in
            self.giftsList.removeAll()
            let enumerator = snapshot.children
            while let giftObj = enumerator.nextObject() as? FIRDataSnapshot {
                let price = giftObj.value!["price"] as? Double
                if self.balanaceBudget >= price {
                    let giftName = giftObj.value!["name"] as? String
                    let giftImage = giftObj.value!["url"] as? String
                    let giftPrice = giftObj.value!["price"] as? Double
                    let newGiftObj = Gift(name: giftName!, price: giftPrice!, imageUrl: giftImage!)
                    self.giftsList.append(newGiftObj)
                }
            }
            self.tableView.reloadData()
        })
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return giftsList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AllGiftsIdentifier", forIndexPath: indexPath) as? AllGiftsTableViewCell
        cell!.giftObj = self.giftsList[indexPath.row]
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedGift = giftsList[indexPath.row]
        ref.child("Users").child((currentUser?.uid)!).child("People").child(thisPerson!.key).child("Gifts").childByAutoId().setValue(["name":selectedGift.name, "price":selectedGift.price, "url":selectedGift.imageUrl]) { (error, dbRef) in
            self.ref.child("Users").child((self.currentUser?.uid)!).child("People").child(self.thisPerson!.key).observeEventType(.Value, withBlock: { (snapshot) in
                var bdUsed = snapshot.value!["budgetUsed"] as? Double
                bdUsed = bdUsed! + selectedGift.price
                print(bdUsed)
                //self.ref.child("Users").child((self.currentUser?.uid)!).child("People").child(self.thisPerson!.key).child("budgetUsed").setValue(bdUsed)
            })
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelGiftSelection(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

struct Gift {
    var name:String
    var price:Double
    var imageUrl: String
}
