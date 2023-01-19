//
//  MergeDuplicatesViewController.swift
//  ContactsDemo
//
//  Created by Charity Funtila on 1/17/23.
//

import UIKit

protocol MergeDuplicatePairDelegate {
    func didMerge(contact: Contact)
}

class MergeDuplicatesViewController: UIViewController {
    
    var mergeDuplicateDelegate: MergeDuplicatePairDelegate!

    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var firstDetailsNameLabel: UILabel!
    @IBOutlet weak var firstDetailsNumberLabel: UILabel!
    @IBOutlet weak var secondDetailsNameLabel: UILabel!
    @IBOutlet weak var secondDetailsNumberLabel: UILabel!
    
    var pairOfContacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContactInformation()
    }
    
    func loadContactInformation() {
        let firstContact = pairOfContacts[0]
        titleNameLabel.text = firstContact.name
        firstDetailsNameLabel.text = firstContact.name
        
        if let phoneNumber = firstContact.phoneNumber {
            firstDetailsNumberLabel.text = phoneNumber
        } else {
            firstDetailsNumberLabel.text = ""
        }
        
        let secondContact = pairOfContacts[1]
        titleNameLabel.text = secondContact.name
        secondDetailsNameLabel.text = secondContact.name
        
        if let phoneNumber = secondContact.phoneNumber {
            secondDetailsNumberLabel.text = phoneNumber
        } else {
            secondDetailsNumberLabel.text = ""
        }
    }
    
    @IBAction func mergeButtonPressed(_ sender: UIButton) {
        mergeDuplicateDelegate.didMerge(contact: pairOfContacts[0])
        dismiss(animated: true)
    }

}
