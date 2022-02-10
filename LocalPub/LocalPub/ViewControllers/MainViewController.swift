//
//  mainViewController.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/01/19.
//

import UIKit
import Firebase

class mainViewController: UIViewController {

    let db: Firestore = Firestore.firestore()
    
    let myUserDefaults = UserDefaults.standard
    
    @IBOutlet var lblCurrentLanguage: UILabel!
    
    @IBOutlet var btnLogOut: UIButton!
    
    @IBOutlet var btnLoginPhone: UIButton!
    @IBOutlet var btnAgreement: UIButton!
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var btnLanguage: UIButton!
    @IBOutlet var btnIntroduce: UIButton!
    @IBOutlet var btnHome: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SetLocalized()
        
        if let user = Auth.auth().currentUser {
            
            print( "Aleady Logined! - eMail:\(user.email ?? "") / Phone:  \(user.phoneNumber ?? "")")
        
        } else {
            
            self.LogOut()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Login Page에서 로그인 성공시
        if myUserDefaults.integer( forKey: UserDefault.Login.toString() ) == 1 {
            LogIn()
        }
        
    }
    
    func SetLocalized() {

        let locale = NSLocale.autoupdatingCurrent
        let languageCode = locale.languageCode!
        let language = locale.localizedString(forLanguageCode: languageCode)!
        let currentLanguage = String( format: NSLocalizedString( "CurrentLanguage", comment: "Current Language") )
        
        lblCurrentLanguage.text = " \(currentLanguage) : \(language)(\(languageCode))"
        
        Auth.auth().languageCode = languageCode;
        
        btnLogOut.setTitle( "Logout".localized(), for: .normal )
        
        btnLoginPhone.setTitle( "Login".localized(), for: .normal)
        btnAgreement.setTitle( "Agreement".localized(), for: .normal)
        btnProfile.setTitle( "ProfileInformation".localized(), for: .normal)
        btnLanguage.setTitle( "SelectLanguages".localized(), for: .normal)
        btnIntroduce.setTitle( "SelfIntroduce".localized(), for: .normal)
        btnHome.setTitle( "Home".localized(), for: .normal)
        
    }
    
    
    func LogIn() {
        
        print( "login success" )
        
        btnLogOut.layer.isHidden = false
        
        btnLoginPhone.layer.isHidden = false
        btnAgreement.layer.isHidden = false
        
        btnProfile.layer.isHidden = false
        btnLanguage.layer.isHidden = false
        btnIntroduce.layer.isHidden = false
        btnHome.layer.isHidden = false

//      if let dvc = self.storyboard?.instantiateViewController(identifier: "loginViewController" ) {
//         self.present(dvc, animated: true, completion: nil)
//      }
        
    }
    
    func LogOut() {
        
        do {
            try Auth.auth().signOut()
            print( "Sign out complete!")
            
            LogClear()
            
        } catch {
            print( "Sign out error")
        }
        
        SaveUserDefault( key: UserDefault.Login.toString(), value: 0 )
    }
    
    func LogClear() {
        
        btnLogOut.layer.isHidden = true
        
        btnProfile.layer.isHidden = true
        btnLanguage.layer.isHidden = true
        btnIntroduce.layer.isHidden = true
        btnHome.layer.isHidden = true
        
    }
    
    @IBAction func LogOut(_ sender: UIButton) {
        
        LogOut()
        
    }
    
    @IBAction func imageTest(_ sender: UIButton) {
        
        let image = UIImage( named: "password.png" )
        
        uploadImage( filePath: "PW", img: image! ) { url in
            print( "url: \(url)" )
        }

    }
    
}
    


