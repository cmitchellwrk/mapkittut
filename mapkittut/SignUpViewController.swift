
import UIKit
import Firebase
import FirebaseAuth


import Contacts


import CoreLocation



class SignUpViewController: UIViewController {

    //Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var organizationTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    
 
    
    var ref: FIRDatabaseReference?
    
   
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }    
    
    
    
    
    func getcitystate(){
        
        
        
        
    }
    
    
    
    
  @IBAction   func zipToAddress  (_ sender: AnyObject)  {
        let geoCoder = CLGeocoder();
        
        let params = [
            String(CNPostalAddressPostalCodeKey): self.zipcodeTextField.text!,
            String(CNPostalAddressISOCountryCodeKey): "US",
            ] as [String : Any]
        
        geoCoder.geocodeAddressDictionary(params) {
            (plasemarks, error) -> Void in
            
            if let plases = plasemarks {
                
                if plases.count > 0 {
                    let firstPlace = plases[0]
                    
                    print( "City \(firstPlace.locality) state \(firstPlace.administrativeArea) and country \(firstPlace.country) and iso country \(firstPlace.country)")
                    
                    let city = firstPlace.locality
                    
                    self.cityTextField.text = city
                    
                    
                    let state = firstPlace.administrativeArea
                    
                    self.stateTextField.text = state
            
                }
                
            }
            
            
                    }
    }
    
  
    
    
    
    
    
    //Sign Up Action for email
    @IBAction func createAccountAction(_ sender: AnyObject) {
        if emailTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                
                /////////
                if error == nil {
                    print("You have successfully signed up")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
                    
                    self.ref = FIRDatabase.database().reference()
                    
                    
                    self.ref?.child("profiles/\(user!.uid)/email").setValue(self.emailTextField.text!)
                    
                    self.ref?.child("profiles/\(user!.uid)/password").setValue(self.passwordTextField.text!)
                    
                    self.ref?.child("profiles/\(user!.uid)/organization").setValue(self.organizationTextField.text!)
                    
                    self.ref?.child("profiles/\(user!.uid)/city").setValue(self.cityTextField.text!)
                    
                    self.ref?.child("profiles/\(user!.uid)/state").setValue(self.stateTextField.text!)
                    
                    self.ref?.child("profiles/\(user!.uid)/zipcode").setValue(self.zipcodeTextField.text!)
                    
                    
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
               
                
            }
            
    
        }
    
        
        
    }
    
    
}

