import UIKit

class SectionsTableController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var docName: String = ""
    var arrayThisDoc: [[String]] = []
    
    var searchResults: [String] = []
    var isSearching: Bool = false
    
    var searchController = UISearchController(searchResultsController: nil)
    
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.rowHeight = view.frame.height / 12
        
        title = docName
        
        arrayThisDoc = allDataObject.getOneFileArray(docName: docName)
        
        navigationItem.hidesSearchBarWhenScrolling = false
        setSearchController(searchController: searchController, delegate: self)
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "designedTable" {
            let vc = segue.destination as! DesignedTableController
            vc.docName = docName
            vc.tapedRowIndex = tableView.indexPathForSelectedRow!.row
        }
    }
}


//MARK: table
extension SectionsTableController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchResults.count
        }
        
        return arrayThisDoc[0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionsCell", for: indexPath) as! CustomTableCell
    
        if isSearching {
            cell.numLabel.text = String(searchResults[indexPath.row].split(separator: "Ω")[0])
            cell.descriptionLabel.text = String(searchResults[indexPath.row].split(separator: "Ω")[1])
        } else {
            cell.numLabel.text = String(arrayThisDoc[0][indexPath.row].split(separator: "Ω")[0])
            cell.descriptionLabel.text = String(arrayThisDoc[0][indexPath.row].split(separator: "Ω")[1])
        }
        
        return cell
    }
}

//MARK: search
extension SectionsTableController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        searchResults = []
        
        if searchBar.text == "" {
            isSearching = false
        }

        self.searchResults = arrayThisDoc[0].containsStringArray(searchText: searchText, existingArray: arrayThisDoc[0])
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadData()
    }
}
