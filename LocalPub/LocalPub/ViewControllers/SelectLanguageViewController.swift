//
//  SelectLanguageViewController.swift
//  LocalPub
//
//  Created by Junseo Park on 2/13/22.
//

import UIKit

class SelectLanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let language: [Language] = [.english, .korean, .japanese, .russian, .ukraine, .chinese]
    
    @IBOutlet weak var selectLanguageTableView: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.selectLanguageTableView.indexPathForSelectedRow, let L = segue.destination as? languageViewController {
            let selectedData = language[indexPath.row].description // arrray
            // L.lang = selectedData
            
        }
    }
    
    func SetLocalized() {
        self.navigationItem.title = "".localized()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryInfo.count
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = selectLanguageTableView.dequeueReusableCell(withIdentifier: "selectLanguageCell")
        
        // let countryInfo = countryInfo[indexPath.row]
        
        // cell?.textLabel?.text = countryInfo.countryEmoji + " " + countryInfo.countryName
        
        return cell!
    }

}
