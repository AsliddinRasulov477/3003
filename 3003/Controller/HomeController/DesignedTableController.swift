import UIKit
import RealmSwift

class DesignedTableController: UIViewController {

    @IBOutlet weak var numberAccountLabel: UILabel!
    @IBOutlet weak var bookMark: UIBarButtonItem!
    
    @IBOutlet var allTitle: [UILabel]!
    
    @IBOutlet weak var xomLabel: UILabel!
    @IBOutlet weak var debetLabel: UILabel!
    @IBOutlet weak var kreditLabel: UILabel!
    @IBOutlet weak var ythLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    
    var isFirstColored: Bool = true
    
    var arrayThisDoc: [[String]] = []
    var inXOMarray: [String] = []
    var tapedRowIndex: Int = 0
    var docName: String = ""
    
    var data: Results<Data>!
    var indexRemoveData: Int = 0
    
    var selectedCellIndex: Int = 0
    
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        data = realm.objects(Data.self)
        
        arrayThisDoc = allDataObject.getOneFileArray(docName: docName)
    
        if searchDocNameFromData() {
            bookMark.image = UIImage(named: "pdf.bookmark.fill")
        } else {
            bookMark.image = UIImage(named: "pdf.bookmark")
        }
        
        numberAccountLabel.text = docName.localized
        
        numberAccountLabel.font = UIFont.systemFont(ofSize: view.frame.height / 45)
        xomLabel.font = UIFont.systemFont(ofSize: view.frame.height / 50)
        debetLabel.font = UIFont.systemFont(ofSize: view.frame.height / 50)
        kreditLabel.font = UIFont.systemFont(ofSize: view.frame.height / 50)
        ythLabel.font = UIFont.systemFont(ofSize: view.frame.height / 50)
        
        for i in allTitle.indices {
            allTitle[i].text = "designTableTitle\(i)".localized
            allTitle[i].font = UIFont.boldSystemFont(ofSize: view.frame.height / 50)
        }
        
        inXOMarray = []
        
        if arrayThisDoc[1][tapedRowIndex] == "0" {
            
            for i in arrayThisDoc[4].indices {
                if Int(arrayThisDoc[4][i].split(separator: "Ω")[0]) == tapedRowIndex + 1 {
                    inXOMarray.append(arrayThisDoc[4][i])
                }
            }
            
            collectionViewHeight.constant = 50
            
            if CGFloat(inXOMarray.count * 60) > 0.85 * view.frame.width {
                collectionViewWidth.constant = 0.85 * view.frame.width
            } else {
                collectionViewWidth.constant = CGFloat(inXOMarray.count * 60)
            }

            let splitInXOMarray = inXOMarray[0].split(separator: "Ω")
            
            xomLabel.text = String(arrayThisDoc[0][tapedRowIndex].split(separator: "Ω")[1]) + "\n" + String(splitInXOMarray[1])
            debetLabel.text = String(splitInXOMarray[2].split(separator: "∫")[1])
            kreditLabel.text = String(splitInXOMarray[3])
            ythLabel.text = arrayThisDoc[3][tapedRowIndex]
            
            title = String(splitInXOMarray[2].split(separator: "∫")[0])
            
        } else {
            
            collectionViewHeight.constant = 1
            collectionView.backgroundColor = .red
            
            xomLabel.text = String(arrayThisDoc[0][tapedRowIndex].split(separator: "Ω")[1])
            debetLabel.text = String(arrayThisDoc[1][tapedRowIndex].split(separator: "∫")[1])
            if debetLabel.text == "1" {
                debetLabel.text = ""
            }
            kreditLabel.text = arrayThisDoc[2][tapedRowIndex]
            if kreditLabel.text == "1" {
                kreditLabel.text = ""
            }
            ythLabel.text = arrayThisDoc[3][tapedRowIndex]
            
            title = String(arrayThisDoc[1][tapedRowIndex].split(separator: "∫")[0])
        }
        
    }
    
    
    @IBAction func saveToBookmarkButtonPressed(_ sender: UIBarButtonItem) {
        if searchDocNameFromData() {
            do {
                try realm.write {
                    data[getCurrentDocIndex()].bookmarks.remove(at: indexRemoveData)
                }
            } catch {
                print(error)
            }
    
            sender.image = UIImage(named: "pdf.bookmark")
        } else {
            
            do {
                try realm.write {
                    data[getCurrentDocIndex()].bookmarks.append("\(tapedRowIndex + 1)")
                }
            } catch {
                print(error)
            }
            
            sender.image = UIImage(named: "pdf.bookmark.fill")
        }
        
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        if let message = resourceUrl(forFileName: (docName + "file").localized) {
            let objectsToShare = [message]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    private func resourceUrl(forFileName fileName: String) -> URL? {
        
        if let resourceUrl = Bundle.main.url(forResource: fileName, withExtension: "pdf") {
            return resourceUrl
        }
        
        return nil
    }
    
    func searchDocNameFromData() -> Bool {
        let currentDocBookmarks = data[getCurrentDocIndex()].bookmarks
        for i in currentDocBookmarks.indices {
            if  currentDocBookmarks[i] == "\(tapedRowIndex + 1)" {
                indexRemoveData = i
                return true
            }
        }
        return false
    }
    
    func getCurrentDocIndex() -> Int {
        for i in data.indices {
            if data[i].allDocsName == docName {
                return i
            }
        }
        return 0
    }
}

extension DesignedTableController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inXOMarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as! DesignedTableCell
        
        cell.layer.cornerRadius = cell.frame.height / 2
        
        if isFirstColored && indexPath.row == 0 {
            cell.backgroundColor = color
        }
        
       
        if indexPath.row == selectedCellIndex {
            cell.backgroundColor = color
        } else {
            cell.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9215686275, alpha: 1)
        }
        
        
        cell.numberCellLabel.text = "\(indexPath.row + 1)"
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let splitInXOMarray = inXOMarray[indexPath.row].split(separator: "Ω")
        isFirstColored = false
        
        xomLabel.text = String(arrayThisDoc[0][tapedRowIndex].split(separator: "Ω")[1]) + "\n" + String(splitInXOMarray[1])
        debetLabel.text = String(splitInXOMarray[2].split(separator: "∫")[1])
        kreditLabel.text = String(splitInXOMarray[3])
        ythLabel.text = arrayThisDoc[3][tapedRowIndex]
        
        title = String(splitInXOMarray[2].split(separator: "∫")[0])
        
        selectedCellIndex = indexPath.row
        collectionView.reloadData()
    }
    
}


class DesignedTableCell: UICollectionViewCell {
    @IBOutlet weak var numberCellLabel: UILabel!
}
