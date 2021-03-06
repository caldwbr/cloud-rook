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
import SwiftyJSON

class ViewController: UIViewController, FUIAuthDelegate {
    
    var googleStuff = ["https://www.googleapis.com/auth/plus.login", "https://www.googleapis.com/auth/plus.me", "https://www.googleapis.com/auth/userinfo.email", "https://www.googleapis.com/auth/userinfo.profile"]
    
    var ref: FIRDatabaseReference!
    var users = [User]()
    var authUI: FUIAuth?
//    let authUI = FIRAuth.auth()


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
        if(FIRAuth.auth()?.currentUser != nil){
            self.downloadFriendsList()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func checkLoggedIn() {
        authUI = FUIAuth.defaultAuthUI()
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                //self.downloadFriendsList()
                //self.downloadFriendsList()
                self.ref = FIRDatabase.database().reference()
//                self.downloadFriendsList()
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
    
    
    
    func login() {
        //let googleProvider = FUIGoogleAuth(scopes: googleStuff)
        //let facebookProvider = FUIFacebookAuth(permissions: ["public_profile"])
        if let authUI = authUI {
        authUI.delegate = self
        let providers: [FUIAuthProvider] = [
        FUIGoogleAuth(),
        FUIFacebookAuth(),
        ]
        authUI.providers = providers
        //authUI?.providers = [googleProvider, facebookProvider]
        
        
       
        let authViewController = CloudRookAuthViewController(authUI: authUI)
        let navc = UINavigationController(rootViewController: authViewController)
        self.present(navc, animated: true, completion: nil)
        }
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
        self.performSegue(withIdentifier: "friendList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendList"{
            if let navBar = segue.destination as? UINavigationController{
                let friendList = navBar.topViewController as? friendListTableViewController
                friendList?.potentialFriends = self.users
            }

        }
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        do {
            try authUI?.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    
    func downloadFriendsList(){
        let ref2 = FIRDatabase.database().reference()
        ref2.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                print("Snapshot Count")
                print(snapshots.count)
                for snap in snapshots
                {
                    //print(snap.value)
                    let user = User(userObject: JSON(snap.value))
                    self.users.append(user)

                }
                
                print(self.users[0].email)
                print(self.users.count)
                let abstractCardDeck = DeckOfCards()
                let aCardDeck: [Card] = abstractCardDeck.createDeck()
                print(aCardDeck)
                print(aCardDeck[3].cardColor)
                print(aCardDeck[20].cardColor)
                print(aCardDeck[20].cardNumber)
                print(aCardDeck[3].cardColor)
                print(aCardDeck[3].cardColor)
            }

        }) { (error) in
            print(error.localizedDescription)
        }
    }


}

