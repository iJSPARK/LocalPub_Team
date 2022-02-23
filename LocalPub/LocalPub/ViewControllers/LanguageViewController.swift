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
    var selectedForeignLanguages: [LanguageInfo] = []
    // var indexForegin = 0
    
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
        languagesTableView.reloadData()
        print(selectedForeignLanguages)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let section = self.languagesTableView.indexPathForSelectedRow?.section, let SL = segue.destination as? SelectLanguageViewController {
            
            print("Send Section \(section)")
            SL.section = section
            
            if let selectedIndexPath = languagesTableView.indexPathForSelectedRow  { SL.indexForeign = selectedIndexPath.row
                print("Send indexForeign \(selectedIndexPath.row)")
            }
          
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // print("Update Tableview")
        
        var foreginCount: Int = 0
        
        if selectedForeignLanguages.count < 3 {
            foreginCount = selectedForeignLanguages.count + 1
        } else {
            foreginCount = 3
        }
        
        // print("foregin count \(foreginCount)")
        switch section {
        case 0:
            return 1
        case 1:
            return foreginCount
        default:
            return 0
        }
    }
    
    func SetLocalized() {
        self.navigationItem.title = "Select Language".localized()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            if editingStyle == .delete {
                
                selectedForeignLanguages.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            } else if editingStyle == .insert {
                
            }
    }
    
    // prototype cell 2 > 각각 구별 > 어디서 온앤지 알음 > indifier로 코드 작성 > 간펴
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // tableview 모든 cell을 업데이트 중, 단 빈 cell 이전의 cell로 업데이트
        // 빈값은 cell init으로 업데이트/안 빈셀은 채워져있는걸로 업데이트
        // row 값까지 함수 호출됨 / selectedForeignlanguages 없는 row 접근 하면 안됨
        
        // 1. 옵셔널때문에 append 구조체 배열 추가 안됨 > []
        // 2. 빈 테이블 뷰 > 값없는 구조체 값에 해당하는 테이블 뷰 업데이트시 오류 > []
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"userLanguageCell") as! LanguageTableViewCell
        
        if indexPath.section == 0 {
            // print("Section in 0")
            if let nativeLangInfo = selectedNativeLanguage {
                // print("nativeLangInfo \(nativeLangInfo)")
                cell.updateCell(with: nativeLangInfo)
            }
            cell.showsReorderControl = true

        } else { // section == 1
    
            // print("Section in 1")
            // print(selectedForeignLanguages)
            
            
            
            if selectedForeignLanguages.isEmpty == false && indexPath.row < selectedForeignLanguages.count {
               //  print("Input indexForeign = \(indexPath.row)")
                // print(" 외국어 개수\(selectedForeignLanguages.count)")
                let foreignLanguageInfo = selectedForeignLanguages[indexPath.row] // 0 1 2
                cell.updateCell(with: foreignLanguageInfo)
            } else {
                cell.updateCellInit()
            }
        
            cell.showsReorderControl = true
        }
    
        
        
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
//        print("dfd")
//        if indexPath.section == 0 {
//            print("o")
//        } else {
//            print("0 초과")
//        }
//    }
    

    // tap accerssory
//    
//
    // user select cell
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


