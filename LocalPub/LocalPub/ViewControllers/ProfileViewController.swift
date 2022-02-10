//
//  profileViewController.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/01/20.
//

import UIKit

class profileViewController: UIViewController, UITextFieldDelegate {

    let myUserDefaults = UserDefaults.standard
    
    let datePicker = UIDatePicker()
    
    // let listResidenceKorea = [ "Seoul", "Busan", "Incheon" ]

    @IBOutlet var navProfile: UINavigationItem!
    
    @IBOutlet weak var birthDateTextField: UITextField!
    
    @IBOutlet var btnSaveProfile: UIButton!
    
    @IBOutlet var txtName: UITextField!

    @IBOutlet var scGender: UISegmentedControl!
    
    @IBOutlet weak var nationalityTextField: UITextField!

    @IBOutlet var txtResidence: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SetLocalized()
        
        txtName.delegate = self
        txtResidence.delegate = self

        txtName.text = myUserDefaults.string(forKey: UserDefault.Name.toString() )
        
        scGender.selectedSegmentIndex = myUserDefaults.integer(forKey: UserDefault.Gender.toString() )
        
        createDatePicker() // SetBirth()
        
        txtResidence.text = myUserDefaults.string(forKey: UserDefault.Residence.toString() )
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc
    func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -100 // Move view 150 points upward
    }

     @objc
        func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }

    
    func SetLocalized() {
        
        navProfile.title = "ProfileInformation".localized()
        birthDateTextField.placeholder = "Birth".localized()
        btnSaveProfile.setTitle( "Continue".localized(), for: .normal )
        
        txtName.placeholder = "InputName".localized()
        nationalityTextField.placeholder = "Nationality".localized()
        txtResidence.placeholder = "Residence".localized()
        
        scGender.setTitle( "Male".localized(), forSegmentAt: 0 )
        
        scGender.setTitle( "Female".localized(), forSegmentAt: 1 )
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtName.resignFirstResponder()
        self.txtResidence.resignFirstResponder()
        return true
    }
    
    func createDatePicker() {
        // preferred Style = Wheels
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        
        // tool bar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        // bar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolBar.setItems([doneButton], animated: true)
        
        // assign tool bar
        birthDateTextField.inputAccessoryView = toolBar
        birthDateTextField.inputView = datePicker
        
        // date picker mode
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed() {
        let datestr = myUserDefaults.string(forKey: "birthState")
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        birthDateTextField.text =  dateFormatter.string(from: datePicker.date)
        
        let datetime = dateFormatter.date(from: datestr ?? dateFormatter.string( from: Date() ) )
        
        datePicker.setDate(datetime!, animated: true)
    
        self.view.endEditing(true)
    }
    
    
    /*
    func SetBirth() {
        
        let birth = myUserDefaults.string( forKey: UserDefault.Birth.toString() )
        
        let dateform = DateFormatter()
        dateform.dateFormat = "yyyy-MM-dd"
        
        let birthStr = birth != "" ? birth : dateform.string( from: Date() )
        
        let datetime = dateform.date( from: birthStr! )
                         
        dpBirth.setDate( datetime!, animated: true)
    }
    
    func SetResidenceMenu() {
        
        var actions: Array<UIAction> = []
        for i in 0...listResidenceKorea.count-1 {
            actions.append( UIAction( title: listResidenceKorea[i].localized(), state: .off, handler: { _ in self.setResidence(i) } ) )
        }

        let buttonMenu = UIMenu( title: "SelectResidence".localized(), children: actions )
        btnResidence.menu = buttonMenu
        
        btnResidence.setTitle( listResidenceKorea[ myUserDefaults.integer( forKey: UserDefault.Residence.toString() ) ].localized(), for: .normal)
        
    }
    */
    
    @IBAction func saveProfile(_ sender: UIButton) {

        SaveUserDefault( key: UserDefault.Name.toString(), value: txtName.text! )
        
        SaveUserDefault( key: UserDefault.Residence.toString(), value: txtResidence.text! )
        
        SaveUserDefault( key: UserDefault.Birth.toString(), value: birthDateTextField.text! )
    }
    
    @IBAction func selectGender(_ sender: UISegmentedControl) {
        
        print( sender.selectedSegmentIndex )
        
        SaveUserDefault( key: UserDefault.Gender.toString(), value: sender.selectedSegmentIndex )
        
    }
    
    /*
    @IBAction func selectBirth(_ sender: UIDatePicker) {
        
        let dateform = DateFormatter()
        dateform.dateFormat = "yyyy-MM-dd"
        let strDate = dateform.string( from:sender.date )
        print( strDate )
        
        SaveUserDefault( key: UserDefault.Birth.toString(), value: strDate )
        
    }
    
    
    func setResidence(_ i: Int ) {
    
        btnResidence.setTitle( listResidenceKorea[i].localized(), for: .normal)
        
        //myUserDefaults.set( i, forKey: "Residence" )
        
    }
    */
    

    
    
}


