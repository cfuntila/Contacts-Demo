//
//  ViewController.swift
//  ContactsDemo
//
//  Created by Charity Funtila on 1/13/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var duplicatesFoundView: DuplicatesFoundView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var contacts = [Contact]()
    var duplicates: [String: [Contact]] = [:]
    var selectedContact: Contact? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        duplicatesFoundView.delegate = self
        
        duplicatesFoundView.layer.cornerRadius = duplicatesFoundView.frame.size.height/2
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil) , forCellReuseIdentifier: K.cellIdentifier )
        
        loadAllData()
    }
    
    func loadAllData() {
        loadContacts()
        loadDuplicates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAllData()
    }
    
    //MARK: - Duplicate Contacts Methods
    func loadDuplicates() {
        for contact in contacts {
            if let currName = contact.name {
                if let dupes = duplicates[currName] {
                    if dupes.count < 2 {
                        duplicates[currName]?.append(contact)
                    }
               } else {
                   duplicates[currName] = [contact]
               }
            }
        }
        
        for (key, value) in duplicates {
            if value.count < 2 {
                duplicates[key] = nil
            }
        }
        
        updateDuplicatesFoundView()
    }
    
    func printDupes() {
        print("===== DUPLICATES =====")
        print()
        print(duplicates)
        print()
    }
    
    func updateDuplicatesFoundView() {
        let numOfDuplicates = duplicates.count
        if numOfDuplicates > 0 {
            duplicatesFoundView.isHidden = false
            let plural = numOfDuplicates > 1 ? "s":""
            duplicatesFoundView.titleLabel.text = "\(numOfDuplicates) Duplicate\(plural) Found"
        } else {
            duplicatesFoundView.isHidden = true
        }
    }

    //MARK: - Add New Contact
    func addUsingView() {
        performSegue(withIdentifier: K.createContactSegue, sender: self)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        addUsingView()
    }
    
    //MARK: Model Manupulation Methods
    func saveContacts() {
       do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
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
            contacts = contacts.sorted { $0.name!.lowercased() < $1.name!.lowercased() }
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    //MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.detailsSegue {
            let destinationVC = segue.destination as! ContactDetailsViewController
//            if let selectedContact = selectedContact {
//                destinationVC.contact = selectedContact
//            }
        } else if segue.identifier == K.duplicatesSegue {
            let destinationVC = segue.destination as! DuplicatesFoundViewController
            destinationVC.mergeDelegate = self
            destinationVC.duplicates = duplicates
        } else if segue.identifier == K.createContactSegue {
            let destinationVC = segue.destination as! EditContactViewController
            destinationVC.isNewContact = true
        }
    }
    
    func findRowFor(value: Contact) -> Int {
        for i in 0..<contacts.count {
            let contact = contacts[i]
            if contact == value {
                return i
            }
        }
        return -1
    }
    
}



//MARK: - Merge Contact Delegate Methods
extension ViewController: MergeContactDelegate {
    func userDidMerge(_ contact: Contact) {
        duplicates.removeValue(forKey: contact.name!)
        let rowToDelete = findRowFor(value: contact)
        if rowToDelete >= 0 {
            deleteContact(at: rowToDelete)
            loadAllData()
        }
    }
}

//MARK: - Table View Delegate Methods
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        selectedContact = contacts[row]
        currentlySelectedContact = contacts[row]
        performSegue(withIdentifier: K.detailsSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let contact = contacts[indexPath.row]

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in

            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
                print("Sharing \(contact)")
            }
            
            let delete = UIAction(title: "Delete Contact", image: UIImage(systemName: "trash")) { action in
                print("Deleting \(contact)")
                self.deleteContact(at: indexPath.row)
                self.loadAllData()
            }

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
