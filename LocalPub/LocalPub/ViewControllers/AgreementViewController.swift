//
//  AgreementViewController.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/01/31.
//

import UIKit

class agreementViewController: UIViewController {
    
    @IBOutlet var navAgreement: UINavigationItem!
    
    
    //text상자 버튼들!  누르면 상세페이지로 들어가게 해줌. 연결페이지만들어야함.
    
    @IBOutlet weak var ClickAA: UIButton!
    
    @IBOutlet weak var ClickTC: UIButton!
    
    @IBOutlet weak var ClickPTC: UIButton!
    
    @IBOutlet weak var ClickTL: UIButton!
    
    @IBOutlet weak var ClickMA: UIButton!
    
//text상자 앞에 check 버튼들 ! 위 각각의 text상자 버튼들을 눌러서 각각 상세페이지 갔다가 돌아오면 이 버튼들을 누를 수 있음. (상세페이지 갔다오지 않으면 눌러지지 않음)

    
    
    @IBOutlet weak var CheckBtnAA: MyCheckBtn!//에러
    
    @IBOutlet weak var CheckBtnTC: MyCheckBtn!
    
    @IBOutlet weak var CheckBtnPTC: MyCheckBtn!

    @IBOutlet weak var CheckBtnTL: MyCheckBtn!
    
    @IBOutlet weak var CheckBtnMA: MyCheckBtn!
    
    @IBOutlet var btns: [MyCheckBtn]!
    
    var checkBtnAction : ((Bool) -> Void)?
    
   @IBOutlet var BtnContinue: UIButton!

    //@IBOutlet var btns
    
    //다음버튼의 기본값은 회색이고 눌리지 않음.
    //AA 원형 체크박스버튼, 또는 TC와 PTC 원형 체크박스버튼 두개가 컬러일때 다음버튼의 색은 회색에서 컬러로 변함.
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        navAgreement.title = "Agreement".localized()
        
        CheckBtnAA.setState(true)
        
        CheckBtnTC.setState(true)
        CheckBtnPTC.setState(true)
        CheckBtnTL.setState(true)
        CheckBtnMA.setState(true)
        
        BtnContinue.isEnabled = false
        
    }
    
    @IBAction func touchAll(_ sender: MyCheckBtn) {
        
        sender.setState( !sender.isActivated )
        
        btns.forEach { $0.setState( sender.isActivated )
            
        }
            
        checkNextEnable()
    
    }
    
    @IBAction func Btns(_ sender: MyCheckBtn) {

        sender.setState( !sender.isActivated )
            
        checkNextEnable()
        
        if CheckBtnTC.isActivated &&      CheckBtnPTC.isActivated &&
            CheckBtnTL.isActivated &&
            CheckBtnMA.isActivated {
            CheckBtnAA.setState(true)

        } else {
            CheckBtnAA.setState(false)
        }
                    
    }
        
    
    func checkNextEnable() {
        if
            CheckBtnTC.isActivated &&
                CheckBtnPTC.isActivated {
            BtnContinue.isEnabled = true
        }
        else {
            BtnContinue.isEnabled = false
        }
        

        
    }
    
    
}
