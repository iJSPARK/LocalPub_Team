//
//  IntroduceViewController.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/01/20.
//

import UIKit

class intorduceViewController: UIViewController, UITextViewDelegate {

    let myUserDefaults = UserDefaults.standard
    

    @IBOutlet weak var introduceLabel: UILabel!
    
    @IBOutlet weak var introduceDescriptionLabel: UILabel!
    
    @IBOutlet var navIntroduce: UINavigationItem!

    @IBOutlet var lblAboutMe: UILabel!
    
    @IBOutlet var txtAboutMe: UITextView!

    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var leastCharacters: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnCheckJoined()
        
        txtAboutMe.addDoneButtonOnKeyboard()
       
        SetLocalized()
       
        txtAboutMe.text = myUserDefaults.string( forKey: UserDefault.AboutMe.toString() )
        
        txtAboutMe.textColor = .black
        
        btnNext.isEnabled = checkAllValues()
        
        placeholderSet(txtAboutMe)
    }

    func SetLocalized() {
        
        lblAboutMe.text = "📝" + "About Me".localized()
        
        navIntroduce.title = "SelfIntroduce".localized()
        
        btnNext.setTitle( "Continue".localized(), for: .normal )
        
        leastCharacters.text = "FailLanguagesEdit".localized()
        
        introduceLabel.text = "Introduce".localized()
        introduceDescriptionLabel.text = "IntroduceDescription".localized()
        
        txtAboutMe.layer.borderWidth = 1.0
        txtAboutMe.layer.borderColor = UIColor.gray.cgColor
        txtAboutMe.layer.cornerRadius = 10
    }
    
    func placeholderSet(_ textView: UITextView) {
        textView.delegate = self
        if textView.text.isEmpty {
            textView.text = "Tell your friends about yourself and your foreign language experience"
            textView.textColor = UIColor.opaqueSeparator
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.opaqueSeparator {
               textView.text = nil
               textView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        btnNext.isEnabled = checkAllValues()
    }
    
    func checkAllValues() -> Bool {
        if txtAboutMe.text.count > 30 {
            leastCharacters.textColor = .blue
            return true
        } else {
            leastCharacters.textColor = .red
            return false
        }
    }
    
    func saveData() {
        SaveUserDefault( key: UserDefault.AboutMe.toString(), value: txtAboutMe.text! )
    }
    
    @IBAction func Next(_ sender: UIButton) {
        
        saveData()
        
        self.performSegue( withIdentifier: "Picture", sender: self )
        
        if Joined() {

            dismiss(animated: true)

        } else {

            self.performSegue( withIdentifier: "Picture", sender: self )

        }
    }
    
    @IBAction func saveDataAferJoined(_ sender: Any) {
        if checkAllValues() {
            saveData()
        AlertOK( title: "IntroduceEditSuccessed".localized(), message: "SuccessIntroduceEdit".localized(), viewController: self )
            saveData()
        } else {
            AlertOK( title: "IntroduceEditFailed".localized(), message: "FailLanguagesEdit".localized(), viewController: self )
        }
    }
    
    func btnCheckJoined() {
        
        if Joined()
        {
            btnNext.isHidden = true
            self.navigationItem.rightBarButtonItem = self.navIntroduce.rightBarButtonItem
        }
        else
        {
            btnNext.isHidden = false
            self.navIntroduce.rightBarButtonItem = nil
        }
    }
}

extension UITextView {
    func addDoneButtonOnKeyboard() {
        let doneToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        
        let flexSapce = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonPressed)
        )
        
        done.tintColor = UIColor.systemPurple
        
        let item = [flexSapce, done]
        
        doneToolbar.items = item
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonPressed() {
        self.resignFirstResponder()
        
    }
}

