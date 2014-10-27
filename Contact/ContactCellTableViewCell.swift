//
//  ContactCellTableViewCell.swift
//  Contact
//
//  Created by kelly on 2014/10/17.
//  Copyright (c) 2014年 kelly. All rights reserved.
//

import UIKit

class ContactCellTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel! = UILabel ()
    @IBOutlet weak var phoneLabel: UILabel! = UILabel ()
    @IBOutlet weak var emailLabel: UILabel! = UILabel ()
    @IBOutlet weak var contactImageview: UIImageView! = UIImageView ()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
