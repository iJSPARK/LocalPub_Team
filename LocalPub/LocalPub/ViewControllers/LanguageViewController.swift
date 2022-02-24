//
//  languageViewController.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/01/20.
//

import UIKit

class languageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let myUserDefaults = UserDefaults.standard
    
    // nil로 일관 되게 바꿀예정
    var selectedNativeLanguage: LanguageInfo? = nil
    var selectedForeignLanguages: [LanguageInfo] = []
    
    @IBOutlet weak var languagesTableView: UITableView!
    
    @IBOutlet var navLanguage: UINavigationItem!
    
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        languagesTableView.delegate = self
        languagesTableView.dataSource = self
        
        // User default data load
        if let selectedNativeLanguage = changedNativeFromDB() {
            
        }
        
        selectedForeignLanguages = changedForeignFromDB()
        
        SetLocalized()
        
//        selectedNativeLanguage = changedNativeFromDB()!
//
//        selectedForeignLanguages = changedForeignFromDB()
        print("선택된 외국어들 \(selectedForeignLanguages)")
        
    }
    
    func changedNativeFromDB() -> LanguageInfo? {
        
        let decoder = JSONDecoder()
        
        guard let savedNativeData = myUserDefaults.object(forKey: UserDefault.NativeLanguageInfo.toString()) as? Data else { return nil }
        
        guard let savedObject = try? decoder.decode(LanguageInfo.self, from: savedNativeData) else { return nil }
        
        return savedObject
    }
    
    func changedForeignFromDB() -> [LanguageInfo] {
        
        let decoder = JSONDecoder()
        
        guard let savedNativeData = myUserDefaults.object(forKey: UserDefault.ForeignLanguageInfo.toString()) as? Data else { return [] }
        
        guard let savedObject = try? decoder.decode([LanguageInfo].self, from: savedNativeData) else { return [] }
        
        return savedObject
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        checkValues()
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
        print("Update Section")
        
        var foreginCount: Int = 0

        if selectedForeignLanguages.count < 3 {
            foreginCount = selectedForeignLanguages.count + 1
        } else {
            foreginCount = 3
        }

         print("foregin count \(foreginCount)")
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
    
    // swipe delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row < selectedForeignLanguages.count {
            if editingStyle == .delete {
                print("삭제할 언어 인덱스 \(indexPath.row)")
                selectedForeignLanguages.remove(at: indexPath.row)
                tableView.reloadData()
                // tableView.deleteRows(at: [indexPath], with: .fade)
                print("삭제된 언어 인덱스\(indexPath.row)")
                print("삭젠된 후 외국어 개수 \(selectedForeignLanguages.count)")
            }
        }
    }
    
    // prototype cell 2 > 각각 구별 > 어디서 온앤지 알음 > indifier로 코드 작성 > 간펴
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("셸 업데이트")
        // tableview 모든 cell을 업데이트 중, 단 빈 cell 이전의 cell로 업데이트
        // 빈값은 cell init으로 업데이트/안 빈셀은 채워져있는걸로 업데이트
        // row 값까지 함수 호출됨 / selectedForeignlanguages 없는 row 접근 하면 안됨
        
        // 1. 옵셔널때문에 append 구조체 배열 추가 안됨 ( ?.append() nildl이기 때문 ) > []
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
            if selectedForeignLanguages.isEmpty == false && indexPath.row < selectedForeignLanguages.count {
                let foreignLanguageInfo = selectedForeignLanguages[indexPath.row] // 0 1 2
                print("삽입된 외국어 셀 인덱스 \(indexPath.row)")
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
    
    func checkValues() {
        if selectedNativeLanguage != nil && selectedForeignLanguages.count != 0 {
            btnNext.isEnabled = true
        } else {
           btnNext.isEnabled = false
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
    
    @IBAction func Next(_ sender: Any) {
        languageChangedToDB(nativeLanguageInfo: selectedNativeLanguage!, foreignLanguagesInfo: selectedForeignLanguages)
        
        if Joined() {
            
            dismiss(animated: true)
            
        } else {

            self.performSegue( withIdentifier: "Introduce", sender: self )
            
        }
    }
    
    @IBAction func unwindToLanguage(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    

//    GetUserDefaultFromDB(key: "GetUserLanguageInfo") {
//        userData in
//
//        let decoder = JSONDecoder()
//
//        if let savedNativeData = myUserDefaults.object(forKey: UserDefault.NativeLanguage.toString()) as? Data {
//            if let savedNativeLangInfo = try? decoder.decode(LanguageInfo.self, from: savedNativeData) {
//                print(savedNativeLangInfo.language, savedNativeLangInfo.level))
//            }
//        }
//
//        if let savedForeignData = myUserDefaults.object(forKey: UserDefault.ForeignLanguage.toString()) as? Data {
//            if let savedForeignLangInfo = try? decoder.decode([LanguageInfo].self, from: savedForeignData) {
//                for foreignLangInfo in savedForeignLangInfo {
//                    print(foreignLangInfo.language, foreignLangInfo.level)
//                }
//            }
//        }
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


