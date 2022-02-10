//
//  countryCodeViewController.swift
//  LocalPub
//
//  Created by Junseo Park on 2/6/22.
//

import UIKit

class CountryCodeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let countryCodeInfos: [Country] = [
        Country(countryEmoji: "🇰🇷", countryName: "Korea", countryCode: "+82"),
        Country(countryEmoji: "🇺🇸", countryName: "US", countryCode: "+1"),
        Country(countryEmoji: "🇯🇵", countryName: "Japen", countryCode: "+81")
    ]

    @IBOutlet weak var countryCodeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryCodeTableView.delegate = self
        countryCodeTableView.dataSource = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.countryCodeTableView.indexPathForSelectedRow, let LP = segue.destination as? loginPhoneViewController {
            let selectedData = countryCodeInfos[indexPath.row]
            LP.selectedCountryCode = selectedData
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Tap Cell")
//        let LP = loginPhoneViewController()
//        let selectedData = countryCodeInfos[indexPath.row]
//        LP.selectedCountryCode = selectedData
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryCodeInfos.count
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = countryCodeTableView.dequeueReusableCell(withIdentifier: "countryCodeCell")
        
        let countryCodeInfo = countryCodeInfos[indexPath.row]
        
        cell?.textLabel?.text = countryCodeInfo.countryEmoji + countryCodeInfo.countryName + countryCodeInfo.countryCode
        
        return cell!
    }

}
