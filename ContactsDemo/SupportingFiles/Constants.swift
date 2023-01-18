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
    
    static let duplicateFoundCellIdentifier = "DuplicateFoundReusableCell"
    static let duplicateFoundCellNibName = "DuplicateFoundCell"
   
    static let addNewContact = "Enter name"
    static let addPhoneNumber = "Enter phone number"
    
    static let detailsSegue = "goToContact"
    static let duplicatesSegue = "goToDuplicates"
    static let editContactSegue = "goToEdit"
    static let backToDetailsSegue = "goBackToDetails"
    static let createContactSegue = "goToCreateContact"
    static let duplicateDetailsSegue = "goToDuplicateDetails"
    
    static let mobile = "mobile"
    static let editTitle = "Edit"
    static let newContactTitle = "New Contact"
    static let cancelButtonTitle = "< Cancel"
}
