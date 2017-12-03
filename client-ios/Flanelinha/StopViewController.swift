import UIKit
import Alamofire

class StopViewController: UIViewController {
    
    @IBOutlet weak var hoursStopLabel: UILabel!
    @IBOutlet weak var lastDigitsCardLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        lastDigitsCardLabel.text = UserDefaults.standard.string(forKey: "cardLastNumbers")
    }
    

    
    @IBAction func didTapStepper(_ sender: UIStepper) {
        hoursStopLabel.text = String(Int(sender.value))
    }
    
    @IBAction func didTapParkButton(_ sender: Any) {
        
        let parameters: Parameters = [
            "account_id": UserDefaults.standard.integer(forKey: "userID"),
            "duration": Int(hoursStopLabel.text!) ?? 2
        ]
        
        let tripID = String(UserDefaults.standard.integer(forKey: "tripID"))
        
        let url = String(format: "http://10.20.3.166:3000/trips/%@/park", tripID)
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: { response in
            let jsonResponse = response.result.value as! [String:AnyObject]
            
            let parking = jsonResponse["parking"] as! [String:AnyObject]
            name = parking["name"] as! String
            latitude = String(parking["latitude"] as! Double)
            longitude = String(parking["longitude"] as! Double)
            
            UserDefaults.standard.set(name, forKey: "parkedName")
            UserDefaults.standard.set(latitude, forKey: "parkedLatitude")
            UserDefaults.standard.set(longitude, forKey: "parkedLongitude")
            
            //open viewController to save card
            let finishViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FinishViewController") as! FinishViewController
            UIApplication.shared.keyWindow?.rootViewController = finishViewController
            
        })
        
    }
    

}
