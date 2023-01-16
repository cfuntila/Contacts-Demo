//
//  Constants.swift
//  ContactsDemo
//
//  Created by Charity Funtila on 1/13/23.
//

import Foundation

struct K {
    static let appName = "ContactsDemo"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "ContactCell"
    static let detailsSegue = "goToContact"
    static let addNewContact = "Add New Contact"
    static let duplicatesSegue = "goToDuplicates"
    static let editContactSegue = "goToEdit"
    
    struct FStore {
        static let collectionName = "contacts"
        static let nameField = "name"
    }
}
