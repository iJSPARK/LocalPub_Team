//
//  findFriendViewController.swift
//  LocalPubHome
//
//  Created by Serang MacBook Pro 16 on 2022/02/05.
//

import UIKit

class findFriendViewController: UIViewController {

    @IBOutlet var btnFindFriend: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SetLocalized()
    }
    
    func SetLocalized() {
        
        btnFindFriend.setTitle( "FindFriend".localized(), for: .normal )
        
    }
    
    @IBAction func GetCall(_ sender: UIButton) {
        
        MakeUserCall()
        
    }

    
    
    
    

}

