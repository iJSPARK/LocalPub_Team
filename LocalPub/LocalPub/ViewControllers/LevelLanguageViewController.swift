//
//  LevelLanguageViewController.swift
//  LocalPub
//
//  Created by Junseo Park on 2/22/22.
//

import UIKit

class LevelLanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedForeignLanguage: Language? = nil
    
    var indexForegin = 0
    
    let levels: [Level] = [.fluent, .good, .soso, .little]

    @IBOutlet weak var levelTableView: UITableView!
    
    @IBOutlet weak var LevelLabel: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        levelTableView.delegate = self
        levelTableView.dataSource = self
        
        LevelLabel.title = selectedForeignLanguage?.toString().localized() ?? "" 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.levelTableView.indexPathForSelectedRow, let L = segue.destination as? languageViewController {
            let selectedLevel = levels[indexPath.row]
            print("Level index \(indexForegin)")
            
        
            // L.selectedForeignLanguages = L.selectedForeignLanguages ?? [] // []? > []
            
            print("현재 외국어 개수\(L.selectedForeignLanguages?.count ?? 0)")
            if indexForegin == L.selectedForeignLanguages?.count ?? 0 {
                L.selectedForeignLanguages?.insert(LanguageInfo(language: selectedForeignLanguage!, level: selectedLevel), at: indexForegin)
            } else {
                L.selectedForeignLanguages?[indexForegin] = LanguageInfo(language: selectedForeignLanguage!, level: selectedLevel)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = levelTableView.dequeueReusableCell(withIdentifier: "levelCell")
        
        let level = levels[indexPath.row].toString()
        
        cell?.textLabel?.text = level.localized()
        
        return cell!
    }
}
