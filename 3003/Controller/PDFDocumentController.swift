import UIKit
import PDFKit

protocol SaveTheMemorySearch {
    func saveTheWordWhenCancelPressed(mem: String)
}


class PDFDocumentController: UIViewController, SaveTheMemorySearch {
    
    @IBOutlet weak var bookMark: UIBarButtonItem!
    
    var pdfView = PDFView()
    var docName: String = ""
    var memorySearchText: String = ""
  
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayPdf()
    }
    
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
        tabBarController?.tabBar.isHidden = true
        navigationController?.hidesBarsOnSwipe = true
    }
    
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        navigationController?.hidesBarsOnSwipe = true
        
    }    
    
    @IBAction func searchButtonOnTap(_ sender: UIBarButtonItem) {
        
        for index in 0..<pdfView.document!.pageCount {
            let page: PDFPage = pdfView.document!.page(at: index)!
            let annotations = page.annotations
            for annotation in annotations {
                page.removeAnnotation(annotation)
            }
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "search") as! SearchFromPDFController
        vc.pdfView = pdfView
        vc.searchText = memorySearchText
        vc.theMemorySearchDelegate = self
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func shareButtonOnTap(_ sender: UIBarButtonItem) {
        
        if let message = resourceUrl(forFileName: docName) {
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
    
    private func createPdfView(withFrame frame: CGRect) -> PDFView {
        
        let pdfView = PDFView(frame: frame)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
        return pdfView
    }
    private func createPdfDocument(forFileName fileName: String) -> PDFDocument? {
        
        if let resourceUrl = self.resourceUrl(forFileName: fileName) {
            return PDFDocument(url: resourceUrl)
        }
        
        return nil
    }
    
    private func displayPdf() {
        
        pdfView = self.createPdfView(withFrame: self.view.bounds)
    
        if let pdfDocument = self.createPdfDocument(forFileName: docName) {
            self.view.addSubview(pdfView)
            let tap = UITapGestureRecognizer(target: self, action: #selector(hideTabBarOnTapPDFview))
            pdfView.addGestureRecognizer(tap)
            pdfView.autoScales = true
            pdfView.document = pdfDocument
        }
        
    }
    
    @objc func hideTabBarOnTapPDFview() {
        
        if tabBarController!.tabBar.isHidden {
            tabBarController?.tabBar.isHidden = false
        } else {
            tabBarController?.tabBar.isHidden = true
        }
        
    }
    
    func saveTheWordWhenCancelPressed(mem: String) {
        memorySearchText = mem
    }
}
