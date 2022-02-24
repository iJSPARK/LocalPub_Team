//
//  profileViewController.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/01/20.
//

import UIKit
import Foundation

class profileViewController: UIViewController, UITextFieldDelegate {

    let myUserDefaults = UserDefaults.standard
    
    let datePicker = UIDatePicker()
    
    // let listResidenceKorea = [ "Seoul", "Busan", "Incheon" ]

    // to store the current active textfield
    var activeTextField: UITextField? = nil
    
    var selectedNationality: Country? = nil

    @IBOutlet var navProfile: UINavigationItem!
    
    @IBOutlet weak var birthDateTextField: UITextField!
    
    @IBOutlet var btnSaveProfile: UIButton!
    
    @IBOutlet var txtName: UITextField!

    @IBOutlet var scGender: UISegmentedControl!
    
    @IBOutlet var txtResidence: UITextField!
    
    @IBOutlet weak var nationalityButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        
        // update nationality title
        guard let nationality = selectedNationality else {
            return
        }
        
        nationalityButton.setTitle(nationality.countryEmoji + " " + nationality.countryName, for: .normal)
        
        nationalityButton.setTitleColor(.black, for: .normal)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SetLocalized()
        
        txtName.delegate = self
        txtResidence.delegate = self
        
        btnSaveProfile.isEnabled = false
        
        txtName.text = myUserDefaults.string(forKey: UserDefault.Name.toString() )
        
        scGender.selectedSegmentIndex = myUserDefaults.integer(forKey: UserDefault.Gender.toString() )
        
        createDatePicker()
        
        txtResidence.text = myUserDefaults.string(forKey: UserDefault.Residence.toString() )
        
        birthDateTextField.text = myUserDefaults.string(forKey: UserDefault.Birth.toString() )
        
        if let text1 = myUserDefaults.string(forKey: UserDefault.NationalityEmoji.toString() ) {
            if let text2 = myUserDefaults.string(forKey: UserDefault.Nationality.toString() ) {
                nationalityButton.setTitle(text1 + " " + text2, for: .normal)
            }
        }
        
        nationalityButton.setTitleColor(.black, for: .normal)
        
        checkValues()
        
        registerForKeyboardNotification()
    }
    
    func SetLocalized() {
        
        navProfile.title = "ProfileInformation".localized()
        birthDateTextField.placeholder = "Birth".localized()
        btnSaveProfile.setTitle( "Continue".localized(), for: .normal )
        
        txtName.placeholder = "InputName".localized()
        
//        // localize 하고나서 font 크기 바껴서 조정
//        let text = NSAttributedString(string: "Nationality".localized(), attributes: [.font: UIFont.systemFont(ofSize: 15)])
//        nationalityButton.setAttributedTitle(text, for: .normal)
        
        nationalityButton.setTitle("Nationality".localized(), for: .normal)
        nationalityButton.setTitleColor(.opaqueSeparator, for: .normal)
        
        txtResidence.placeholder = "Residence".localized()
        
        scGender.setTitle( "Male".localized(), forSegmentAt: 0 )
        
        scGender.setTitle( "Female".localized(), forSegmentAt: 1 )
    }
    
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

        guard let info = notification.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return
        }

        let keyboardSize = keyboardFrameValue.cgRectValue.size

        var shouldMoveViewUp = false

        // if active text field is not nil
        // safe area 
        if let activeTextField = activeTextField {
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;

            let topOfKeyboard = self.view.frame.height - keyboardSize.height

            // if the bottom of Textfield is below the top of keyboard, move up
            if bottomOfTextField > topOfKeyboard {
              shouldMoveViewUp = true
            }
        }

        if (shouldMoveViewUp) {
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    // when user select a textfield, this method will be called
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // set the activeTextField to the selected textfield
        self.activeTextField = textField
    }
    
    // when user click 'done' or dismiss the keyboard
    func textFieldDidChanged(_ textField: UITextField) {
        self.activeTextField = nil
    }

   
    // when user 'return' key dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtName.resignFirstResponder()
        self.txtResidence.resignFirstResponder()
        return true
    }
    
    func checkText() {
        if txtName.text != "" && txtResidence.text != "" &&  birthDateTextField.text != "" && (scGender.selectedSegmentIndex == 0 || scGender.selectedSegmentIndex == 1) && selectedNationality != nil {
            btnSaveProfile.isEnabled = true
        } else {
            btnSaveProfile.isEnabled = false
        }
    }
    
    func checkValues() {
        txtName.addTarget(self, action: #selector(textFieldDidChanged(textField:)), for: .editingDidEnd)
        
        txtResidence.addTarget(self, action: #selector(textFieldDidChanged(textField:)), for: .editingDidEnd)
        
        birthDateTextField.addTarget(self, action: #selector(textFieldDidChanged(textField:)), for: .editingDidEnd)
        
        nationalityButton.addTarget(self, action: #selector(nationalitySelected(button:)), for: .touchUpInside)
        
        scGender.addTarget(self, action: #selector(genderSelected(segmentedControl:)), for: .valueChanged)
    }
    
    @objc func textFieldDidChanged(textField: UITextField) {
        checkText()
    }
    
    @objc func nationalitySelected(button: UIButton) {
        checkText()
    }
    
    @objc func genderSelected(segmentedControl: UISegmentedControl) {
        checkText()
    }
    
    func createDatePicker() {
        // preferred Style = Wheels
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels

        // tool bar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()

        // bar button
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolBar.setItems([flexSpace, doneButton], animated: true)

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
    
    @IBAction func saveProfile(_ sender: UIButton) {

        SaveUserDefault( key: UserDefault.Name.toString(), value: txtName.text! )
        
        SaveUserDefault( key: UserDefault.Residence.toString(), value: txtResidence.text! )
        
        SaveUserDefault( key: UserDefault.Birth.toString(), value: birthDateTextField.text! )
        
        SaveUserDefault(key: UserDefault.NationalityEmoji.toString(), value: selectedNationality!.countryEmoji)
        
        SaveUserDefault( key: UserDefault.Nationality.toString(), value: selectedNationality!.countryName )
        
        print("seletedNationality \(selectedNationality!.countryEmoji)")
        
        SaveUserDefault( key: UserDefault.Gender.toString(), value: scGender.selectedSegmentIndex )
        
//        // 회원가입 완료시 False
//        scGender.isEnabled = false
//        birthDateTextField.isEnabled = false
//        nationalityButton.isEnabled =  false
    }
    
    
    @IBAction func unwindToNationality(_ unwindSegue: UIStoryboardSegue) {
        //let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
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
}



