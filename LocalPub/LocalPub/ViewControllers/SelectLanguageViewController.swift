//
//  SelectLanguageViewController.swift
//  LocalPub
//
//  Created by Junseo Park on 2/13/22.
//

import UIKit

class SelectLanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var section: Int = -1
    
    var indexForeign = 0
    
    let languages: [Language] = [.english, .korean, .japanese, .russian, .ukraine, .chinese, .french, .german, .italian]

    @IBOutlet weak var selectLanguageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectLanguageTableView.delegate = self
        selectLanguageTableView.dataSource = self
        SetLocalized()
    
        print("print section = \(section)")
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.selectLanguageTableView.indexPathForSelectedRow {
            
            let selectedLanguage = languages[indexPath.row]
            
            if section == 0 { // native langugage 전달 > LanguageTableViewController
                if let L = segue.destination as? languageViewController {
                    
                     print("선택된 데이터 before section 0\(selectedLanguage)")
                    
                    L.selectedNativeLanguage = LanguageInfo(language: selectedLanguage, level: .native)
                }
            }
            else {  // foreign language 전달 > LevelLanguageViewController
                if let LL = segue.destination as? LevelLanguageViewController {
                    LL.selectedForeignLanguage = selectedLanguage
                    LL.indexForegin = indexForeign
                    print("Language 선택 인덱스 \(indexForeign)")
                }
            }
        }
    }
    
    func SetLocalized() {
        if section == 0 {
            self.navigationItem.title = "NativeLanguage".localized()
        } else {
            self.navigationItem.title = "ForeignLanguage".localized()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if section == 0 {
            let cell = selectLanguageTableView.dequeueReusableCell(withIdentifier: "nativeCell")
            let language = languages[indexPath.row].toString()
            
            cell?.textLabel?.text = language + "   " + "(\(language.localized()))"
            
            return cell!
        } else {
            let cell = selectLanguageTableView.dequeueReusableCell(withIdentifier: "foreignCell")
            let language = languages[indexPath.row].toString()
            
            cell?.textLabel?.text = language + "   " + "(\(language.localized()))"
            
            return cell!
        }
    }

}
