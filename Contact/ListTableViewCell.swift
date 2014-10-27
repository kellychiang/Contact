//
//  ListTableViewCell.swift
//  Contact
//
//  Created by kelly on 2014/10/17.
//  Copyright (c) 2014年 kelly. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel! = UILabel ()
    @IBOutlet weak var titleLabel: UILabel! = UILabel ()
    @IBOutlet weak var dueLabel: UILabel! = UILabel ()
    @IBOutlet weak var callButton: UIButton! = UIButton ()
    @IBOutlet weak var textButton: UIButton! = UIButton ()
    @IBOutlet weak var mailButton: UIButton! = UIButton ()
    @IBOutlet weak var contactImageView: UIImageView! = UIImageView ()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
