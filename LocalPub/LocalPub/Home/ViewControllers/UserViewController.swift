//
//  UserViewController.swift
//  LocalPubHome
//
//  Created by Serang MacBook Pro 16 on 2022/02/06.
//

import UIKit

class userViewController: UIViewController {
    
    let myUserDefaults = UserDefaults.standard
    
    private var userUID: String = ""
    
    @IBOutlet var navUser: UINavigationItem!
    
    @IBOutlet var lblCurrentLanguage: UILabel!
    @IBOutlet var btnLogOut: UIButton!
    
    @IBOutlet var imageUser: UIImageView!
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet weak var profileInfoLabel: UILabel!
    @IBOutlet weak var LanguageLabel: UILabel!
    @IBOutlet weak var selfIntroduceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        userUID = self.myUserDefaults.string( forKey: UserDefault.UID.toString() ) ?? ""
        
        lblCurrentLanguage.isHidden = true
        
        imageUser.layer.cornerRadius = imageUser.frame.height/3
        imageUser.layer.borderWidth = 1
        imageUser.clipsToBounds = true
        imageUser.layer.borderColor = UIColor.gray.cgColor
        imageUser.isUserInteractionEnabled = true
    
        SetLocalized()
        
        RefreshUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        RefreshUserInfo()
    }

    func SetLocalized() {
        
        let locale = NSLocale.autoupdatingCurrent
        let languageCode = locale.languageCode!
        let language = locale.localizedString(forLanguageCode: languageCode)!
        let currentLanguage = String( format: NSLocalizedString( "CurrentLanguage", comment: "Current Language") )
        
        lblCurrentLanguage.text = " \(currentLanguage) : \(language)(\(languageCode))"
        
        btnLogOut.setTitle( "Logout".localized(), for: .normal )
        
        navUser.title = "User".localized()
        
        profileInfoLabel.text = "ProfileInformation".localized()
        LanguageLabel.text = "SelectLanguages".localized()
        selfIntroduceLabel.text = "SelfIntroduce".localized()
        
    }
    
    func RefreshUserInfo() {
        
        GetUserImage()
        
        lblName.text = myUserDefaults.string(forKey: UserDefault.Name.toString() )
    }
    
    @IBAction func tabLogOut(_ sender: UIButton) {
        
        LogOut()
    }

    
    func GetUserImage() {
        
        //if imageUser.image == nil {
            
            let fileName = userUID
            if let img = ImageFileManager.shared.getSavedImage( named: fileName ) {
                
                imageUser.image = img

            } else {

                downloadUserImage( fileName ) { completion in
                    
                    if let img = completion {
                        self.imageUser.image = img
                        ImageFileManager.shared.saveImage( image: img, name: fileName ) { onSuccess in }

                    }
                }
            }
                        
        //}
    }
    
}
