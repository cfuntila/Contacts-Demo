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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.text = (contact != nil) ? contact?.name : ""
    }
    

    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        print("Edit was pressed")
        performSegue(withIdentifier: K.editContactSegue, sender: self)
    }

}
