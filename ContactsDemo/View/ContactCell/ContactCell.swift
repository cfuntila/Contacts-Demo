//
//  ContactCell.swift
//  ContactsDemo
//
//  Created by Charity Funtila on 1/13/23.
//

import Foundation

import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var contactLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
