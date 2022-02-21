//
//  findFriendViewController.swift
//  LocalPubHome
//
//  Created by Serang MacBook Pro 16 on 2022/02/05.
//

import UIKit

class findFriendViewController: UIViewController {
    
    @IBOutlet var lblCurrentLanguage: UILabel!
    @IBOutlet var btnLogOut: UIButton!
    
    @IBOutlet var btnFindFriend: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SetLocalized()
    }
    
    func SetLocalized() {

        let locale = NSLocale.autoupdatingCurrent
        let languageCode = locale.languageCode!
        let language = locale.localizedString(forLanguageCode: languageCode)!
        let currentLanguage = String( format: NSLocalizedString( "CurrentLanguage", comment: "Current Language") )
        
        lblCurrentLanguage.text = " \(currentLanguage) : \(language)(\(languageCode))"
        
        btnLogOut.setTitle( "Logout".localized(), for: .normal )
        
        btnFindFriend.setTitle( "FindFriend".localized(), for: .normal )
        
    }
        
    @IBAction func tabLogOut(_ sender: UIButton) {
        
        LogOut()
        
    }
    
    @IBAction func GetCall(_ sender: UIButton) {
        
        MakeUserCall()
        
    }

}
    


