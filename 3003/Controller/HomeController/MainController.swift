import UIKit

var allDataObject = AllDataOfFilesTxT()
var docNamesArray: [String] = []
var allDataArray: [[[String]]] = []

class MainController: UIViewController {
    
    @IBOutlet var customLabels: [UILabel]!
    @IBOutlet var customButtons: [UIButton]!
    
    var timer: Timer!
    let myCarousel = iCarousel()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carouselView()
        
        docNamesArray = allDataObject.getAllDocsName()
        
        if realm.objects(Data.self).count == 0 {
            docNamesArray = allDataObject.getAllDocsName()
            for i in docNamesArray.indices {
                let newData = Data()
                newData.allDocsName = docNamesArray[i]
                saveData(data: newData)
            }
        }
        
        allDataArray = allDataObject.getAllDataToArray()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: view.frame.width / 18), NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "home".localized
        
        UserDefaults.standard.setValue(0, forKey: "segmentActive")
        UserDefaults.standard.setValue(0, forKey: "segmentPassive")
    
        customFont()
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func saveData(data: Data) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print(error)
        }
    }
    
    private func carouselView() {
        myCarousel.type = .rotary
        view.addSubview(myCarousel)
        myCarousel.dataSource = self
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        myCarousel.frame = CGRect(x: 0, y: topBarHeight + 5, width: view.frame.width, height: view.frame.height / 5)
    }
    
    private func customFont() {
        for i in customLabels.indices {
            customLabels[i].text = "button\(i + 1)".localized
            customLabels[i].font = UIFont.systemFont(ofSize: view.frame.width / 30, weight: .medium)
            
            customButtons[i].setBackgroundColor(color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), forUIControlState: .highlighted)
        
            customButtons[i].layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
            customButtons[i].layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
            customButtons[i].layer.shadowOpacity = 4.0
            customButtons[i].layer.masksToBounds = true
            customButtons[i].layer.cornerRadius = 15
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "laws" {
            let vc = segue.destination as! PDFDocumentController
            vc.docName = "qonun".localized
        } else
        if segue.identifier == "extrainfo" {
            let vc = segue.destination as! PDFDocumentController
            vc.docName = "konseptual".localized
        }
    }
}

//MARK: carousel
extension MainController: iCarouselDelegate, iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 4
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let adView = UIView(frame: CGRect(x: 0, y: 0, width: myCarousel.frame.width / 1.8, height: myCarousel.frame.height))
        adView.backgroundColor = .clear
        let adImageView = UIImageView(frame: adView.bounds)
        adImageView.contentMode = .scaleAspectFit
        adImageView.image = UIImage(named: "ad\(index)")
        adImageView.layer.cornerRadius = 10
        adImageView.clipsToBounds = true
        adView.addSubview(adImageView)
        
        var activeItemIndex = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            activeItemIndex += 1
            if activeItemIndex == carousel.numberOfItems {
                activeItemIndex = 0
            }
            carousel.scrollToItem(at: activeItemIndex, duration: 3)
        }
        
        return adView
    }
}
