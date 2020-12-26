import UIKit

class PassiveController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var passiveSections: [String] = []
    
    var searchResults: [String] = []
    var isSearching: Bool = false
    
    var searchController = UISearchController(searchResultsController: nil)
  
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.rowHeight = view.frame.height / 10
        
        title = "passiveTitle".localized
        
        segmentedControl.setTitle("passiveSegment1".localized, forSegmentAt: 0)
        segmentedControl.setTitle("passiveSegment2".localized, forSegmentAt: 1)
        
        segmentPressed()
        
        segmentedControl.layer.borderColor = UIColor.white.cgColor
        setSearchController(searchController: searchController, delegate: self)
        
        tableView.reloadData()
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }    
    
    @IBAction func segments(_ sender: UISegmentedControl) {
        UserDefaults.standard.setValue(sender.selectedSegmentIndex, forKey: "segmentPassive")
        segmentPressed()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    
    func segmentPressed() {
        segmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "segmentPassive")
        switch UserDefaults.standard.integer(forKey: "segmentPassive") {
        
        case 0 :
            
            isSearching = false
            searchController.searchBar.text = ""
            navigationItem.searchController?.dismiss(animated: true, completion: nil)
            passiveSections = PassiveSegmentFirstModel().getPassiveSegmentFirstSections()
            tableView.reloadData()
            
        case 1 :
            
            isSearching = false
            searchController.searchBar.text = ""
            navigationItem.searchController?.dismiss(animated: true, completion: nil)
            passiveSections = PassiveSegmentSecondModel().getPassiveSegmentSecondSections()
            tableView.reloadData()
            
        default: break
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "passiveTablePDF" {
            let vc = segue.destination as! SectionsTableController
            vc.docName = passiveSections[tableView.indexPathForSelectedRow!.row]
        }
    }
}

//MARK: table
extension PassiveController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchResults.count
        }
        return passiveSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableCell
        
        if isSearching {
            cell.numLabel.text = String(searchResults[indexPath.row].localized.split(separator: " ")[0])
            cell.descriptionLabel.text = searchResults[indexPath.row].localized.removeToSpecifiedIndex(specifiedString: searchResults[indexPath.row].localized)
        } else {
            cell.numLabel.text = passiveSections[indexPath.row]
            cell.descriptionLabel.text = passiveSections[indexPath.row].localized.removeToSpecifiedIndex(specifiedString: passiveSections[indexPath.row].localized)
        }
        return cell
    }
}
//MARK: search
extension PassiveController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        searchResults = []
        
        if searchBar.text == "" {
            isSearching = false
        }

        self.searchResults = passiveSections.containsStringArray(searchText: searchText, existingArray: passiveSections)

        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadData()
    }
}
