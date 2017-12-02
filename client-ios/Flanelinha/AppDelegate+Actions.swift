import UIKit

extension AppDelegate {
    
    func addNavigationAppIfAvaiable(app: appType) {
        let application = UIApplication.shared
        if application.canOpenURL(URL(string: app.urlString)!) {
            installedNavigationApps.append(app)
        }
    }
    
    func checkInstalledNavigationApps() {
        installedNavigationApps = []
        for app in navigationApps {
            addNavigationAppIfAvaiable(app: app)
        }
    }
    
}
