//
//  DuplicatesFoundViewController.swift
//  ContactsDemo
//
//  Created by Charity Funtila on 1/16/23.
//

import UIKit

protocol MergeContactDelegate {
    func userDidMerge(_ contact: Contact)
}

class DuplicatesFoundViewController: UIViewController {
    var mergeDelegate: MergeContactDelegate!
    var duplicates: [String: [Contact]] = [:]
    
    var keysArray: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedPair: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.duplicateFoundCellNibName, bundle: nil) , forCellReuseIdentifier: K.duplicateFoundCellIdentifier )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.duplicateDetailsSegue {
            let destinationVC = segue.destination as! MergeDuplicatesViewController
            destinationVC.mergeDuplicateDelegate = self
            destinationVC.pairOfContacts = selectedPair
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

        
        }
}

extension DuplicatesFoundViewController: MergeDuplicatePairDelegate {
    func didMerge(contact: Contact) {
        duplicates.removeValue(forKey: contact.name!)
        tableView.reloadData()
        mergeDelegate.userDidMerge(contact)
    }
}

extension DuplicatesFoundViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        print("selected a cell in dupes found!")
        
        let currentKey = keysArray[indexPath.row]
        selectedPair = duplicates[currentKey] as! [Contact]
        performSegue(withIdentifier: K.duplicateDetailsSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DuplicatesFoundViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return duplicates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.duplicateFoundCellIdentifier, for: indexPath) as! DuplicateFoundCell
        
        keysArray = Array(duplicates.keys)
        let currentKey = keysArray[indexPath.row]
        let currentIndexKey : [Contact] = duplicates[currentKey] as! [Contact]
        
        cell.contactNameLabel.text = currentKey
        return cell
    }
}
