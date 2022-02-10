//
//  LoginMailViewController.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/01/31.
//

import UIKit
import Firebase

class loginEmailViewController: UIViewController {

    let db: Firestore = Firestore.firestore()
    
    let myUserDefaults = UserDefaults.standard
    
    @IBOutlet var navLoginEmail: UINavigationItem!
    
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var lblEmailPW: UILabel!
    @IBOutlet var txtEmailPW: UITextField!
    
    @IBOutlet var btnEmailJoin: UIButton!
    @IBOutlet var btnEmailLogin: UIButton!
    //@IBOutlet var btnEmailVerification: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SetLocalized()
        
        txtEmail.text = myUserDefaults.string( forKey: UserDefault.eMail.toString() )
        txtEmailPW.text = myUserDefaults.string( forKey: UserDefault.eMailPW.toString() )
        
    }
    
    func SetLocalized() {
        
        navLoginEmail.title = "Login".localized()
        
        lblEmail.text = "eMail".localized()
        lblEmailPW.text = "PW".localized()
        
        txtEmail.placeholder = "InputEmail".localized()
        txtEmailPW.placeholder = "InputPW".localized()

        btnEmailJoin.setTitle( "Join".localized(), for: .normal )
        btnEmailLogin.setTitle( "Login".localized(), for: .normal )

        //btnEmailVerification.setTitle( "Verification".localized(), for: .normal )
        
    }
    
    func LogIn() {
        
        print( "login success" )
        
        SaveUserDefault( key: UserDefault.Login.toString(), value: 1 )

    }
    
    @IBAction func eMailVerification(_ sender: UIButton) {
        
        print( "eMailVerification ------------" )
        
        guard let email = txtEmail.text else { return }
         
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://localpub-99413.firebaseapp.com/?email=\(email)")
        //actionCodeSettings.url = URL(string: "https://localpub-99413.web.app")
        actionCodeSettings.handleCodeInApp = true
        //actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)

        //Auth.auth().
        Auth.auth().sendSignInLink(toEmail: email,
                                actionCodeSettings: actionCodeSettings) { error in
            if let error = error {
             print( "email not sent : \(error.localizedDescription)" )
            } else {
             print( "email sent" )
            }
        }
        
    }
    
    @IBAction func eMailJoin(_ sender: UIButton) {
        
        print( "eMailJoin ------------" )
        
        guard let id = txtEmail.text else {
            return
        }
        guard let pw = txtEmailPW.text else {
            return
        }

        Auth.auth().createUser( withEmail: id, password: pw ) {
            ( authResult, error ) in
        
            if let error = error {
                
                print( "Error: \(error.localizedDescription)" )
                
                if let errorCode : AuthErrorCode = AuthErrorCode( rawValue: error._code ) {
                    
                    print ("* errorCode : \(errorCode.rawValue)")
                    
                    switch errorCode.rawValue {
                        
                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                        AlertOK( title: "JoinError".localized(), message: "EmailAleadyInUse".localized(), viewController: self )

                    case AuthErrorCode.weakPassword.rawValue:
                        AlertOK( title: "JoinError".localized(), message: "WeekPassword".localized(), viewController: self )
                        
                    default:
                        AlertOK( title: "JoinError".localized(), message: error.localizedDescription, viewController: self )

                    }
                }
                
            }
            
            guard let user = authResult?.user else {
                return
            }

            print( "User: \(user)" )
            
            user.sendEmailVerification( completion: { ( error ) in
                
                if let error = error {
                    
                    print( "* Email verification error: \(error.localizedDescription)" )
                    
                } else {
                    
                    AlertOK( title: "CheckEmailVerification".localized(), message: "SentEmailVerification".localized(), viewController: self )
  
                }
                
            })

        }
    }

    
    @IBAction func eMailLogin(_ sender: UIButton) {
        
        print( "eMailLogin ------------" )
        
        Auth.auth().signIn( withEmail: txtEmail.text!, password: txtEmailPW.text! ) { ( authResult, error ) in

            if let user = authResult?.user {
                
                if user.isEmailVerified {
                    
                    print( "Email has been verified!")
                    
                    let uid = self.myUserDefaults.string( forKey: UserDefault.UID.toString() ) ?? ""
                    
                    if uid != user.uid {
                        
                        GetUserDefault( user: user, eMailPW: self.txtEmailPW.text! )
                        
                    } else {
                        
                        //print( "Check UID: \(user.uid) = \(self.myUserDefaults.string( forKey: "UID" )! )" )
                        print( "Hi! \( user.email! )" )
                        
                        //      SaveUserDefault( key: UserDefault.SignedInDate.toString(), value: user.metadata.lastSignInDate! )
                        SaveUserDefault( key: UserDefault.SignedInDate.toString(), value: Date() )
                    
                    }
                    
                    self.LogIn()
                    
                } else {
                    
                    AlertOK( title: "CheckEmailVerification".localized(), message: "NotEmailVerification".localized(), viewController: self )

                }

            } else{

                print( "login fail" )
                
                AlertOK( title: "LoginError".localized(), message: "", viewController: self )

            }

        }

        
    }
    

}


