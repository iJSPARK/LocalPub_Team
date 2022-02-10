//
//  languageViewController.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/01/20.
//

import UIKit

class languageViewController: UIViewController {

    let myUserDefaults = UserDefaults.standard
    
    let listLanguages = [ "Korean", "English", "French", "Japanese" ]
    
    @IBOutlet var navLanguage: UINavigationItem!
    
    @IBOutlet var lblNativeLanguage: UILabel!
    @IBOutlet var btnNativeLanguage: UIButton!
    
    @IBOutlet var lblPracticeLanguage: UILabel!
    @IBOutlet var btnPracticeLanguage: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SetLocalized()
        
        SetLanguageMenu()
        
    }
    
    func SetLocalized() {
        
        navLanguage.title = "SelectLanguages".localized()
        
        lblNativeLanguage.text = "NativeLanguage".localized()
        
        lblPracticeLanguage.text = "PracticeLanguage".localized()
        
    }
    
    func SetLanguageMenu() {
        
        var nativeLanguageActions: Array<UIAction> = []
        var practiceLanguageActions: Array<UIAction> = []
        for i in 0...listLanguages.count-1 {
            nativeLanguageActions.append( UIAction( title: listLanguages[i].localized(), state: .off, handler: { _ in self.setNativeLanguage(i) } ) )
            practiceLanguageActions.append( UIAction( title: listLanguages[i].localized(), state: .off, handler: { _ in self.setPracticeLanguage(i) } ) )
            
        }

        let nativeLanguageButtonMenu = UIMenu( title: "SelectLanguage".localized(), children: nativeLanguageActions )
        let practiceLanguageButtonMenu = UIMenu( title: "SelectLanguage".localized(), children: practiceLanguageActions )
        
        btnNativeLanguage.menu = nativeLanguageButtonMenu
        btnPracticeLanguage.menu = practiceLanguageButtonMenu
        
        btnNativeLanguage.setTitle( listLanguages[ myUserDefaults.integer( forKey: UserDefault.NativeLanguage.toString() ) ].localized(), for: .normal)
 
        btnPracticeLanguage.setTitle( listLanguages[ myUserDefaults.integer( forKey: UserDefault.PracticeLanguage.toString() ) ].localized(), for: .normal)
        
    }
    
    func setNativeLanguage(_ i: Int ) {
    
        btnNativeLanguage.setTitle( listLanguages[i].localized(), for: .normal)
        
        SaveUserDefault( key: UserDefault.NativeLanguage.toString(), value: i )
        
    }
    
    func setPracticeLanguage(_ i: Int ) {
    
        btnPracticeLanguage.setTitle( listLanguages[i].localized(), for: .normal)
        
        SaveUserDefault( key: UserDefault.PracticeLanguage.toString(), value: i )
        
    }
    
}


