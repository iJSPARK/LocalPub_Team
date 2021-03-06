//
//  LoginPhoneViewController.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/01/31.
//

import UIKit
import Firebase

class loginPhoneViewController: UIViewController {
    
    let db: Firestore = Firestore.firestore()
    
    let myUserDefaults = UserDefaults.standard
    
    var selectedCountryCode = countryInfo[0]
    
    @IBOutlet weak var phoneVerificationLabel: UILabel!
    
    @IBOutlet weak var phoneVerificationDescriptionLabel: UILabel!
    
    @IBOutlet var navLoginPhone: UINavigationItem!
    
    @IBOutlet var txtPhoneNo: UITextField! 
    @IBOutlet var txtPhoneCode: UITextField!
    
    @IBOutlet var btnSendPhoneVerificationCode: UIButton!
    @IBOutlet var btnPhoneVerification: UIButton!
    @IBOutlet weak var countryCodeButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        txtPhoneCode.addTarget(self, action: #selector(textFieldDidChanged(textField:)), for: .editingDidEnd)
        SetLocalized()
        btnPhoneVerification.isEnabled = false
        txtPhoneNo.text = myUserDefaults.string( forKey: UserDefault.PhoneNo.toString() )
    }
    
    // 6 자리면 승인 버튼 ON
    @objc func textFieldDidChanged(textField: UITextField) {
        if textField.text?.count == 6 {
            btnPhoneVerification.isEnabled = true
        } else {
            btnPhoneVerification.isEnabled = false
        }
    }
        
    // 화면 터치시 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }
    
    // setLocalized
    func SetLocalized() {
        navLoginPhone.title = "Login".localized()
        txtPhoneNo.placeholder = "InputPhone".localized()
        txtPhoneCode.placeholder = "InputVerificationCode".localized()
        btnPhoneVerification.setTitle( "Verification".localized(), for: .normal )
        btnSendPhoneVerificationCode.setTitle("Send", for: .normal)
        phoneVerificationLabel.text = "PhoneVerification".localized()
        phoneVerificationDescriptionLabel.text = "PhoneVerificationDescription".localized()
    }
    
    func LogIn() {
        
        print( "login success" )
        
        SaveUserDefault( key: UserDefault.Login.toString(), value: 1 )
        
    }
    
    @IBAction func sendPhoneVerificationPhoneCode(_ sender: UIButton) {
        
        
        guard let phoneNumber = txtPhoneNo.text else {
            return
        }
    
        let phoneNo = selectedCountryCode.countryCode + phoneNumber
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber( phoneNo, uiDelegate: nil ) { ( verificationID, error ) in
                
            self.txtPhoneCode.text = ""
        
            self.myUserDefaults.set( phoneNo, forKey: UserDefault.PhoneNo.toString() )
                
            if let error = error {
                
                print( "* Phone verification error: \(error.localizedDescription)" )
                
                self.myUserDefaults.set( "", forKey: UserDefault.PhoneVerificationID.toString() )
                
            } else {

                self.myUserDefaults.set( verificationID, forKey: UserDefault.PhoneVerificationID.toString() )
                
                AlertOK( title: "CheckPhoneVerification".localized(), message: "SentPhoneVerification".localized(), viewController: self )

            }

        }
        
    }
    
    @IBAction func phoneVerification(_ sender: UIButton) {
        
        guard let verificationCode = txtPhoneCode.text else {
            return
        }
        
        guard let verificationID = myUserDefaults.string( forKey: UserDefault.PhoneVerificationID.toString() ) else {
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID,
          verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { ( authResult, error ) in
        
            if let user = authResult?.user {
                
                let uid = self.myUserDefaults.string( forKey: UserDefault.UID.toString() ) ?? ""
                
                if uid != user.uid {
                    
                    GetUserDefault( user: user, eMailPW: "" )
                
                } else {
                    
                    SaveUserDefault( key: UserDefault.SignedInDate.toString(), value: Date() )
                }
                
                print( "Hi! \(user.phoneNumber!) has been verified!")
                
                AlertOK( title: "VerificationSuccess".localized(), message: "SuccessPhoneVerification".localized(), viewController: self )
                
                self.LogIn()
                    
            } else {

                print( "login fail" )
                
//              self.AlertOK( title: "CheckPhoneVerification".localized(), message: "NotPhoneVerification".localized() )
                AlertOK( title: "VerificationError".localized(), message: "NotPhoneVerification".localized(), viewController: self )

            }
            
        }
            
    }
 
    @IBAction func unwindToLoginPhone(_ unwindSegue: UIStoryboardSegue) {
        // let sourceViewController = unwindSegue.source
        
        let text = selectedCountryCode.countryEmoji + " " + selectedCountryCode.countryCode
        countryCodeButton.setTitle(text, for: .normal)
    }
}


