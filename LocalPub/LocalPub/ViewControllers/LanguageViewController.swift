//
//  languageViewController.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/01/20.
//

import UIKit

class languageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let myUserDefaults = UserDefaults.standard
    
    @IBOutlet weak var languagesTableView: UITableView!
    
    @IBOutlet var navLanguage: UINavigationItem!
    
    @IBOutlet var lblNativeLanguage: UILabel!
    @IBOutlet var btnNativeLanguage: UIButton!
    
    @IBOutlet var lblPracticeLanguage: UILabel!
    @IBOutlet var btnPracticeLanguage: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        languagesTableView.delegate = self
        languagesTableView.dataSource = self

        // SetLocalized()
        
        // SetLanguageMenu()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"userLanguageCell") as! LanguageTableViewCell
        
        let myUserLanguages = userLangages(nativeLanguage: LanguageInfo, foreignLanguages: [LanguageInfo])
        
        
        
        let nativeLanguage = userLanguage
        
        cell.update(with: language)
//        cell?.textLabel?.text = language
        
        return cell
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


