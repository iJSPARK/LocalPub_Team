//
//  NationalityViewController.swift
//  LocalPub
//
//  Created by Junseo Park on 2/12/22.
//

import UIKit

class NationalityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var nationalityTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nationalityTableView.delegate = self
        nationalityTableView.dataSource = self
        SetLocalized()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.nationalityTableView.indexPathForSelectedRow, let P = segue.destination as? profileViewController {
            let selectedData = countryInfo[indexPath.row]
            P.selectedNationality = selectedData
        }
    }
    
    func SetLocalized() {
        self.navigationItem.title = "Nationality".localized()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryInfo.count
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nationalityTableView.dequeueReusableCell(withIdentifier: "nationalityCell")
        
        let countryInfo = countryInfo[indexPath.row]
        
        cell?.textLabel?.text = countryInfo.countryEmoji + " " + countryInfo.countryName
        
        return cell!
    }

}
