//
//  ViewController.swift
//  CloudRook
//
//  Created by Brad Caldwell on 12/13/16.
//  Copyright © 2016 Caldwell Contracting LLC. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuthUI
import FirebaseDatabaseUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import Bolts
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FUIAuthDelegate {
    
    var googleStuff = ["https://www.googleapis.com/auth/plus.login", "https://www.googleapis.com/auth/plus.me", "https://www.googleapis.com/auth/userinfo.email", "https://www.googleapis.com/auth/userinfo.profile"]
    
    var ref: FIRDatabaseReference!


    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var player1Card: UIImageView!
    
    @IBOutlet weak var player2Card: UIImageView!
    
    @IBOutlet weak var player3Card: UIImageView!
    
    @IBOutlet weak var player4Card: UIImageView!
    
    @IBOutlet weak var player1ProfilePic: UIImageView!
    
    @IBOutlet weak var player2ProfilePic: UIImageView!
    
    @IBOutlet weak var player3ProfilePic: UIImageView!
    
    @IBOutlet weak var player4ProfilePic: UIImageView!
    
    @IBOutlet weak var cardTable: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLoggedIn()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func checkLoggedIn() {
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                self.ref = FIRDatabase.database().reference()
                if user?.photoURL == nil {
                    self.profilePic.image = UIImage(named: "CloudRookSignIn")
                }else{
                        DispatchQueue.global(qos: .default).async(execute: { 
                            var imageUrl = NSData(contentsOf: (user?.photoURL)!)
                            if let data = imageUrl {
                                DispatchQueue.main.async {
                                    self.profilePic.image = UIImage(data: data as Data)
                                    self.player1ProfilePic.image = UIImage(data: data as Data)
                                    self.player2ProfilePic.image = UIImage(named: "inviteAPlayer")
                                    self.player3ProfilePic.image = UIImage(named: "inviteAPlayer")
                                    self.player4ProfilePic.image = UIImage(named: "inviteAPlayer")
                                    self.player1Card.image = UIImage(named: "Yellow1")
                                    self.player2Card.image = UIImage(named: "TheRook")
                                    //self.player3Card.image = UIImage(named: "Yellow8")
                                    //self.player4Card.image = UIImage(named: "Green14")
                                    self.cardTable.image = UIImage(named: "cardTable")
                                    
                                    //print("This is the imageURL: " + String(describing: user?.photoURL))
                                
                                    
                                }
                            }
                        })
                    
                    
                }
            } else {
                // No user is signed in.
                self.login()
            }
        }
    }
    
    let authUI = FUIAuth.defaultAuthUI()
    
    func login() {
        
        //let googleProvider = FUIGoogleAuth(scopes: googleStuff)
        //let facebookProvider = FUIFacebookAuth(permissions: ["public_profile"])
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [
        FUIGoogleAuth(),
        FUIFacebookAuth(),
        ]
        self.authUI?.providers = providers
        //authUI?.providers = [googleProvider, facebookProvider]
        
        
       
        //let authViewController = CloudRookAuthViewController(coder: <#T##NSCoder#>)
        //let navc = UINavigationController(rootViewController: authViewController)
        //self.present(navc, animated: true, completion: nil)
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return CloudRookAuthViewController(authUI: authUI)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if error != nil {
            //Problem signing in
            login()
        }else {
            //User is in! Here is where we code after signing in
            if let unwrappedUrl = user?.photoURL {
                //print(unwrappedUrl)
                self.ref.child("users").child((user?.uid)!).setValue(["username": user?.displayName, "pic": String(describing: unwrappedUrl) as Any, "email": user?.email])
            }else {
                self.ref.child("users").child((user?.uid)!).setValue(["username": user?.displayName, "pic": nil, "email": user?.email])
            }
        }
    }

    @IBAction func masAmigosPressed(_ sender: Any) {
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let values = snapshot.value as? NSDictionary
            var myUserArray: [String] = []
            if let theUsers = values?.allKeys {
                for theUser in theUsers {
                    myUserArray.append(theUser as! String)
                }
            }
            for index in 0..<myUserArray.count {
                //print(myUserArray[index])
                if let userJunk = values?[myUserArray[index]] {
                    print(userJunk)
                }
                }
            print(values?["0AUKdJmfrcXBqOonAPyRpnsosk92"])
            
            

            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        do {
            try authUI?.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    

  


}

