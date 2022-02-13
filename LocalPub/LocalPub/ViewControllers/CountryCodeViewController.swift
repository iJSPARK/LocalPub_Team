//
//  countryCodeViewController.swift
//  LocalPub
//
//  Created by Junseo Park on 2/6/22.
//

import UIKit

class CountryCodeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var countryCodeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryCodeTableView.delegate = self
        countryCodeTableView.dataSource = self
        SetLocalized()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.countryCodeTableView.indexPathForSelectedRow, let LP = segue.destination as? loginPhoneViewController {
            let selectedData = countryInfo[indexPath.row]
            LP.selectedCountryCode = selectedData
        }
    }
    
    func SetLocalized() {
        self.navigationItem.title = "CountryCode".localized()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryInfo.count
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = countryCodeTableView.dequeueReusableCell(withIdentifier: "countryCodeCell")
        
        let countryInfos = countryInfo[indexPath.row]
        
        let text = countryInfos.countryEmoji + " " + countryInfos.countryName + " (" + countryInfos.countryCode + ")"
        
        cell?.textLabel?.text = text
        
        return cell!
    }

}
