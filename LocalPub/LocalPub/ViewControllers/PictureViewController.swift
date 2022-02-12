//
//  PictureViewController.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/02/13.
//

import UIKit

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
    @IBOutlet var btnMainPicture: UIButton!
    @IBOutlet var btnSecondaryPicture: UIButton!
    
    @IBOutlet var btnContinue: UIButton!
    
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
        
        if imageMainView.image == nil {
            imageMainView.image = ImageFileManager.shared.getSavedImage( named: userUID )
        }
 
        imageSecondaryView.layer.cornerRadius = imageSecondaryView.frame.height/3
        imageSecondaryView.layer.borderWidth = 1
        imageSecondaryView.clipsToBounds = true
        imageSecondaryView.layer.borderColor = UIColor.gray.cgColor
        
        if imageSecondaryView.image == nil {
            imageSecondaryView.image = ImageFileManager.shared.getSavedImage( named: "\(userUID)_Secondary" )
        }
        
        btnContinue.isHidden = true
        
        self.picker.allowsEditing = true
        
        SetLocalized()
        
    }
    
    // setLocalized
    func SetLocalized() {
        
        lblUploadPicture.text = "UploadPicture".localized()
        lblUploadPictureDescription.text = "UploadPictureDescription".localized()
        lblSecurityCalls.text = "SecurityCalls".localized()
        lblSecurityDescription.text = "SecurityDescription".localized()
        btnMainPicture.setTitle( "MainPicture".localized(), for: .normal )
        btnSecondaryPicture.setTitle( "SecondaryPicture".localized(), for: .normal )
        
        btnContinue.setTitle( "Continue".localized(), for: .normal )

    }
    
    
    @IBAction func GetMainImage(_ sender: UIButton) {
        isMainImage = true
        GetUserImage()
    }
    
    @IBAction func GetSecondaryImage(_ sender: UIButton) {
        isMainImage = false
        GetUserImage()
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

        present(picker, animated: false, completion: nil)
    }
    
    func openCamera() {
        
        print( "Run openCamera()" )
        
        if( UIImagePickerController.isSourceTypeAvailable(.camera) ){

            picker.sourceType = .camera

            present(picker, animated: false, completion: nil)

        } else{

            print( "Camera not available" )
            AlertOK( title: "CameraError".localized(), message: "CameraRunError".localized(), viewController: self )

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
            

            let fileName = isMainImage ? userUID : "\(userUID)_Secondary"
            
            ImageFileManager.shared.saveImage( image: userImage!, name: fileName ) { onSuccess in
            
                print( "saveImage onSuccess: \(fileName) : \(onSuccess)" )
                
                if onSuccess {
                    if self.isMainImage {
                        self.imageMainView.image = ImageFileManager.shared.getSavedImage( named: fileName )
                    } else {
                        self.imageSecondaryView.image = ImageFileManager.shared.getSavedImage( named: fileName )
                    }
                }
            }
            
        }
        
        picker.dismiss( animated: true, completion: nil )
        
    }
    
}


