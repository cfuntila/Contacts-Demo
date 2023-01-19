//
//  EditContactViewController.swift
//  ContactsDemo
//
//  Created by Charity Funtila on 1/16/23.
//

import UIKit

class EditContactViewController: UIViewController {
    
    var isNewContact: Bool = false

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: K.cancelButtonTitle, style: .done, target: self, action:  #selector(self.popView))
        
        if isNewContact == false {
            self.title = K.editTitle
            loadContactInformation()
        } else {
            self.title = K.newContactTitle
        }
        
    }
    
    func createNewContact() -> Contact {
        let newContact = Contact(context: self.context)
        
        if let name = nameTextField.text {
            newContact.name = name
        }
        
        if let phoneNumberString = phoneTextField.text {
            if phoneNumberString.count > 0 {
                newContact.phoneNumber = phoneNumberString
            }
        }
        
        if let companyString = companyTextField.text {
            if companyString.count > 0 {
                newContact.company = companyString
            }
        }

        return newContact
    }
    
    @objc
    func popView() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func loadContactInformation() {
        guard let contact = currentlySelectedContact else {
            return
        }
        
        nameTextField.text = contact.name
        doneButton.isEnabled = true
        if let phoneNumber = contact.phoneNumber {
            phoneTextField.text = phoneNumber
        }
        
        if let company = contact.company {
            companyTextField.text = company
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        if isNewContact == false {
            guard let currentlySelectedContact = currentlySelectedContact else {
                return
            }

            currentlySelectedContact.name = nameTextField.text
            currentlySelectedContact.phoneNumber = phoneTextField.text
            currentlySelectedContact.company = companyTextField.text
            
            saveContacts()
            
        } else {
            let newContact = self.createNewContact()
            saveContacts()
            isNewContact = false
        }
        
        popView()
    }
    
    func saveContacts() {
       do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
}

extension EditContactViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = (nameTextField.text as? NSString)?.replacingCharacters(in: range, with: string) {
            if !text.isEmpty{
                doneButton.isEnabled = true
            } else {
                doneButton.isEnabled = false
            }
        }
        return true
    }
}
