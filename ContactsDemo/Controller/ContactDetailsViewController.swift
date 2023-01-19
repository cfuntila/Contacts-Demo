//
//  ContactDetailsViewController.swift
//  ContactsDemo
//
//  Created by Charity Funtila on 1/15/23.
//

import UIKit

class ContactDetailsViewController: UIViewController {
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var phoneNumberButton: UIButton!
    
    var contact: Contact?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContactInformation()
    }
    
    func loadContactInformation() {
        guard let currentlySelectedContact = currentlySelectedContact else {
            return
        }
        
        firstName.text = currentlySelectedContact.name
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.tinted()

            config.title = K.mobile
            
            if let phoneNumber = currentlySelectedContact.phoneNumber {
                config.subtitle = phoneNumber
            } else {
                config.subtitle = ""
            }

            phoneNumberButton.configuration = config
        }
        
        if let company = currentlySelectedContact.company {
            companyLabel.text = company
        }
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.editContactSegue, sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadContactInformation()
    }
}
