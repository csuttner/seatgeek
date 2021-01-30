//
//  TableViewController.swift
//  SeatGeek
//
//  Created by Clay Suttner on 1/28/21.
//

// Main tableview controller, responsible for displaying data from Repository and providing query data from search bar

import UIKit

// Delegate protocol to trigger tableview reload from Repository on successful fetch completion
protocol RepoDelegate {
    func loadAllEvents()
}

class TableViewController: UITableViewController {
    
    // Access to data through repository
    let repository = Repository.instance
    
    // Locally store list of filtered events for population in cells
    // Assigned from Repository
    var filteredEvents = [Event]()
    
    let cellIdentifier = "Table Cell Identifier"
    
    // Make searchBar a class property so we can simply reference it for queries
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        tableView.register(TableCell.self, forCellReuseIdentifier: cellIdentifier)
        repository.repoDelegate = self
        searchBar.delegate = self
    }
    
    // Tableview must be reloaded on viewWillAppear to display images for updated
    // liked / unliked data
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // I experimented with achieving the multiline title shown in the test description, but
    // settled for a standard empty navbar with empty back button and a multiline
    // title in detail viewController
    func configureNavBar() {
        
        // Empty back button will display in Detail View
        let emptyBackButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = emptyBackButton
        
        // Add action to cancel button to reset search
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSearch))
        navigationController?.navigationBar.topItem?.rightBarButtonItem = cancelButton
        
        // Add searchBar to navbar by setting it as titleView - removes the need for custom constraints
        searchBar.placeholder = "Search events"
        navigationController?.navigationBar.topItem?.titleView = searchBar
    }
    
    // Dismiss keyboard, clear text, and reload all events from Repository
    @objc func cancelSearch() {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        loadAllEvents()
    }
    
}

// Implementation of Repository delegate method to be called when data has been loaded
extension TableViewController: RepoDelegate {
    func loadAllEvents() {
        filteredEvents = repository.getEvents()
        tableView.reloadData()
    }
}

// Search bar delegate so we can trigger actions when the user taps "search"
extension TableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text!
        filteredEvents = repository.getFilteredEvents(query: query)
        tableView.reloadData()
    }
}

// Tableview data source methods
extension TableViewController {
    
    // Adjust the number of rows based on the number of events in filtered list
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue cell from tableview as custom TableCell class, so we can access the methods of that class
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableCell
        let event = filteredEvents[indexPath.row]
        
        // Modify cell for given event, setting or overriding from reuse
        cell.configureFor(event: event)
        return cell
    }
}

// Tableview delegate
extension TableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = filteredEvents[indexPath.row]
        
        // Initialize DetailViewController with event object and push on navcontroller stack
        let detailView = DetailViewController(event: event)
        navigationController?.pushViewController(detailView, animated: true)
    }
    
}
