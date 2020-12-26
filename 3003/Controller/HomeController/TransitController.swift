import UIKit

class TransitController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var transitSections: [String] = []
    
    var searchResults: [String] = []
    var isSearching: Bool = false
    
    var searchController = UISearchController(searchResultsController: nil)
  
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        title = "transitTitle".localized
        
        tableView.rowHeight = view.frame.height / 10
        
        transitSections = TransitModel().getTransitSections()
        
        navigationItem.hidesSearchBarWhenScrolling = false
        setSearchController(searchController: searchController, delegate: self)
        
        tableView.reloadData()
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "transitTablePDF" {
            let vc = segue.destination as! SectionsTableController
            vc.docName = transitSections[tableView.indexPathForSelectedRow!.row]
        }
    }
}

//MARK: table
extension TransitController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchResults.count
        }
        return transitSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableCell
        
        if isSearching {
            cell.numLabel.text = String(searchResults[indexPath.row].localized.split(separator: " ")[0])
            cell.descriptionLabel.text = searchResults[indexPath.row].localized.removeToSpecifiedIndex(specifiedString: searchResults[indexPath.row].localized)
        } else {
            cell.numLabel.text = transitSections[indexPath.row]
            cell.descriptionLabel.text = transitSections[indexPath.row].localized.removeToSpecifiedIndex(specifiedString: transitSections[indexPath.row].localized)
        }
        return cell
    }
}

//MARK: search
extension TransitController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        searchResults = []
        
        if searchBar.text == "" {
            isSearching = false
        }

        self.searchResults = transitSections.containsStringArray(searchText: searchText, existingArray: transitSections)

        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadData()
    }
}
