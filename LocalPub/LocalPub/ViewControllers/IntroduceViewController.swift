//
//  IntroduceViewController.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/01/20.
//

import UIKit

class intorduceViewController: UIViewController, UITextViewDelegate {

    let myUserDefaults = UserDefaults.standard
    
    @IBOutlet var navIntroduce: UINavigationItem!

    @IBOutlet var lblAboutMe: UILabel!
    
    @IBOutlet var txtAboutMe: UITextView!

    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        txtAboutMe.addDoneButtonOnKeyboard()
        
        placeholderSet(txtAboutMe)
        
        btnNext.isEnabled = false
       
        SetLocalized()
       
        txtAboutMe.text = myUserDefaults.string( forKey: UserDefault.AboutMe.toString() )
    }

    func SetLocalized() {
        
        lblAboutMe.text = "📝" + "About Me".localized()
        
        navIntroduce.title = "SelfIntroduce".localized()
        
        btnNext.setTitle( "Continue".localized(), for: .normal )
        
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
        if txtAboutMe.text.count > 30 {
            btnNext.isEnabled = true
        }
    }

    @IBAction func Next(_ sender: UIButton) {
        
        SaveUserDefault( key: UserDefault.AboutMe.toString(), value: txtAboutMe.text! )
        
        if Joined() {
            
            dismiss(animated: true)
            
        } else {

            self.performSegue( withIdentifier: "Picture", sender: self )
            
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

