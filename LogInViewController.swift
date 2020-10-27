//
//  LogInViewController.swift
//  Warranty Wallet
//
//  Created by Eric Cook on 8/30/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
//import Parse
import Firebase

let win = UIWindow(frame: UIScreen.main.bounds)

let vc = UIViewController()

class LoginViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(_ title:String, error:String) {
        
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
            self.topController(identifier: "Create")
            
            self.topController(identifier: "Login")
            
            //self.performSegue(withIdentifier: "loginToCreate", sender: self)
            
        }))
        
        alert.topControllerAlert()
        
        //self.present(alert, animated: true, completion: nil)
        
    }
    
    func displayAlert2(_ title:String, error:String) {
        
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        alert.topControllerAlert()
        
    }
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var alreadyRegistered: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var signUpLabel: UILabel!
    
    @IBOutlet var signUpToggleButton: UIButton!
    
    @IBAction func create(_ sender: AnyObject) {
        
        
        self.performSegue(withIdentifier: "loginToCreate", sender: self)
        
        
    }
    
    
    @IBOutlet var emailPasswordReset: UITextField!
    
    /*@objc func getParseUsername() {
        
        db.collection("users").whereField("username", isEqualTo: username.text!).getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                
                print("Error getting documents: \(err)")
                
            } else {
                
                for document in querySnapshot!.documents {
                    
                    if let resetPw = document.get("resetPassword") as? Bool {
                        hasPasswordBeenReset = resetPw
                        print(resetPw)
                    }
                    
                }
                
                print("hasPasswordBeenReset: \(hasPasswordBeenReset)")
                
                //print("\(document.documentID) => \(document.data())")
                
                print("Successfully retrieved User with the same username entered.")
            }
        }
    
        let query = PFUser.query()
        query!.whereKey("username", equalTo: username.text!)
        //query!.whereKey("resetPassword", notEqualTo: true)
        query!.findObjectsInBackground {
            //(objects, error) in
            (results: [PFObject]?, error: Error?) in
            
            if error == nil {
               
                print("Successfully retrieved \(results!.count) User with the same username entered.")
                
                    if let objects = results {
                        
                        for object in objects {
                            
                            hasPasswordBeenReset = object["resetPassword"] as! Bool
                            
                            print("hasPasswordBeenReset: \(hasPasswordBeenReset)")
                            
                        }
                        
                   }
                
                //self.resetPasswordAlert()
                
                self.convertToNewParse()
                
                } else {
                           
                            print("Error: \(error!)")
                           
                }
                
        }
        
    }*/
    
    func resetPasswordAlert() {
        
        if UserDefaults.standard.string(forKey: "resetPassword") != "yes" {
            
            //self.displayAlert2("We moved our database!", error: "All account passwords need to be updated. Please reset your password and login again.")
            
            
            let alert = UIAlertController(title: "We moved our database!", message: "All account passwords need to be updated. Please reset your password and login again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                
                //self.resetPassword(UIButton())
                
                self.emailPasswordReset.alpha = 1
                self.emailPasswordReset.backgroundColor = UIColor.white
                self.loginButton.setTitle("Send", for: UIControl.State())
                self.password.alpha = 0
                self.username.alpha = 0
                
            }))
                
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
    }
   
    @IBAction func resetPassword(_ sender: AnyObject) {
        
        /*if UserDefaults.standard.string(forKey: "resetPassword") != "yes" {
            
            let defaults = UserDefaults.standard
            defaults.set("yes", forKey: "resetPassword")
            
            print(UserDefaults.standard.string(forKey: "resetPassword")!)
            
        }*/
        
        self.emailPasswordReset.alpha = 1
        self.emailPasswordReset.backgroundColor = UIColor.white
        self.loginButton.setTitle("Send", for: UIControl.State())
        self.password.alpha = 0
        self.username.alpha = 0
        
    }
    
    /*func resetPasswordFirestore() {
        
     if UserDefaults.standard.string(forKey: "resetPassword") != "yes" {
            
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            self.resetPasswordAlert()
            
            if self.emailPasswordReset.alpha == 1 {
                
                if self.emailPasswordReset.text != "" {
                    
                    //self.resetParsePassword()
                    
                } else {
                    
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    
                    
                    let alert = UIAlertController(title: "Enter email address!", message: "Please enter correct email address.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                        alert.dismiss(animated: true, completion: nil)
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                }
                
                
            }
            
        }
    }*/
    
    @IBAction func login(_ sender: AnyObject) {
        
        //getParseUsername()
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        //_ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(doNothing), userInfo: nil, repeats: false)
        
        if self.emailPasswordReset.alpha == 0 {
            
            if username.text == "" || password.text == "" {
                
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                
                displayAlert("Error In Form: ", error: "Please enter all fields.")
                
            } else {
                
                //self.convertToNewParse()
                
                Auth.auth().signIn(withEmail: username.text!, password: password.text!) { authResult, error in
                    
                    if let error = error as NSError? {
                    
                        switch AuthErrorCode(rawValue: error.code) {
                   
                        case .operationNotAllowed:
                    
                            print("Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.")
                            
                            self.displayAlert("Error: Could Not Login", error: "The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.")
                            
                        case .emailAlreadyInUse:
                       
                            print("Error: The email address is already in use by another account.")
                            
                            self.displayAlert("Error: Could Not Login", error: "The email address is already in use by another account.")
                            
                        case .invalidEmail:
                        
                            print("Error: The email address is badly formatted.")
                            
                            self.displayAlert("Error: Could Not Login", error: "The email address is badly formatted.")
                            
                        case .weakPassword:
                        
                            print("Error: The password must be 6 characters long or more.")
                            
                            self.displayAlert("Error: Could Not Login", error: "The password must be 6 characters long or more.")
                            
                        default:
                        
                            print("Error: \(error.localizedDescription)")
                            
                            //self.displayAlert("Error: Could Not Login", error: "The email or password is incorrect. Please try again.")
                            
                            self.displayAlert("Error: Could Not Login", error: "\(error.localizedDescription)")
                            
                        }
                        
                  } else {
                    
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    
                    print("User signed in successfully")
                    currentUserId = Auth.auth().currentUser!.uid
                    currentUserEmail = (Auth.auth().currentUser?.email)!
                    
                    userEmail = currentUserEmail
                    
                    currentLoginState = "authorized"
                    
                    let defaults = UserDefaults.standard
                    defaults.set(currentUserId, forKey: "currentId")
                    defaults.set(currentUserEmail, forKey: "currentEmail")
                    
                    if defaults.string(forKey: "resetPassword") != "yes" {
                        
                        defaults.set("yes", forKey: "resetPassword")
                        
                    }
                    
                    //self.show(HomeViewController(), sender: nil)
                    
                    self.topController(identifier: "Home")
                    
                    /*if currentUserEmail == Auth.auth().currentUser?.email {
                               
                        self.topController(identifier: "Home")
                           
                    } else {
                        
                        self.topController(identifier: "Create")
                        
                        self.topController(identifier: "Login")
                    }*/
                    
                    //self.performSegue(withIdentifier: "loginToHome", sender: self)
                    
                  }
                }
                 
                
                /*PFUser.logInWithUsername(inBackground: username.text!, password:password.text!) {
                    (user, signupError) -> Void in
                    
                    
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    
                    
                    if user != nil {
                        
                        print("\(PFUser.current()!) is logged in")
                        
                        userEmail = PFUser.current()!.email!
                        
                        currentLoginState = "authorized"
                        
                        self.performSegue(withIdentifier: "loginToHome", sender: self)
                        
                    } else {
                        
                        //self.convertToNewParse()
                        
                        if signupError != nil {
                            
                            error = String(describing: signupError)
                            
                        } else {
                            
                            error = "Please try again later."
                            
                        }
                        
                        self.displayAlert("Could Not Log In", error: error)
                        
                    }
                    
                    signupActive = true
                    
                }*/
                
            }
            
        } else {
            
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if self.emailPasswordReset.text != "" {
                
                Auth.auth().sendPasswordReset(withEmail: emailPasswordReset.text!) { (error) in
                    
                    if let error = error as NSError? {
                    
                        switch AuthErrorCode(rawValue: error.code) {
                    
                        case .userNotFound:
                     
                            print("Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.")
                            
                            self.displayAlert("Error: Could Not Login", error: "The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.")
                            
                        case .invalidEmail:
                        
                            print("Error: The email address is badly formatted.")
                            
                            self.displayAlert("Error: Could Not Login", error: "The email address is badly formatted.")
                            
                        case .invalidRecipientEmail:
                        
                            print("Error: Indicates an invalid recipient email was sent in the request.")
                            
                            self.displayAlert("Error: Could Not Login", error: "Indicates an invalid recipient email was sent in the request.")
                            
                        case .invalidSender:
                       
                            print("Error: Indicates an invalid sender email is set in the console for this action.")
                            
                            self.displayAlert("Error: Could Not Login", error: "Indicates an invalid sender email is set in the console for this action.")
                           
                        case .invalidMessagePayload:
                        
                            print("Error: Indicates an invalid email template for sending update email.")
                            
                            self.displayAlert("Error: Could Not Login", error: "Indicates an invalid email template for sending update email.")
                            
                        default:
                      
                            print("Error message: \(error.localizedDescription)")
                            
                            self.displayAlert("Error: Could Not Login", error: "\(error.localizedDescription)")
                            
                        }
                        
                  } else {
                   
                    print("Reset password email has been successfully sent to \(self.emailPasswordReset.text!).")
                    
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    
                    
                    self.emailPasswordReset.alpha = 0
                    self.password.alpha = 1
                    self.username.alpha = 1
                    self.loginButton.setTitle("Log In", for: UIControl.State())
                    
                    if UserDefaults.standard.string(forKey: "resetPassword") != "yes" {
                        
                        let defaults = UserDefaults.standard
                        defaults.set("yes", forKey: "resetPassword")
                        
                    }
                    
                  }
                }
                
            //PFUser.requestPasswordResetForEmail(inBackground: self.emailPasswordReset.text!)
                
                
                
            } else {
                
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                
                //self.displayAlert("Error: Could Not Login", error: "Please enter email address!")
                
                
                let alert = UIAlertController(title: "Error: Enter email address!", message: "Please enter a valid email address!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                
                
            }
            
        }
     
    }
    
    @objc func doNothing() {
        
        
        //print("Do Nothing!!!!!")
        //print("")
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            print(userEmail)
            
            if(currentUserId.isEmpty == false) {
                
                print("currentUserId: \(currentUserId)")
                
            }
            
            
        } else {
            
            print("Internet connection FAILED")
            
            let alert = UIAlertController(title: "Sorry, no internet connection found.", message: "Warranty Locker requires an internet connection.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again?", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                self.noInternetConnection()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        noInternetConnection()
        
        print("currentUserEmail: \(currentUserEmail)")
        
        //UserDefaults.standard.set("", forKey: "resetPassword")
        
        if UserDefaults.standard.string(forKey: "resetPassword") == nil {
            
            UserDefaults.standard.set("no", forKey: "resetPassword")
            
        }
        
        print("resetPassword: \(UserDefaults.standard.string(forKey: "resetPassword")!)")
        
        resetPasswordAlert()
        
        if (currentUserId == "" && currentUserEmail == "") {
                
                if UserDefaults.standard.string(forKey: "currentId") != nil {
                    
                    currentUserId = UserDefaults.standard.string(forKey: "currentId")!
                    
                    print("currentUserId: \(currentUserId)")
                }
                
                if UserDefaults.standard.string(forKey: "currentEmail") != nil {
                    
                    currentUserEmail = UserDefaults.standard.string(forKey: "currentEmail")!
                    
                    print("currentUserEmail: \(currentUserEmail)")
                }
                
                userEmail = currentUserEmail
                
                if (currentUserId != "" && currentUserEmail != "") {
                    
                    self.performSegue(withIdentifier: "loginToHome", sender: self)
                    
                }
                
            }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // username.resignFirstResponder()
        return true
    }
    
}

public extension UIAlertController {
    
    func topControllerAlert() {
        
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindow.Level.alert + 1  // Swift 3-4: UIWindowLevelAlert + 1
        win.makeKeyAndVisible()
        
        vc.present(self, animated: true, completion: nil)
       
    }
    
}

public extension UIViewController {
    
    func topController(identifier: String) {
        
        let board = UIStoryboard(name: "Main", bundle: nil)
                  
        let initView = board.instantiateViewController(identifier: identifier)
        
        win.rootViewController = initView
        
        //self.present(initView, animated: true)
        
    }
    
}


