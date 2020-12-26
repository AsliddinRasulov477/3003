import UIKit

class OutOfBalanceController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var outOfBalance: [String] = []
    
    var searchResults: [String] = []
    var isSearching: Bool = false
    
    var searchController = UISearchController(searchResultsController: nil)
  
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        title = "outOfBalanceTitle".localized
        
        tableView.rowHeight = view.frame.height / 10
        
        outOfBalance = OutOfBalanceModel().getOutOfBalance()
        
        navigationItem.hidesSearchBarWhenScrolling = false
        setSearchController(searchController: searchController, delegate: self)
        
        tableView.reloadData()
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "outofbalanceTablePDF" {
            let vc = segue.destination as! SectionsTableController
            vc.docName = outOfBalance[tableView.indexPathForSelectedRow!.row]
        }
    }
        
}

//MARK: table
extension OutOfBalanceController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchResults.count
        }
        return outOfBalance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableCell
        
        if isSearching {
            cell.numLabel.text = String(searchResults[indexPath.row])
            cell.descriptionLabel.text = searchResults[indexPath.row].localized.removeToSpecifiedIndex(specifiedString: searchResults[indexPath.row].localized)
        } else {
            cell.numLabel.text = outOfBalance[indexPath.row]
            cell.descriptionLabel.text = outOfBalance[indexPath.row].localized.removeToSpecifiedIndex(specifiedString: outOfBalance[indexPath.row].localized)
        }
            
        
        return cell
    }
}

//MARK: search
extension OutOfBalanceController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        searchResults = []
        
        if searchBar.text == "" {
            isSearching = false
        }

        self.searchResults = outOfBalance.containsStringArray(searchText: searchText, existingArray: outOfBalance)
        print(searchResults)

        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadData()
    }
}
