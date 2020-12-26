import UIKit
import RealmSwift

let realm = try! Realm()

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        
        LocalizationSystem.shared.locale = Locale(identifier: UserDefaults.standard.string(forKey: "AppleLanguage") ?? Locale.current.identifier)
        
        
        
        return true
    }
    
    
}

