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
    var selectedForeignLanguages: [LanguageInfo]? = nil
    
    @IBOutlet weak var selectLanguagesLabel: UILabel!
    
    @IBOutlet weak var selectLanguagesDescriptionLabel: UILabel!
    
    @IBOutlet weak var languagesTableView: UITableView!
    
    @IBOutlet var navLanguage: UINavigationItem!
    
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SetLocalized()
        
        UICheckJoined()
        
        languagesTableView.delegate = self
        languagesTableView.dataSource = self
        
        selectedNativeLanguage = changedNativeFromDB()
        selectedForeignLanguages = changedForeignFromDB()
    }
    
    func changedNativeFromDB() -> LanguageInfo? {
        
        let decoder = JSONDecoder()
        
        guard let savedNativeData = myUserDefaults.object(forKey: UserDefault.NativeLanguageInfo.toString()) as? Data else { return nil }
        
        guard let savedObject = try? decoder.decode(LanguageInfo.self, from: savedNativeData) else { return nil }
        
        return savedObject
    }
    
    func changedForeignFromDB() -> [LanguageInfo]? {
        
        let decoder = JSONDecoder()
        
        guard let savedNativeData = myUserDefaults.object(forKey: UserDefault.ForeignLanguageInfo.toString()) as? Data else { return nil }
        
        guard let savedObject = try? decoder.decode([LanguageInfo].self, from: savedNativeData) else { return nil }
        
        return savedObject
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        languagesTableView.reloadData()
        btnNext.isEnabled = checkAllValues()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let section = self.languagesTableView.indexPathForSelectedRow?.section, let SL = segue.destination as? SelectLanguageViewController {
    
            SL.section = section
        
            if let selectedIndexPath = languagesTableView.indexPathForSelectedRow  {
                SL.indexForeign = selectedIndexPath.row
            }
          
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        var foreginCellCount: Int = 1

        if let selectedForeignLanguages = selectedForeignLanguages {
            if selectedForeignLanguages.count < 3 {
                foreginCellCount = selectedForeignLanguages.count + 1
            } else {
                foreginCellCount = 3
            }
        }

        print("foregin Cell count \(foreginCellCount)")
        switch section {
        case 0:
            return 1
        case 1:
            return foreginCellCount
        default:
            return 0
        }
    }
    
    func SetLocalized() {
        self.navigationItem.title = "SelectLanguage".localized()
        selectLanguagesLabel.text = "SelectLanguages".localized()
        selectLanguagesDescriptionLabel.text = "SelectLangagesDescription".localized()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        let foreignCount = selectedForeignLanguages?.count ?? 0
        
        if indexPath.section == 1 && indexPath.row < foreignCount {
            return .delete
        } else {
            return .none
        }
    }
    
    // swipe delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if editingStyle == .delete {
                selectedForeignLanguages?.remove(at: indexPath.row)
                tableView.reloadData()
                // tableView.deleteRows(at: [indexPath], with: .fade)
                // foreginCellCount -= 1
                btnNext.isEnabled = checkAllValues()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier:"userLanguageCell") as! LanguageTableViewCell
        
        if indexPath.section == 0 {
            
            if let nativeLangInfo = selectedNativeLanguage {
                cell.updateCell(with: nativeLangInfo)
            }
            
            if selectedNativeLanguage == nil {
                cell.updateCellInit()
            }
            
            cell.showsReorderControl = true

        } else {
            
            if let foreignLangInfos = selectedForeignLanguages {
                
                if indexPath.row < foreignLangInfos.count {
                    let foreignLangInfo = foreignLangInfos[indexPath.row]
                    cell.updateCell(with: foreignLangInfo)
                } else {
                    cell.updateCellInit()
                }
                
            }
            
            if selectedForeignLanguages == nil {
                cell.updateCellInit()
            }
            
            cell.showsReorderControl = true
        }
    
        return cell
     }
    

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "ChooseNatvieLanguages".localized()
        case 1:
            return "ChooseForeignLanguages".localized()
        default:
            return ""
        }
    }
    
    func checkAllValues() -> Bool {
        if selectedNativeLanguage != nil && selectedForeignLanguages != nil && selectedForeignLanguages?.count != 0 {
            return true
        } else {
           return false
        }
    }
    
    func languageChangedToDB(nativeLanguageInfo: LanguageInfo?, foreignLanguagesInfo: [LanguageInfo]?) {
        
        let encoder = JSONEncoder()
        
        if let encodedData = try? encoder.encode(nativeLanguageInfo) {
            SaveUserDefault( key: UserDefault.NativeLanguageInfo.toString(), value: encodedData )
        }
        
        if let encodedData = try? encoder.encode(foreignLanguagesInfo) {
            SaveUserDefault( key: UserDefault.ForeignLanguageInfo.toString(), value: encodedData )
        }
    }
    
    func saveData() {
        languageChangedToDB(nativeLanguageInfo: selectedNativeLanguage, foreignLanguagesInfo: selectedForeignLanguages)
    }
    
    func UICheckJoined() {
        if Joined() {
            btnNext.isHidden = true
            self.navigationItem.rightBarButtonItem = self.navLanguage.rightBarButtonItem
        } else {
            btnNext.isHidden = false
            self.navLanguage.rightBarButtonItem = nil
        }
    }
    
    @IBAction func Next(_ sender: Any) {
        saveData()
        
        self.performSegue( withIdentifier: "Introduce", sender: self )
        
//        if Joined() {
//
//            dismiss(animated: true)
//
//        } else {
//
//            self.performSegue( withIdentifier: "Introduce", sender: self )
//
//        }
    }
    
    @IBAction func saveDataAferJoined(_ sender: Any) {
        if checkAllValues() {
            saveData()
        AlertOK( title: "LanguagesEditSuccess".localized(), message: "SueccesLanguagesEdit".localized(), viewController: self )
            saveData()
        } else {
            AlertOK( title: "LanguagesEditFail".localized(), message: "FailLanguagesEdit".localized(), viewController: self )
        }
    }
    
    @IBAction func unwindToLanguage(_ unwindSegue: UIStoryboardSegue) {
        //let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
}


