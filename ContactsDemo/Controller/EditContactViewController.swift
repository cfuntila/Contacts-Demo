//
//  EditContactViewController.swift
//  ContactsDemo
//
//  Created by Charity Funtila on 1/16/23.
//

import UIKit

class EditContactViewController: UIViewController, UITextFieldDelegate {
    
    var contact: Contact?

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadContactInformation()
    }
    
    func loadContactInformation() {
        guard var contact = contact else {
            return
        }
        
        nameTextField.text = contact.name
        
        if let phoneNumber = contact.phoneNumber {
            phoneTextField.text = phoneNumber
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == K.backToDetailsSegue {
//            let destinationVC = segue.destination as! ContactDetailsViewController
//            destinationVC.contact = contact
//        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
//        guard let contact = contact else {
//            return
//        }
//
//        contact.name = nameTextField.text
//        contact.phoneNumber = phoneTextField.text
        
        guard let currentlySelectedContact = currentlySelectedContact else {
            return
        }
        
        currentlySelectedContact.name = nameTextField.text
        currentlySelectedContact.phoneNumber = phoneTextField.text
        
        saveContacts()
        
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
//        performSegue(withIdentifier: K.backToDetailsSegue, sender: self)
    }
    
    func saveContacts() {
       do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }

}
