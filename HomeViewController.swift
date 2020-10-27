//
//  FirstViewController.swift
//  Warranty Wallet
//
//  Created by Eric Cook on 10/23/14.
//  Copyright (c) 2014 Better Search, LLC. All rights reserved.
//

import UIKit
import Firebase

var array:[String] = [String]()

var parseObjectId = [String]()

var picIdArray = [String]()

var parseImage = String()

var hasPasswordBeenReset = Bool()

var currentUserId = String() //Auth.auth().currentUser?.uid

var currentUserEmail = String() //Auth.auth().currentUser?.email

let db = Firestore.firestore()


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UISearchBarDelegate {
    
    
    @IBOutlet var searchBarText: UISearchBar!
    
    var searchActive : Bool = false
    
    var filtered:[String] = []
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var refreshControl:UIRefreshControl!
    
    @IBOutlet  var tableView:UITableView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var logOut: UIButton!
    
    @IBAction func receiptImage(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "homeToReceiptImage", sender: self)

    }
    
    @IBAction func warrantyImage(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "homeToWarrantyImage", sender: self)
    }
    
    @IBAction func homeToAdd(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "homeToAdd", sender: self)
    }
    
    @IBOutlet var editBtn: UIBarButtonItem!
    
    @IBAction func homeToEdit(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "homeToEdit", sender: self)
    }
    @IBAction func logOutBtn(_ sender: AnyObject) {
        
        newItemItem = []
        modelItem = []
        serialItem = []
        boughtItem = []
        phoneItem = []
        priceItem = []
        purchaseDateItem = []
        endDateItem = []
        notesItem = []
        warrantyItem = []
        receiptItem = []
        parseObjectId = []
        picIdArray = []
        userEmail = ""
        hasPasswordBeenReset = false
        currentUserId = ""
        currentUserEmail = ""
        UserDefaults.standard.removeObject(forKey: "currentId")
        UserDefaults.standard.removeObject(forKey: "currentEmail")
        
        //PFUser.logOut()
        
        logoutUser()
        
        //performSegue(withIdentifier: "homeToLogin", sender: self)
    }
    
    func logoutUser() {
        // call from any screen
        
        do { try Auth.auth().signOut() }
        catch { print("Already logged out.") }
        
        performSegue(withIdentifier: "homeToLogin", sender: self)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        
        if (searchActive) {
            
            return filtered.count
            
        } else {
            
            return newItemItem.count
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        searchBarText.text = ""
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBarText.text = ""
        getWarranties()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = true
    }
    
    var searchProd = [String]()
    
    func getSearchBarWarranties(search: [String]) {
        
        db.collection("Warranties").whereField("newObjectId", isEqualTo: currentUserEmail).whereField("productSearch", in: searchProd).order(by: "endDate", descending: false).getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                
                print("Error getting documents: \(err)")
                
            } else {
                
                for document in querySnapshot!.documents {
                    
                    if let product = document.get("product") as? String {
                        //newItemItem.append(product)
                        print(product)
                    }
                    
                    if let model = document.get("model") as? String {
                        //modelItem.append(model)
                        print(model)
                    }
                    
                    if let serial = document.get("serial") as? String {
                        //serialItem.append(serial)
                        print(serial)
                    }
                    
                    if let bought = document.get("bought") as? String {
                        //boughtItem.append(bought)
                        print(bought)
                    }
                    
                    if let phone = document.get("phone") as? String {
                        //phoneItem.append(phone)
                        print(phone)
                    }
                    
                    if let price = document.get("price") as? String {
                        //priceItem.append(price)
                        print(price)
                    }
                    
                    if let purchaseDate = document.get("purchaseDate") as? String {
                        //purchaseDateItem.append(purchaseDate)
                        print(purchaseDate)
                    }
                    
                    if let endDate = document.get("endDate") as? String {
                        //endDateItem.append(endDate)
                        print(endDate)
                    }
                    
                    if let picId1 = document.get("objectId") as? String {
                        //picIdArray.append(picId1)
                        print(picId1)
                    }
                    
                    if let notes = document.get("notes") as? String {
                        //notesItem.append(notes)
                        //parseObjectId.append(document.documentID)
                        print(notes)
                        print(document.documentID)
                    }
                 
                    //print("\(document.documentID) => \(document.data())")
                    
                    print("Successfully retrieved \(querySnapshot!.documents.count) warranties.")
                    
                    self.tableView.reloadData()
                }
                
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        /*newItemItem = []
        modelItem = []
        serialItem = []
        boughtItem = []
        phoneItem = []
        priceItem = []
        purchaseDateItem = []
        endDateItem = []
        notesItem = []
        warrantyItem = []
        receiptItem = []
        parseObjectId = []
        picIdArray = []*/
        
        //if(filtered.count == 0){
        if searchText.count == 0 {
            
            searchActive = false
            
        } else {
            
            searchActive = true
            
            filtered = newItemItem.filter({ (text) -> Bool in
                
                let tmp: NSString = text as NSString
                
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                
                return range.location != NSNotFound
            })
            
            print("Filtered: \(filtered)")
            
            searchProd = [searchText.lowercased()]
            
            print("search: \(searchProd)")
            
            getSearchBarWarranties(search: searchProd)
            
            /*let query = PFQuery(className:"Warranties")
            query.whereKey("userId", equalTo: PFUser.current()!.objectId!)
            query.whereKey("productSearch", contains: search)
            query.order(byAscending: "endDate")
            
            query.findObjectsInBackground {
                //(objects, error) in
                (results: [PFObject]?, error: Error?) in
                
                if error == nil {
                    
                    print("Successfully retrieved \(results!.count) warranties.")
                    
                    if let objects = results {
                        for object in objects {
                            print(object.objectId!)
                            
                            newItemItem.append(object["product"] as! String)
                            modelItem.append(object["model"] as! String)
                            serialItem.append(object["serial"] as! String)
                            boughtItem.append(object["bought"] as! String)
                            phoneItem.append(object["phone"] as! String)
                            priceItem.append(object["price"] as! String)
                            purchaseDateItem.append(object["purchaseDate"] as! String)
                            endDateItem.append(object["endDate"] as! String)
                            notesItem.append(object["notes"] as! String)
                            warrantyItem.append(object["warranty"] as! PFFile)
                            receiptItem.append(object["receipt"] as! PFFile)
                            parseObjectId.append(object.objectId!)
                            
                        }
                        print(parseObjectId)
                        print(newItemItem)
                        print(modelItem)
                        print(serialItem)
                        print(boughtItem)
                        print(phoneItem)
                        print(priceItem)
                        print(purchaseDateItem)
                        print(endDateItem)
                        print(notesItem)
                    }
                    
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!)")
                }
                
                self.tableView.reloadData()
            }*/
            
        }
        
    }
    
    let reuseIdentifier = "Cell1"
    
    var i = Int()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as UITableViewCell?
        
        cell?.textLabel!.numberOfLines = 0
        
        cell?.textLabel!.lineBreakMode = .byWordWrapping
        
        cell?.textLabel!.font = UIFont.systemFont(ofSize: 18)
        
        if (searchActive == true) {
            
            let array = newItemItem
            
            print("Array: \(array)")
            
            i = array.firstIndex(where: {$0 == "\(filtered[0])"})!

            print("Index: \(i)")
            
            cell?.textLabel!.text = " Search: \(filtered[(indexPath as NSIndexPath).row]) \r Product: \(newItemItem[i]) \r Model #: \(modelItem[i]) \r Serial #: \(serialItem[i]) \r Bought At: \(boughtItem[i]) \r Phone #: \(phoneItem[i]) \r Price: $\(priceItem[i]) \r Purchase Date: \(purchaseDateItem[i]) \r Expire Date: \(endDateItem[i]) \r Notes: \(notesItem[i])"
            
            
            /*if (filtered.count == 0) {
                
                cell?.textLabel!.text = "No items found in search!"
                
            } else {
                
                if filtered.isEmpty {
                    
                    cell?.textLabel!.text = "No items found in search!"
                    
                } else {
                    
                    let array = newItemItem
                    
                    print("Array: \(array)")
                    
                    i = array.firstIndex(where: {$0 == "\(filtered[0])"})!
    
                    print("Index: \(i)")
                    
                    cell?.textLabel!.text = " Search: \(filtered[(indexPath as NSIndexPath).row]) \r Product: \(newItemItem[i]) \r Model #: \(modelItem[i]) \r Serial #: \(serialItem[i]) \r Bought At: \(boughtItem[i]) \r Phone #: \(phoneItem[i]) \r Price: $\(priceItem[i]) \r Purchase Date: \(purchaseDateItem[i]) \r Expire Date: \(endDateItem[i]) \r Notes: \(notesItem[i])"
                    
                }

            }*/
            
        } else {
            
            cell?.textLabel!.text = " Product: \(newItemItem[(indexPath as NSIndexPath).row]) \r Model #: \(modelItem[(indexPath as NSIndexPath).row]) \r Serial #: \(serialItem[(indexPath as NSIndexPath).row]) \r Bought At: \(boughtItem[(indexPath as NSIndexPath).row]) \r Phone #: \(phoneItem[(indexPath as NSIndexPath).row]) \r Price: $\(priceItem[(indexPath as NSIndexPath).row]) \r Purchase Date: \(purchaseDateItem[(indexPath as NSIndexPath).row]) \r Expire Date: \(endDateItem[(indexPath as NSIndexPath).row]) \r Notes: \(notesItem[(indexPath as NSIndexPath).row])"
            
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         if(searchActive == false) {
            
            parseImage = parseObjectId[(indexPath as NSIndexPath).row]
            
            picId = picIdArray[(indexPath as NSIndexPath).row]
            
         } else {
            
            parseImage = parseObjectId[i]  //parseObjectId[(indexPath as NSIndexPath).row]  //parseObjectId[i]
            
            //picId = picIdArray[i]
        }
        
        let alert = UIAlertController(title: "View Photo or Edit", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Receipt Photo", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
            print(parseImage)
            
            self.performSegue(withIdentifier: "homeToReceiptImage", sender: self)
            
        }))
            
        alert.addAction(UIAlertAction(title: "Warranty Photo", style: .default, handler: { action in
                
            alert.dismiss(animated: true, completion: nil)
            
            print(parseImage)
            
            self.performSegue(withIdentifier: "homeToWarrantyImage", sender: self)
            
        }))
            
        alert.addAction(UIAlertAction(title: "Edit Warranty", style: .default, handler: { action in
                
            alert.dismiss(animated: true, completion: nil)
            
            picId = picIdArray[(indexPath as NSIndexPath).row]
            
            print("picId: \(picId)")
            
            self.performSegue(withIdentifier: "homeToEdit", sender: self)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
            self.searchActive = false
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        if(searchActive == true) {
            
            parseObjectIdEdit = parseObjectId[i]
            
            newItemEdit = newItemItem[i]
            modelEdit = modelItem[i]
            serialEdit = serialItem[i]
            boughtEdit = boughtItem[i]
            phoneEdit = phoneItem[i]
            priceEdit = priceItem[i]
            purchaseDateEdit = purchaseDateItem[i]
            endDateEdit = endDateItem[i]
            notesEdit = notesItem[i]
            //picIdEdit = picIdArray[(indexPath as NSIndexPath).row]
            //warrantyEdit = [warrantyItem[(indexPath as NSIndexPath).row]]
            //receiptEdit = [receiptItem[(indexPath as NSIndexPath).row]]
            
            performSegue(withIdentifier: "homeToEdit", sender: self)
            
        } else {
            
            parseObjectIdEdit = parseObjectId[(indexPath as NSIndexPath).row]
            
            newItemEdit = newItemItem[(indexPath as NSIndexPath).row]
            modelEdit = modelItem[(indexPath as NSIndexPath).row]
            serialEdit = serialItem[(indexPath as NSIndexPath).row]
            boughtEdit = boughtItem[(indexPath as NSIndexPath).row]
            phoneEdit = phoneItem[(indexPath as NSIndexPath).row]
            priceEdit = priceItem[(indexPath as NSIndexPath).row]
            purchaseDateEdit = purchaseDateItem[(indexPath as NSIndexPath).row]
            endDateEdit = endDateItem[(indexPath as NSIndexPath).row]
            notesEdit = notesItem[(indexPath as NSIndexPath).row]
            parseImage = parseObjectId[(indexPath as NSIndexPath).row]
            //picIdEdit = picIdArray[(indexPath as NSIndexPath).row]
            self.searchActive = false
            
            performSegue(withIdentifier: "homeToEdit", sender: self)
            
        }
        
    }
    
    
    
    /*var email1 = String()
    
    var userId1 = String()
    
    var fbArray = [String:String]()
    
    var fbEmail = [String]()
    
    var fbId = [String]()
    
    @objc func updateWarrantiesInFirebase() {
        
        print(fbEmail)
        
        print(fbId)
        
        var count = 0
        
        for email2 in fbEmail {
            
            email1 = email2
            
            userId1 = fbId[count]
            
            print("Email: \(email1)")
            print("Id: \(userId1)")
            print("Count: \(count)")
            
            db.collection("Warranties").whereField("userId", isEqualTo: fbId[count]).getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    
                    print("Error getting documents: \(err)")
                    
                } else {
                    
                    for document in querySnapshot!.documents {
                        
                        document.reference.updateData([
                            "updated": true,
                            "newObjectId" : email2  //self.email1
                        ])
                        
                        /*let document2 = querySnapshot!.documents.first
                        document2!.reference.updateData([
                            "updated": true,
                            "newObjectId" : self.email1
                        ])*/
                        
                        //print("Successfully retrieved \(email2) to update.")
                        
                        
                    }
                    
                    print("Successfully retrieved \(email2) to update from \(self.userId1).")
                }
                
            }
            
            count = count + 1
       }
        
    }
    
    func updateToFirebase() {
        
        fbEmail = []
        
        fbId = []
        
        db.collection("users").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                
                print("Error getting documents: \(err)")
                
            } else {
                
                for document in querySnapshot!.documents {
                    
                    if let email = document.get("email") as? String {
                        //self.email1 = email
                        self.fbEmail.append(email)
                        print(email)
                    }
                    
                    if let id1 = document.get("_id") as? String {
                        //self.userId1 = id
                        self.fbId.append(id1)
                        print(id1)
                    }
                    
                    /*Auth.auth().createUser(withEmail: email1, password: password1) { authResult, error in
                        if let error = error as NSError? {
                        switch AuthErrorCode(rawValue: error.code) {
                        case .operationNotAllowed:
                        
                            print("Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.")
                            
                        case .emailAlreadyInUse:
                          
                            print("Error: The email address is already in use by another account.")
                            
                        case .invalidEmail:
            
                            print("Error: The email address is badly formatted.")
                            
                        case .weakPassword:
                          
                            print("Error: The password must be 6 characters long or more.")
                            
                        default:
                            print("Error: \(error.localizedDescription)")
                        }
                      } else {
                        
                        self.activityIndicator.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        
                        print("User \(email1) successfully created.")
                        //currentUserId = Auth.auth().currentUser!.uid
                        //currentUserEmail = (Auth.auth().currentUser?.email)!
                        
                        //self.updateParse()
                        
                        //self.performSegue(withIdentifier: "createToHome", sender: self)
                        
                      }
                    }*/
                        
                }
                
                //self.updateWarrantiesInFirebase()
                
            }
            
        }
       
    }*/
    
    func getPicId() {
        
        db.collection("Warranties").whereField("newObjectId", isEqualTo: currentUserEmail).order(by: "endDate", descending: true).getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                
                print("Error getting documents: \(err)")
                
            } else {
                
                for document in querySnapshot!.documents {
                    
                    if let picId1 = document.get("objectId") as? String {
                        picId = picId1
                        print(picId)
                    }
                
                    print("")
                    
                    print("\(document.documentID) => \(document.data())")
                    
                    //print("Successfully retrieved \(parseObjectId.count) warranties.")
                }
                
                print("Successfully retrieved \(picId) as the warranty's picId.")
                
                //self.tableView.reloadData()
            }
        }
    }
    
    func getWarranties() {
        
        newItemItem = []
        modelItem = []
        serialItem = []
        boughtItem = []
        phoneItem = []
        priceItem = []
        purchaseDateItem = []
        endDateItem = []
        notesItem = []
        warrantyItem = []
        receiptItem = []
        parseObjectId = []
        picIdArray = []
        
        db.collection("Warranties").whereField("newObjectId", isEqualTo: currentUserEmail).order(by: "endDate", descending: true).getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                
                print("Error getting documents: \(err)")
                
            } else {
                
                for document in querySnapshot!.documents {
                    
                    if let product = document.get("product") as? String {
                        newItemItem.append(product)
                        print(product)
                    }
                    
                    if let model = document.get("model") as? String {
                        modelItem.append(model)
                        print(model)
                    }
                    
                    if let serial = document.get("serial") as? String {
                        serialItem.append(serial)
                        print(serial)
                    }
                    
                    if let bought = document.get("bought") as? String {
                        boughtItem.append(bought)
                        print(bought)
                    }
                    
                    if let phone = document.get("phone") as? String {
                        phoneItem.append(phone)
                        print(phone)
                    }
                    
                    if let price = document.get("price") as? String {
                        priceItem.append(price)
                        print(price)
                    }
                    
                    if let purchaseDate = document.get("purchaseDate") as? String {
                        purchaseDateItem.append(purchaseDate)
                        print(purchaseDate)
                    }
                    
                    if let endDate = document.get("endDate") as? String {
                        endDateItem.append(endDate)
                        print(endDate)
                    }
                    
                    if let picId1 = document.get("objectId") as? String {
                        picIdArray.append(picId1)
                        print(picId1)
                    }
                    
                    if let notes = document.get("notes") as? String {
                        notesItem.append(notes)
                        parseObjectId.append(document.documentID)
                        print(notes)
                        print(document.documentID)
                    }
                    
                    /*if let _ = document.get(document.documentID) {
                        parseObjectId.append(document.documentID)
                        //print(fbObjectId)
                        print(document.documentID)
                    }*/
                    
                    
                    
                    
                    print("")
                    
                    //print("\(document.documentID) => \(document.data())")
                    
                    //print("Successfully retrieved \(parseObjectId.count) warranties.")
                }
                
                print("Successfully retrieved \(querySnapshot!.documents.count) warranties.")
                
                self.tableView.reloadData()
            }
        }
        
        
        
        
        /*let query = PFQuery(className:"Warranties")
        //query.whereKey("userId", equalTo: self.oldObjectId)
        query.whereKey("userId", equalTo: PFUser.current()!.objectId!)
        query.order(byDescending: "endDate")
        query.findObjectsInBackground { [self]
            (results: [PFObject]?, error: Error?) in
            //(objects, error) in
            
            if error == nil {
                
                print("Successfully retrieved \(results!.count) warranties.")
            
                if let objects = results {
                
                for object in objects {
                    
                        print(object.objectId!)
                    
                        newItemItem.append(object["product"] as! String)
                        modelItem.append(object["model"] as! String)
                        serialItem.append(object["serial"] as! String)
                        boughtItem.append(object["bought"] as! String)
                        phoneItem.append(object["phone"] as! String)
                        priceItem.append(object["price"] as! String)
                        purchaseDateItem.append(object["purchaseDate"] as! String)
                        endDateItem.append(object["endDate"] as! String)
                        notesItem.append(object["notes"] as! String)
                        warrantyItem.append(object["warranty"] as! PFFile)
                        receiptItem.append(object["receipt"] as! PFFile)
                        parseObjectId.append(object.objectId!)
                        
                    }
                    print(parseObjectId)
                    print(newItemItem)
                    print(modelItem)
                    print(serialItem)
                    print(boughtItem)
                    print(phoneItem)
                    print(priceItem)
                    print(purchaseDateItem)
                    print(endDateItem)
                    print(notesItem)
                }
               
                
            } else {
                
                print("Error: \(error!)")
            }
            
            self.tableView.reloadData()
            
        }*/
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(HomeViewController.refresh(_:)), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl)
        
        scrollView.contentSize.height = 667
        scrollView.contentSize.width = 250
        
        searchBarText.delegate = self
       
    }
    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            if currentUserEmail != "" && currentUserId != "" {
                
            } else {
                
                currentUserId = Auth.auth().currentUser!.uid
                currentUserEmail = (Auth.auth().currentUser?.email)!
                
                print("currentUserEmail: \(currentUserEmail)")
                print("currentUserId: \(currentUserId)")
                
            }
            
            newItemItem = []
            modelItem = []
            serialItem = []
            boughtItem = []
            phoneItem = []
            priceItem = []
            purchaseDateItem = []
            endDateItem = []
            notesItem = []
            parseObjectId = []
            picIdArray = []
            
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
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        //currentUserEmail = Auth.auth().currentUser?.email
        
        //print("currentUserEmail: \(String(describing: currentUserEmail!))")
                                          
        if currentUserEmail == Auth.auth().currentUser?.email {
                   
            noInternetConnection()
            
            getWarranties()
                    
            pushNotification()
            
            //_ = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.updateWarrantiesInFirebase), userInfo: nil, repeats: false)
            
            activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
        } else {
            
            activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            self.performSegue(withIdentifier: "homeToLogin", sender: self)
            
        }
        
    }
    
    @objc func refresh(_ sender:AnyObject){
        
        newItemItem = []
        modelItem = []
        serialItem = []
        boughtItem = []
        phoneItem = []
        priceItem = []
        purchaseDateItem = []
        endDateItem = []
        notesItem = []
        parseObjectId = []
        picIdArray = []
        
        getWarranties()
        self.tableView.reloadData()
        
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        
        self.refreshControl!.endRefreshing()
        
    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            
            db.collection("Warranties").document(parseObjectId[(indexPath as NSIndexPath).row]).getDocument() { (document, err) in
                
                if let document = document, document.exists {
                        //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    document.reference.delete()
                       
                    print("\(String(describing:document.documentID)) => \(String(describing: document.data() ))")
                    
                    
                    
                    } else {
                        
                        print("Document does not exist: \(String(describing: err))")
                    }
                
                self.tableView.reloadData()
            }
            
            self.tableView.reloadData()
                
                /*if let err = err {
                    
                    print("Error getting documents: \(err)")
                    
                } else {
                    
                    for item in document {
                        
                        item.reference.delete()
                        
                        print("\(item.documentID) => \(item.data())")
                        
                    }
                    
                    print("Successfully retrieved 1 warranty to delete.")
                    
                    self.tableView.reloadData()
                }
            }*/
            
           
            
           /* let query = PFQuery(className:"Warranties")
            query.whereKey("objectId", equalTo: parseObjectId[(indexPath as NSIndexPath).row])
            query.findObjectsInBackground {
                (results: [PFObject]?, error: Error?) in
                //(objects, error) in
                
                if error == nil {
                    
                    print("Successfully retrieved \(results!.count) warranty for deleting.")
                
                    if let objects = results {
                    
                    for object in objects {
                            
                            print(object.objectId!)
                            
                            object.deleteInBackground()
                            
                        }
                       
                        print("Successfully deleted warranty.")
                        
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!)")
                }
                self.tableView.reloadData()
            }*/
            
            
        }
        self.tableView.reloadData()
    }
    
    func pushNotification() {
        
        var product = String()
        var model = String()
        var expDate = String()
        
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let currentDate = dateFormatter.string(from: date)
        print(currentDate)
        
        db.collection("Warranties").whereField("newObjectId", isEqualTo: currentUserEmail).whereField("endDate", isLessThanOrEqualTo: currentDate).whereField("pushSent", isEqualTo: "no").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                
                print("Error getting documents: \(err)")
                
            } else {
                
                for document in querySnapshot!.documents {
                    
                    product = document.get("product") as! String
                    
                    model = document.get("model") as! String
                    
                    expDate = document.get("endDate") as! String
                    
                    //print("\(product.count) Push notifications being sent.")
                    
                    if expDate != "" {
                        
                        let alert = UIAlertController(title: "A Warranty Has Expired", message: "Your warranty for \(product) \(model) has expired on \(expDate).", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            
                            alert.dismiss(animated: true, completion: nil)
                            
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        document.reference.updateData([
                            "pushSent": "yes"
                        ])
                        
                    } else {
                        
                       print("expDate is empty")
                    }
                   
                    
                    
                }
                
                //print("Successfully retrieved User to update.")
                
                //print("\(document.documentID) => \(document.data())")
                
                print("Successfully retrieved \(product.count) warranties for push.")
            }
        }
        
        
        /*let pushQuery = PFQuery(className: "Warranties")
        pushQuery.whereKey("userId", equalTo: PFUser.current()!.objectId!)
        pushQuery.whereKey("endDate", notEqualTo: "")
        pushQuery.whereKey("endDate", lessThanOrEqualTo: currentDate)
        pushQuery.whereKey("pushSent", notEqualTo: "yes")
        pushQuery.findObjectsInBackground {
            //(results: [PFObject]?, error: Error?) in
            (objects, error) in
            
            if error == nil {
                
                print("Successfully retrieved \(objects!.count) warranties for push.")
            
                if let objects = objects {
                
                for object in objects {
                        print(object.objectId!)
                        product = object["product"] as! String
                        model = object["model"] as! String
                        expDate = object["endDate"] as! String
                        
                        print("\(objects.count) Push notifications being sent.")
                       
                        let alert = UIAlertController(title: "A Warranty Has Expired", message: "Your warranty for \(product) \(model) has expired on \(expDate).", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            
                            alert.dismiss(animated: true, completion: nil)
                            
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        object["pushSent"] = "yes"
                        object.saveInBackground()
                        
                    }
               }
            } else {
               
                print("Error: \(error!) ")
            }
        }*/

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
        self.scrollView.endEditing(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

