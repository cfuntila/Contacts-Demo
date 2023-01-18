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
    
    var pairOfContacts: [Contact] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadContactInformation()
        // Do any additional setup after loading the view.
    }
    
    func loadContactInformation() {
        let firstContact = pairOfContacts[0]
        titleNameLabel.text = firstContact.name
        firstDetailsNameLabel.text = firstContact.name
        
        if let phoneNumber = firstContact.phoneNumber {
            firstDetailsNumberLabel.text = phoneNumber
        }
        
        let secondContact = pairOfContacts[1]
        titleNameLabel.text = secondContact.name
        firstDetailsNameLabel.text = secondContact.name
        
        if let phoneNumber = secondContact.phoneNumber {
            firstDetailsNumberLabel.text = phoneNumber
        }
    }
    
    @IBAction func mergeButtonPressed(_ sender: UIButton) {
//        context.delete(pairOfContacts[0])
        mergeDuplicateDelegate.didMerge(contact: pairOfContacts[0])
        dismiss(animated: true)
    }

}
