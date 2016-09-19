//
//  ChristmasListTableViewCell.swift
//  FinalApp
//
//  Created by student on 8/9/16.
//  Copyright © 2016 MNR_iOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ChristmasListTableViewCell: UITableViewCell {
    let currentUser = FIRAuth.auth()?.currentUser
    let ref = FIRDatabase.database().reference()
    var thisPerson:Person? {
        didSet {
            personName.text = thisPerson?.name
            usedBudgetVal.text = "$" + String((thisPerson?.usedBudget)!)
            allocatedBudgetVal.text = "$" + String((thisPerson?.allocatedBudget)!)
            if thisPerson?.usedBudget < thisPerson?.allocatedBudget {
                usedBudgetVal.textColor = UIColor.greenColor()
            }
            print(thisPerson!.key)
            ref.child("Users").child((currentUser?.uid)!).child("People").child(thisPerson!.key).child("Gifts").observeEventType(.Value, withBlock: { (snapshot) in
                let enumerator = snapshot.children
                var cnt = 0
                while (enumerator.nextObject() as? FIRDataSnapshot) != nil {
                    cnt += 1
                }
                self.numGiftsBought.text = String(cnt) + " gifts bought"
            })
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBOutlet weak var personImage: UIImageView!
    
    @IBOutlet weak var personName: UILabel!
    
    @IBOutlet weak var numGiftsBought: UILabel!
    
    @IBOutlet weak var usedBudgetVal: UILabel!
    
    @IBOutlet weak var allocatedBudgetVal: UILabel!
}

extension Double {
    var cleanValue: String {
        return self % 1 == 0 ? String(format: "%.0f", self) : String(self)
    }
}
