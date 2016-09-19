//
//  MyGiftsTableViewCell.swift
//  FinalApp
//
//  Created by student on 8/9/16.
//  Copyright © 2016 MNR_iOS. All rights reserved.
//

import UIKit
import SDWebImage

class MyGiftsTableViewCell: UITableViewCell {
    var giftObj: Gift? {
        didSet {
            giftName.text = giftObj?.name
            giftPrice.text = "$" + String((giftObj?.price)!)
            let imgURL = NSURL(string: "\((giftObj?.imageUrl)!)")
            giftImage.sd_setImageWithURL(imgURL!)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var giftImage: UIImageView!
    
    @IBOutlet weak var giftName: UILabel!
    
    @IBOutlet weak var giftPrice: UILabel!

}
