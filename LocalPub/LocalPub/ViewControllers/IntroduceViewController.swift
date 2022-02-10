//
//  IntroduceViewController.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/01/20.
//

import UIKit

class intorduceViewController: UIViewController {

    let myUserDefaults = UserDefaults.standard
    
    @IBOutlet var navIntroduce: UINavigationItem!

    @IBOutlet var btnSaveExperience: UIButton!
    
    @IBOutlet var lblExperience: UILabel!
    @IBOutlet var txtExperience: UITextView!
    
    @IBOutlet var lblAboutMe: UILabel!
    @IBOutlet var txtAboutMe: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SetLocalized()
        
        txtExperience.text = myUserDefaults.string( forKey: UserDefault.Experience.toString() )
        
        txtAboutMe.text = myUserDefaults.string( forKey: UserDefault.AboutMe.toString() )
        
    }
    
    func SetLocalized() {

        navIntroduce.title = "SelfIntroduce".localized()
        
        btnSaveExperience.setTitle( "Save".localized(), for: .normal )
   
        lblExperience.text = "Experience".localized()
        lblAboutMe.text = "AboutMe".localized()
        
        txtExperience.layer.borderWidth = 1.0
        txtExperience.layer.borderColor = UIColor.gray.cgColor
        txtExperience.layer.cornerRadius = 10
        
        txtAboutMe.layer.borderWidth = 1.0
        txtAboutMe.layer.borderColor = UIColor.gray.cgColor
        txtAboutMe.layer.cornerRadius = 10
        
    }
    
    @IBAction func saveExperience(_ sender: UIButton) {
        
        SaveUserDefault( key: UserDefault.Experience.toString(), value: txtExperience.text! )
        
        SaveUserDefault( key: UserDefault.AboutMe.toString(), value: txtAboutMe.text! )
        
    }
    
}


