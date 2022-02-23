//
//  LevelLanguageViewController.swift
//  LocalPub
//
//  Created by Junseo Park on 2/22/22.
//

import UIKit

class LevelLanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var section: Int = -1
    
    var selectedForeignLanguage: Language? = nil
    
    let levels: [Level] = [.fluent, .good, .soso, .little]

    @IBOutlet weak var levelTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        levelTableView.delegate = self
        levelTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.levelTableView.indexPathForSelectedRow, let L = segue.destination as? languageViewController {
            let selectedLevel = levels[indexPath.row]
            L.selectedForeignLanguages.append(LanguageInfo(language: selectedForeignLanguage!, level: selectedLevel))
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = levelTableView.dequeueReusableCell(withIdentifier: "levelCell")
        
        let level = levels[indexPath.row].toString()
        
        cell?.textLabel?.text = level
        
        return cell!
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
