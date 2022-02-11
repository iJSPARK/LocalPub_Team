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
    
    var selectedCountryCode = countryCodeInfos[0]
    
    @IBOutlet var navLoginPhone: UINavigationItem!
    
    @IBOutlet var txtPhoneNo: UITextField!
    @IBOutlet var txtPhoneCode: UITextField!
    
    @IBOutlet var btnSendPhoneVerificationCode: UIButton!
    @IBOutlet var btnPhoneVerification: UIButton!
    @IBOutlet weak var countryCodeButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // textField 값 읽어 들이기
        // Oulet 없이 실행
        // Target: txtPhoneCode 눌렀을때 실행할 함수가 있는 object (self)
        // #selector: 실행할 함수 선택
        // text 값 바뀔때마다 글자수 감시
        txtPhoneCode.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        SetLocalized()
        btnPhoneVerification.isEnabled = false
        txtPhoneNo.text = myUserDefaults.string( forKey: UserDefault.PhoneNo.toString() )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(selectedCountryCode)
        let text = NSAttributedString(string: selectedCountryCode.countryEmoji + selectedCountryCode.countryCode, attributes: [.font: UIFont.systemFont(ofSize: 15)])
        countryCodeButton.setAttributedTitle(text, for: .normal)
    }
    
    // 6 자리면 승인 버튼 ON
    @objc func textFieldDidChange(textField: UITextField) {
        guard textField.text?.count == 6 else { return }
        btnPhoneVerification.isEnabled = true
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
 
    // Cell IBA 연결이 안됨
    @IBAction func unwindToLoginPhone(_ unwindSegue: UIStoryboardSegue) {
        //let sourceViewController = unwindSegue.source
    }
}


