//
//  ContactDetailsViewController.swift
//  ContactsDemo
//
//  Created by Charity Funtila on 1/15/23.
//

import UIKit

class ContactDetailsViewController: UIViewController {

    @IBOutlet weak var firstName: UILabel!

    var contact: Contact?
    
    @IBOutlet weak var phoneNumberButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContactInformation()
    }
    
    func loadContactInformation() {
        guard let contact = contact else {
            return
        }
        
        guard let currentlySelectedContact = currentlySelectedContact else {
            return
        }
        
//        firstName.text = contact.name
        firstName.text = currentlySelectedContact.name
        print(contact.phoneNumber)
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.tinted()

            config.title = K.mobile

//            if let phoneNumber = contact.phoneNumber {
//                print(phoneNumber)
//                config.subtitle = phoneNumber
//            } else {
//                config.subtitle = ""
//            }
            
            if let phoneNumber = currentlySelectedContact.phoneNumber {
                print(phoneNumber)
                config.subtitle = phoneNumber
            } else {
                config.subtitle = ""
            }

            phoneNumberButton.configuration = config

        }
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        print("Edit was pressed")
        performSegue(withIdentifier: K.editContactSegue, sender: self)
    }
    
    @IBAction func callButtonPressed(_ sender: UIButton) {
        if #available(iOS 15.0, *) {
            if let phoneNumber = phoneNumberButton.subtitleLabel?.text {
                //callNumber(phoneNumber: phoneNumber)
            }
        }
    }
    private func callNumber(phoneNumber:String) {
      if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
      }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadContactInformation()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.editContactSegue {
            let destinationVC = segue.destination as! EditContactViewController
            destinationVC.contact = contact
        }
    }

}
