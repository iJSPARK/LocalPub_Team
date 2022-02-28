//
//  AgreementViewController.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/01/31.
//

import UIKit

class agreementViewController: UIViewController {
    
    @IBOutlet var navAgreement: UINavigationItem!
    
    @IBOutlet weak var CheckBtnAA: MyCheckBtn!
    @IBOutlet weak var CheckBtnTC: MyCheckBtn!
    @IBOutlet weak var CheckBtnPTC: MyCheckBtn!
    @IBOutlet weak var CheckBtnTL: MyCheckBtn!
    @IBOutlet weak var CheckBtnMA: MyCheckBtn!
    
    @IBOutlet var btns: [MyCheckBtn]!
    
//    var checkBtnAction : ((Bool) -> Void)?
    
    @IBOutlet weak var ClickAA: UIButton!
    @IBOutlet weak var ClickTC: UIButton!
    @IBOutlet weak var ClickPTC: UIButton!
    @IBOutlet weak var ClickTL: UIButton!
    @IBOutlet weak var ClickMA: UIButton!
    
    @IBOutlet var btnNext: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        SetLocalized()
        
        CheckBtnAA.setState(true)
        
        _ = btns.map{ $0.setState(true) }
        
        checkNextEnable()
    
    }
    
    func SetLocalized() {
        
        navAgreement.title = "Agreement".localized()
        
        ClickAA.setTitle( "AA".localized(), for: .normal )
        ClickTC.setTitle( "TC".localized(), for: .normal )
        ClickPTC.setTitle( "PTC".localized(), for: .normal )
        ClickTL.setTitle( "TL".localized(), for: .normal )
        ClickMA.setTitle( "MA".localized(), for: .normal )
        
        btnNext.setTitle( "Continue".localized(), for: .normal )
        
    }
    
    func checkNextEnable() {

        btnNext.isEnabled = ( CheckBtnTC.isActivated && CheckBtnPTC.isActivated )
        
    }
    
    @IBAction func touchAll(_ sender: MyCheckBtn) {
        
        sender.setState( !sender.isActivated )
        
        btns.forEach { $0.setState( sender.isActivated ) }
            
        checkNextEnable()
    
    }
    
    @IBAction func Btns(_ sender: MyCheckBtn) {

        sender.setState( !sender.isActivated )

        checkNextEnable()
        
        CheckBtnAA.setState( CheckBtnTC.isActivated && CheckBtnPTC.isActivated && CheckBtnTL.isActivated && CheckBtnMA.isActivated )
            
    }
    
    @IBAction func Next(_ sender: UIButton) {
        
        if Joined() {
            
            // Navigation Controller 사용시 - Pop
            //self.navigationController?.popViewController( animated: true )
            
            // Present 사용시
            //dismiss( animated: true )
            GoHome()
            
        } else {

            // Segue 사용시
            self.performSegue( withIdentifier: "Profile", sender: self )
            
        }
    }
    
}
