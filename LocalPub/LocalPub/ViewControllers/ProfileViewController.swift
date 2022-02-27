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
    
    // to store the current active textfield
    var activeTextField: UITextField? = nil
    
    var selectedNationality: Country? = nil

    @IBOutlet weak var profileInformationLabel: UILabel!
    
    @IBOutlet weak var profileInfomationDescriptionLabel: UILabel!
    
    @IBOutlet var navProfile: UINavigationItem!
    
    @IBOutlet weak var birthDateTextField: UITextField!
    
    @IBOutlet var txtName: UITextField!

    @IBOutlet var scGender: UISegmentedControl!
    
    @IBOutlet var txtResidence: UITextField!
    
    @IBOutlet weak var nationalityButton: UIButton!
    
    @IBOutlet var btnNext: UIButton!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        txtName.delegate = self
        txtResidence.delegate = self
        
        SetLocalized()
        
        btnCheckJoined()
        
        txtName.text = myUserDefaults.string(forKey: UserDefault.Name.toString() )
        
        scGender.selectedSegmentIndex = myUserDefaults.integer(forKey: UserDefault.Gender.toString() )
        
        txtResidence.text = myUserDefaults.string(forKey: UserDefault.Residence.toString() )
        
        birthDateTextField.text = myUserDefaults.string(forKey: UserDefault.Birth.toString() )
        
        nationalityButton.setTitle(nationalityExpression(), for: .normal)
        nationalityButton.setTitleColor(.black, for: .normal)
        
        
        createDatePicker()
        
        btnNextEnable()
        
        registerForKeyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // update nationality title
        updateNationalityTitle()
    }
    
    func updateNationalityTitle() {
        if let nationality = selectedNationality {
            nationalityButton.setTitle(nationality.countryEmoji + " " + nationality.countryName, for: .normal)
            
            nationalityButton.setTitleColor(.black, for: .normal)
        }
    }
    
    func SetLocalized() {
        
        navProfile.title = "ProfileInformation".localized()
        birthDateTextField.placeholder = "Birth".localized()

        txtName.placeholder = "InputName".localized()
        
        btnNext.setTitle( "Continue".localized(), for: .normal )
        
        nationalityButton.setTitle("Nationality".localized(), for: .normal)
        nationalityButton.setTitleColor(.opaqueSeparator, for: .normal)
        
        txtResidence.placeholder = "Residence".localized()
        
        scGender.setTitle( "Male".localized(), forSegmentAt: 0 )
        
        scGender.setTitle( "Female".localized(), forSegmentAt: 1 )
        
        profileInformationLabel.text = "ProfileInformation".localized()
        
        profileInfomationDescriptionLabel.text = "ProfileInformationDescription".localized()
    }
    
    func nationalityExpression() -> String {
        
        let nationalityEmoji = myUserDefaults.string(forKey: UserDefault.NationalityEmoji.toString() ) ?? ""
        
        let nationalityName = myUserDefaults.string(forKey: UserDefault.Nationality.toString() ) ?? ""
        
        return nationalityEmoji + nationalityName
        
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
    
    func checkAllValues() -> Bool {
        if txtName.text != "" && txtResidence.text != "" &&  birthDateTextField.text != "" && (scGender.selectedSegmentIndex == 0 || scGender.selectedSegmentIndex == 1) && nationalityButton.titleLabel != nil {
            print("Have all value")
            
            return true
        } else {
            return false
        }
    }
    
    func btnNextEnable() {
        
        btnNext.isEnabled = checkAllValues()

        // IBA 이벤트시 확인
        txtName.addTarget(self, action: #selector(textFieldDidChanged(textField:)), for: .editingDidEnd)
        
        txtResidence.addTarget(self, action: #selector(textFieldDidChanged(textField:)), for: .editingDidEnd)
        
        birthDateTextField.addTarget(self, action: #selector(textFieldDidChanged(textField:)), for: .editingDidEnd)
        
        nationalityButton.addTarget(self, action: #selector(nationalitySelected(button:)), for: .touchUpInside)
        
        scGender.addTarget(self, action: #selector(genderSelected(segmentedControl:)), for: .valueChanged)
    }
    
    @objc func textFieldDidChanged(textField: UITextField) {
        btnNext.isEnabled = checkAllValues()
    }
    
    @objc func nationalitySelected(button: UIButton) {
        btnNext.isEnabled = checkAllValues()
    }
    
    @objc func genderSelected(segmentedControl: UISegmentedControl) {
        btnNext.isEnabled = checkAllValues()
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
        
        doneButton.tintColor = UIColor.systemPurple

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
    
    func saveData() {
        SaveUserDefault( key: UserDefault.Name.toString(), value: txtName.text! )
        
        SaveUserDefault( key: UserDefault.Residence.toString(), value: txtResidence.text! )
        
        SaveUserDefault( key: UserDefault.Birth.toString(), value: birthDateTextField.text! )
    
        SaveUserDefault(key: UserDefault.NationalityEmoji.toString(), value: selectedNationality?.countryEmoji ?? myUserDefaults.string(forKey: UserDefault.NationalityEmoji.toString() )! )
        
        SaveUserDefault( key: UserDefault.Nationality.toString(), value: selectedNationality?.countryName ?? myUserDefaults.string(forKey: UserDefault.Nationality.toString() )! )
        
        SaveUserDefault( key: UserDefault.Gender.toString(), value: scGender.selectedSegmentIndex )
    }
    
    @IBAction func Next(_ sender: UIButton) {

        saveData()
        self.performSegue( withIdentifier: "Language", sender: self )
//        if Joined() {
//
//            dismiss(animated: true)
//
//        } else {
//
//            self.performSegue( withIdentifier: "Language", sender: self )
//
//        }
        
    }
    
    @IBAction func saveDataAferJoined(_ sender: Any) {
        
        if checkAllValues() {
        AlertOK( title: "ProfileEditSuccess".localized(), message: "SuccessProfileEdit".localized(), viewController: self )
            saveData()
        } else {
            AlertOK( title: "ProfileEditFail".localized(), message: "FailProfileEdit".localized(), viewController: self )
        }
        
        // self.navigationController?.popViewController(animated: true)
    }
    
    func btnCheckJoined() {
        if Joined() {
            btnNext.isHidden = true
            self.navigationItem.rightBarButtonItem = self.navProfile.rightBarButtonItem
        } else {
            btnNext.isHidden = false
            self.navProfile.rightBarButtonItem = nil
        }
        
    }
    
    
    @IBAction func unwindToProfile(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }

}



