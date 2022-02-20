//
//  SelectLanguageViewController.swift
//  LocalPub
//
//  Created by Junseo Park on 2/13/22.
//

import UIKit

class SelectLanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let language: [Language] = [.english, .korean, .japanese, .russian, .ukraine, .chinese, .french, .german, .italian]
    
    @IBOutlet weak var selectLanguageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectLanguageTableView.delegate = self
        selectLanguageTableView.dataSource = self
        SetLocalized()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.selectLanguageTableView.indexPathForSelectedRow, let L = segue.destination as? languageViewController {
            let selectedData = language[indexPath.row]
            // section 1에서 넘어왔을떄는 nativeInfo.langage
            // section 2에서 넘어왔을때 foreginInfo.lagnuge
            L.selectedNativeLanguage?.language = selectedData
        }
    }
    
    func SetLocalized() {
        self.navigationItem.title = "Select Language".localized()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = selectLanguageTableView.dequeueReusableCell(withIdentifier: "selectLanguageCell")
        
        let languages = language[indexPath.row].toString()
        
        cell?.textLabel?.text = languages
        
        return cell!
    }

}
