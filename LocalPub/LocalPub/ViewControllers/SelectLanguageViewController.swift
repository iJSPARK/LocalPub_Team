//
//  SelectLanguageViewController.swift
//  LocalPub
//
//  Created by Junseo Park on 2/13/22.
//

import UIKit

class SelectLanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var section: Int = -1
    
    let languages: [Language] = [.english, .korean, .japanese, .russian, .ukraine, .chinese, .french, .german, .italian]

    @IBOutlet weak var selectLanguageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectLanguageTableView.delegate = self
        selectLanguageTableView.dataSource = self
        SetLocalized()
    
        print(section)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.selectLanguageTableView.indexPathForSelectedRow {
            let selectedLanguage = languages[indexPath.row]
            if section == 0 {
                if let L = segue.destination as? languageViewController {
                    
                    print("선택된 데이터 before section 0\(selectedLanguage)")
                    
                    print("input native")
                    L.selectedNativeLanguage = LanguageInfo(language: selectedLanguage, level: .native)
                    print("L.selectedNativeLanguage \(L.selectedNativeLanguage)")
                }
            }
            else {
                if let LL = segue.destination as? LevelLanguageViewController {
                    print("선택된 데이터 before section 1 \(selectedLanguage)")
                    print("input foreign")
                    LL.selectedForeignLanguage = selectedLanguage
                }
            }
        }
    }
    
    func SetLocalized() {
        self.navigationItem.title = "Select Language".localized()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if section == 0 {
            let cell = selectLanguageTableView.dequeueReusableCell(withIdentifier: "nativeCell")
            let language = languages[indexPath.row].toString()
            
            cell?.textLabel?.text = language
            
            return cell!
        } else {
            let cell = selectLanguageTableView.dequeueReusableCell(withIdentifier: "foreignCell")
            let language = languages[indexPath.row].toString()
            
            cell?.textLabel?.text = language
            
            return cell!
        }
    
    }

}
