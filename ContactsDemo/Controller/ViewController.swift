//
//  ViewController.swift
//  ContactsDemo
//
//  Created by Charity Funtila on 1/13/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var contacts = [Contact]()
    var selectedContact: Contact? = nil
    @IBOutlet weak var duplicatesFoundView: DuplicatesFoundView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Contacts.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        duplicatesFoundView.delegate = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil) , forCellReuseIdentifier: K.cellIdentifier )
        
        let numOfDuplicates = getNumOfDuplicates()
        if numOfDuplicates > 0 {
            duplicatesFoundView.isHidden = false
            let plural = numOfDuplicates > 1 ? "s":""
            duplicatesFoundView.titleLabel.text = "\(numOfDuplicates) Duplicate\(plural) Found"
        }
        
        loadContacts()
    }

//MARK: - Add New Contact
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: K.addNewContact, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text?.count ?? Int.min > 0 {
                let newContact = Contact(context: self.context)
                newContact.name = textField.text!
//                newContact.parentCategory = self.selectedCategory
                self.contacts.append(newContact)
                self.saveContacts()
            }
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = K.addNewContact
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Model Manupulation Methods
    func saveContacts() {
       do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadContacts() {
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        handleRequest(request)
        tableView.reloadData()
    }
    
    func deleteContact(at row: Int) {
        context.delete(contacts[row])
        contacts.remove(at: row)
        saveContacts()
    }
    
    func handleRequest(_ request: NSFetchRequest<Contact>) {
        do {
            contacts = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    func getNumOfDuplicates() -> Int {
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", "hannah")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        var duplicates = [Contact]()
        do {
            duplicates = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        return duplicates.count + 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.detailsSegue {
            let destinationVC = segue.destination as! ContactDetailsViewController
            if let selectedContact = selectedContact {
                destinationVC.contact = selectedContact
            }
            
        }
    }
    
}

//MARK: - Table View Delegate Methods
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        selectedContact = contacts[row]
        performSegue(withIdentifier: K.detailsSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let contact = contacts[indexPath.row]

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in

            // Create an action for sharing
            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
                print("Sharing \(contact)")
            }
            
            // Create an action for sharing
            let delete = UIAction(title: "Delete Contact", image: UIImage(systemName: "trash")) { action in
                print("Deleting \(contact)")
                self.deleteContact(at: indexPath.row)
            }

            // Create other actions...

            return UIMenu(title: "", children: [share, delete])
        }
    }
}

//MARK: - Table View Data Source Methods
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ContactCell
        let contact = contacts[indexPath.row]
        cell.contactLabel.text = contact.name
        return cell
    }
}

//MARK: Search Bar Delegate Methods
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        handleRequest(request)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadContacts()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

//MARK: Duplicates View Delegate Methods
extension ViewController: DuplicatesFoundViewProtocol {
    func viewDuplicatesButtonPressed() {
        performSegue(withIdentifier: K.duplicatesSegue, sender: self)
    }
}
