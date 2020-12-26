import UIKit
import PDFKit

class ActiveController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var activeSections: [String] = []
    
    var searchResults: [String] = []
    var isSearching: Bool = false
    
    var searchController = UISearchController(searchResultsController: nil)
    
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.rowHeight = view.frame.height / 10
        
        title = "activeTitle".localized
        
        segmentedControl.setTitle("activeSegment1".localized, forSegmentAt: 0)
        segmentedControl.setTitle("activeSegment2".localized, forSegmentAt: 1)
    
        segmentPressed()
        
        segmentedControl.layer.borderColor = UIColor.white.cgColor
        setSearchController(searchController: searchController, delegate: self)
        
        tableView.reloadData()
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false        
    }    
    
    @IBAction func segmentsPressed(_ sender: UISegmentedControl) {
        UserDefaults.standard.setValue(sender.selectedSegmentIndex, forKey: "segmentActive")
        segmentPressed()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    
    func segmentPressed() {
        segmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "segmentActive")
        switch UserDefaults.standard.integer(forKey: "segmentActive") {
        
        case 0 :
            
            isSearching = false
            searchController.searchBar.text = ""
            navigationItem.searchController?.dismiss(animated: true, completion: nil)
            activeSections = ActiveSegmentFirstModel().getActiveSegmentFirstSections()
            tableView.reloadData()
            
        case 1 :
            
            isSearching = false
            searchController.searchBar.text = ""
            navigationItem.searchController?.dismiss(animated: true, completion: nil)
            activeSections = ActiveSegmentSecondModel().getActiveSegmentSecondSections()
            tableView.reloadData()
            
        default: break
            
        }
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "activeTablePDF" {
            let vc = segue.destination as! SectionsTableController
            vc.docName = activeSections[tableView.indexPathForSelectedRow!.row]
        }
    }
}


//MARK: table
extension ActiveController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchResults.count
        }
        return activeSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableCell
        
        if isSearching {
            cell.numLabel.text = String(searchResults[indexPath.row].localized.split(separator: " ")[0])
            cell.descriptionLabel.text = searchResults[indexPath.row].localized.removeToSpecifiedIndex(specifiedString: searchResults[indexPath.row].localized)
        } else {
            cell.numLabel.text = activeSections[indexPath.row]
            cell.descriptionLabel.text = activeSections[indexPath.row].localized.removeToSpecifiedIndex(specifiedString: activeSections[indexPath.row].localized)
        }
        return cell
    }
    
}

//MARK: search bar
extension ActiveController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        searchResults = []
        
        if searchBar.text == "" {
            isSearching = false
        }
        
        self.searchResults = activeSections.containsStringArray(searchText: searchText, existingArray: activeSections)
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadData()
    }
}
