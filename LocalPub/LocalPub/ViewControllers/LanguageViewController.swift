//
//  languageViewController.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/01/20.
//

import UIKit

class languageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let myUserDefaults = UserDefaults.standard
     
    var selectedNativeLanguage: LanguageInfo? = nil
    var selectedForeignLanguage: [LanguageInfo]? = nil
    
    @IBOutlet weak var languagesTableView: UITableView!
    
    @IBOutlet var navLanguage: UINavigationItem!
    
    @IBOutlet weak var continueButton: UIButton!
    
    //    @IBOutlet var lblNati veLanguage: UILabel!
//    @IBOutlet var btnNativeLanguage: UIButton!
//
//    @IBOutlet var lblPracticeLanguage: UILabel!
//    @IBOutlet var btnPracticeLanguage: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        continueButton.isEnabled = false
        languagesTableView.delegate = self
        languagesTableView.dataSource = self
        
        // SetLocalized()
        
        // SetLanguageMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let nativeLangInfo = selectedNativeLanguage else {
            return
        }
        
        guard let foreignLangInfo = selectedForeignLanguage else {
            return
        }
        
        // change label font
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var foreginCount: Int = 0
        if let selectedForeignLanguage = selectedForeignLanguage  {
            if selectedForeignLanguage.count < 3 {
            foreginCount = selectedForeignLanguage.count
            }
        }
        switch section {
        case 0:
            return 1
        case 1:
            return foreginCount + 1
        default:
            return 0
        }
    }
    
    func SetLocalized() {
        self.navigationItem.title = "Select Language".localized()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"userLanguageCell") as! LanguageTableViewCell
         
    
//        // section 1
//        if let nativeanguageInfo == selectedNativeLanguage {
//            cell.update(with: LanguageInfo(language: nativeanguageInfo.language, level: nativeanguageInfo.level))
//        }
//        // section 2
       
        
        return cell
     }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Choose your native languages"
        case 1:
            return "Choose a foreign languages you can speak"
        default:
            return ""
        }
    }
    
    func languageChangedToDB(nativeLanguageInfo: LanguageInfo, foreignLanguagesInfo: [LanguageInfo]) {
        
        let encoder = JSONEncoder()
        
        if let encodedData = try? encoder.encode(nativeLanguageInfo) {
            SaveUserDefault( key: UserDefault.NativeLanguageInfo.toString(), value: encodedData )
        }
        
        if let encodedData = try? encoder.encode(foreignLanguagesInfo) {
            SaveUserDefault( key: UserDefault.ForeignLanguageInfo.toString(), value: encodedData )
        }
        
    }
    @IBAction func unwindToLanguage(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
//    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    
//    func SetLocalized() {
//
//        navLanguage.title = "SelectLanguages".localized()
//
//        lblNativeLanguage.text = "NativeLanguage".localized()
//
//        lblPracticeLanguage.text = "PracticeLanguage".localized()
//
//    }
    
//    func SetLanguageMenu() {
//
//        var nativeLanguageActions: Array<UIAction> = []
//        var practiceLanguageActions: Array<UIAction> = []
//        for i in 0...listLanguages.count-1 {
//            nativeLanguageActions.append( UIAction( title: listLanguages[i].localized(), state: .off, handler: { _ in self.setNativeLanguage(i) } ) )
//            practiceLanguageActions.append( UIAction( title: listLanguages[i].localized(), state: .off, handler: { _ in self.setPracticeLanguage(i) } ) )
//
//        }
//
//        let nativeLanguageButtonMenu = UIMenu( title: "SelectLanguage".localized(), children: nativeLanguageActions )
//        let practiceLanguageButtonMenu = UIMenu( title: "SelectLanguage".localized(), children: practiceLanguageActions )
//
//        btnNativeLanguage.menu = nativeLanguageButtonMenu
//        btnPracticeLanguage.menu = practiceLanguageButtonMenu
//
//        btnNativeLanguage.setTitle( listLanguages[ myUserDefaults.integer( forKey: UserDefault.NativeLanguage.toString() ) ].localized(), for: .normal)
//
//        btnPracticeLanguage.setTitle( listLanguages[ myUserDefaults.integer( forKey: UserDefault.PracticeLanguage.toString() ) ].localized(), for: .normal)
//
//    }
//
//    func setNativeLanguage(_ i: Int ) {
//
//        btnNativeLanguage.setTitle( listLanguages[i].localized(), for: .normal)
//
//        SaveUserDefault( key: UserDefault.NativeLanguage.toString(), value: i )
//
//    }
//
//    func setPracticeLanguage(_ i: Int ) {
//
//        btnPracticeLanguage.setTitle( listLanguages[i].localized(), for: .normal)
//
//        SaveUserDefault( key: UserDefault.PracticeLanguage.toString(), value: i )
//
//    }
    
}


