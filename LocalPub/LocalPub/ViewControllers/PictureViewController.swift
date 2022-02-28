//
//  PictureViewController.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/02/13.
//

import UIKit
import Firebase

class pictureViewController: UIViewController {
    
    let myUserDefaults = UserDefaults.standard
    
    private var userUID: String = ""
    
    let picker = UIImagePickerController()
    
    private var isMainImage: Bool = true
    
    @IBOutlet var stackSecurity: UIStackView!
   
    @IBOutlet var imageMainView: UIImageView!
    @IBOutlet var imageSecondaryView: UIImageView!
    
    @IBOutlet var lblUploadPicture: UILabel!
    @IBOutlet var lblUploadPictureDescription: UILabel!
    @IBOutlet var lblSecurityCalls: UILabel!
    @IBOutlet var lblSecurityDescription: UILabel!
    
    @IBOutlet var lblMainPicture: UILabel!
    @IBOutlet var lblSecondaryPicture: UILabel!
    
    @IBOutlet var btnNext: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userUID = self.myUserDefaults.string( forKey: UserDefault.UID.toString() ) ?? ""
        
        picker.delegate = self
        
        stackSecurity.layer.cornerRadius = 20
        stackSecurity.layer.borderWidth = 1
        stackSecurity.layer.borderColor = UIColor.tintColor.cgColor
        
        imageMainView.layer.cornerRadius = imageMainView.frame.height/3
        imageMainView.layer.borderWidth = 1
        imageMainView.clipsToBounds = true
        imageMainView.layer.borderColor = UIColor.gray.cgColor
        imageMainView.isUserInteractionEnabled = true
        
        imageSecondaryView.layer.cornerRadius = imageSecondaryView.frame.height/3
        imageSecondaryView.layer.borderWidth = 1
        imageSecondaryView.clipsToBounds = true
        imageSecondaryView.layer.borderColor = UIColor.gray.cgColor
        imageSecondaryView.isUserInteractionEnabled = true
        
        GetUserData() { userData in
         
            let dateform = DateFormatter()
            dateform.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if let lastUpdate = userData![UserDefault.LastUpdate.toString()] {
                print( "LastUpdate: \(lastUpdate), \(type(of:lastUpdate))" )
            }
            
            if let lastUpdateDefault = self.myUserDefaults.value(forKey: UserDefault.LastUpdate.toString() ) as? Date {
                print( "LastUpdateDefault: \(lastUpdateDefault), \(type(of:lastUpdateDefault))" )
            }
            
        }
        
        if imageMainView.image == nil {
            
            let fileName = userUID
            if let img = ImageFileManager.shared.getSavedImage( named: fileName ) {
                
                imageMainView.image = img

            } else {

                downloadUserImage( fileName ) { completion in
                    
                    if let img = completion {
                        self.imageMainView.image = img
                        ImageFileManager.shared.saveImage( image: img, name: fileName ) { onSuccess in }

                    }
                }
            }
                        
        }

        if imageSecondaryView.image == nil {
            
            let fileName = "\(userUID)_Secondary"
            if let img = ImageFileManager.shared.getSavedImage( named: fileName ) {
                
                imageSecondaryView.image = img
                
            } else {

                downloadUserImage( fileName ) { completion in
                    
                    if let img = completion {
                        self.imageSecondaryView.image = img
                        ImageFileManager.shared.saveImage( image: img, name: fileName ) { onSuccess in }

                    }
                }
            }
            
        }
        
        self.picker.allowsEditing = true
        
        SetLocalized()
        
         checkNextEnable()
        
    }
    
    // setLocalized
    func SetLocalized() {
        
        lblUploadPicture.text = "UploadPicture".localized()
        lblUploadPictureDescription.text = "UploadPictureDescription".localized()
        lblSecurityCalls.text = "SecurityCalls".localized()
        lblSecurityDescription.text = "SecurityDescription".localized()
        
        lblMainPicture.text = "MainPicture".localized()
        lblSecondaryPicture.text = "SecondaryPicture".localized()
        
        btnNext.setTitle( "Continue".localized(), for: .normal )

    }
    
    @objc func mainImagePressed() {
        print( "click Main Image")
    }
    
    private func GetUserImage() {

        let alerts: [UIAlertAction] = [
            UIAlertAction( title: "TakePictureAlbum".localized(), style: .default) { (action) in self.openLibrary() },
            UIAlertAction( title: "TakePictureCamera".localized(), style: .default) { (action) in
                self.openCamera()
            }
        ]
        
        AlertCancel( title: "TakePictureTitle".localized(), message: "TakePictureDescription".localized(), alerts: alerts, viewController: self )
        
    }
    
    func openLibrary() {
        
        print( "Run openLibrary()" )
        
        picker.sourceType = .photoLibrary

        present( picker, animated: false, completion: nil )
    }
    
    func openCamera() {
        
        print( "Run openCamera()" )
        
        if( UIImagePickerController.isSourceTypeAvailable(.camera) ){

            picker.sourceType = .camera

            present( picker, animated: false, completion: nil )

        } else{

            print( "Camera not available" )
            
            AlertOK( title: "CameraError".localized(), message: "CameraRunError".localized(), viewController: self )

        }
        
    }
    
    func checkNextEnable() {
    
        btnNext.isEnabled = ( imageMainView.image != nil  && imageSecondaryView.image != nil )
        
    }
    
    func saveImage(_ isMainImage: Bool ) {
        
        guard let userImage = ( isMainImage ? imageMainView.image : imageSecondaryView.image ) else { return }
        
        let fileName = isMainImage ? userUID : "\(userUID)_Secondary"
        
        ImageFileManager.shared.saveImage( image: userImage, name: fileName ) { onSuccess in
        
            print( "saveImage onSuccess: \(fileName) : \(onSuccess)" )
            
            if onSuccess {
                if isMainImage {
                    self.imageMainView.image = ImageFileManager.shared.getSavedImage( named: fileName )
                } else {
                    self.imageSecondaryView.image = ImageFileManager.shared.getSavedImage( named: fileName )
                }
            }
        }
        
        uploadImage( filePath: "Users/\(fileName)", img: userImage ){ completion in
        
            if let url = completion {
                print( "Success Save to Firebase Store: \(url)" )
            }
        }

    }
    
    @IBAction func didTapMainImageView(_ sender: UITapGestureRecognizer) {
        print("did tap Main image view", sender)
        isMainImage = true
        GetUserImage()
        checkNextEnable()
    }
    
    @IBAction func didTapSecondaryImageView(_ sender: UITapGestureRecognizer) {
        print("did tap Secondary image view", sender)
        isMainImage = false
        GetUserImage()
        checkNextEnable()
    }
    
    @IBAction func Next(_ sender: UIButton) {
        
        saveImage(true)
        saveImage(false)
        
        if Joined() {
            
            // Navigation Controller 사용시 - Pop
            //self.navigationController?.popViewController( animated: true )
            
            // Present 사용시
            dismiss( animated: true )
            
        } else {

            //Joined( true )
            GoHome()
            
        }
        
    }
    
}

extension pictureViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        info.forEach { (infoKey, infoValue) in
            print( "infoKey: \(infoKey)" )
            print( "infoValue: Type \(type(of:infoValue)), Value: \(infoValue)" )
        }
        
        if info[UIImagePickerController.InfoKey.mediaType] as! String == "public.image" {
            print( "Type image OK" )
        }
    
        var userImage : UIImage?

        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            userImage = image
            
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImage = image
        }
        
        if userImage != nil {
                
            if self.isMainImage {
                self.imageMainView.image = userImage
            } else {
                self.imageSecondaryView.image = userImage
            }
 
        }
        
        picker.dismiss( animated: true, completion: nil )
        
    }
    
}


