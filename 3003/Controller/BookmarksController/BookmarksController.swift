import UIKit
import RealmSwift

class BookmarksController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var searchResults: [String] = []
    var isSearching: Bool = false
        
    var indexOfSections: [Int] = []
    var sectionsArray: [String] = []
    var rowsInSectionArray: [[String]] = []
    
    var data: Results<Data>!
    
    var searchController = UISearchController(searchResultsController: nil)
   
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.rowHeight = view.frame.height / 11
        
        data = realm.objects(Data.self)
        
        indexOfSections = []
        sectionsArray = []
        rowsInSectionArray = []
        
        for i in data.indices {
            if data[i].bookmarks.count > 0 {
                indexOfSections.append(Int(i))
                sectionsArray.append(data[i].allDocsName)
                let docBookmarks = allDataObject.getOneFileArray(docName: docNamesArray[i])
                var bookmarkArray = [String]()
                for j in data[i].bookmarks.indices {
                    bookmarkArray.append(docBookmarks[0][Int(data[i].bookmarks[j])! - 1])
                }
                rowsInSectionArray.append(bookmarkArray)
            }
        }
    
        navigationItem.title = "bookmarks".localized
        
        setSearchController(searchController: searchController, delegate: self)
        tableView.reloadData()
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookmark" {
            let vc = segue.destination as! DesignedTableController
            let section = indexOfSections[tableView.indexPathForSelectedRow!.section]
            vc.docName = data[section].allDocsName
            vc.tapedRowIndex = Int(data[section].bookmarks[tableView.indexPathForSelectedRow!.row])! - 1
        }
    }
}


//MARK: Table
extension BookmarksController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchResults.count
        }
        return rowsInSectionArray[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return 1
        }
        return sectionsArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(data[indexOfSections[section]].allDocsName).localized
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSearching {
            return 0
        }
        return 50
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarksCell", for: indexPath) as! CustomTableCell
        
        if isSearching {
            cell.numLabel.text = String(searchResults[indexPath.row].split(separator: "Ω")[0])
            cell.descriptionLabel.text = String(searchResults[indexPath.row].split(separator: "Ω")[1])
        } else {
            let section = indexOfSections[indexPath.section]
            cell.numLabel.text = data[section].bookmarks[indexPath.row]
            cell.descriptionLabel.text = String(rowsInSectionArray[indexPath.section][indexPath.row].split(separator: "Ω")[1])
        }
        
        return cell
        
    }
}



//MARK: Search

extension BookmarksController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        
        if searchBar.text == "" {
            isSearching = false
        }
        
        self.searchResults = rowsInSectionArray.containsStringDoubleArray(searchText: searchText, existingDoubleArray: rowsInSectionArray)
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadData()
    }
}
