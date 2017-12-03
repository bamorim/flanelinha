import UIKit
import Alamofire

class CreditCardViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameUserLabel: UILabel!
    @IBOutlet weak var creditCardImage: UIImageView!
    @IBOutlet weak var cvvCardImage: UIImageView!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardNumberTextField.delegate = self
        let fullName = UserDefaults.standard.string(forKey: "userName")
        let firstName = fullName?.components(separatedBy: " ").first
        nameUserLabel.text = firstName
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        let parameters: Parameters = [
            "account_id": UserDefaults.standard.integer(forKey: "userID"),
            "card": [
                "digits": cardNumberTextField.text!,
                "valid_thru": String(format: "%@/%@", monthTextField.text!, yearTextField.text!)
            ]
        ]
        
        Alamofire.request("http://10.20.3.166:3000/cards", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: { response in
            NSLog("param: \(response)")
            let jsonResponse = response.result.value as! [String:AnyObject]
            let cardLastNumbers = jsonResponse["last_digits"] as! String
            let cardValidate = jsonResponse["valid_thru"] as! String
            UserDefaults.standard.set(cardLastNumbers, forKey: "cardLastNumbers")
            UserDefaults.standard.set(cardValidate, forKey: "cardValidate")
            
            let alert = UIAlertController(title: "Salvo com sucesso!", message: "Já guardamos o seu cartão, agora é só procurar a vaga mais próxima.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                //open viewController to save card
                let rootVC = TabBarController.instance()
                UIApplication.shared.keyWindow?.rootViewController = rootVC
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !textField.text!.isEmpty {
            creditCardImage.image = UIImage(named: "icons8-mastercard-48")
        }
        
        return true
    }
    
}
