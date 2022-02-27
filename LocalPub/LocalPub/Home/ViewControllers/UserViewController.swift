//
//  UserViewController.swift
//  LocalPubHome
//
//  Created by Serang MacBook Pro 16 on 2022/02/06.
//

import UIKit

class userViewController: UIViewController {
    
    let myUserDefaults = UserDefaults.standard
    
    private var userUID: String = ""

    @IBOutlet var imageUser: UIImageView!
    @IBOutlet var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        SetLocalized()
        
        userUID = self.myUserDefaults.string( forKey: UserDefault.UID.toString() ) ?? ""
        
        imageUser.layer.cornerRadius = imageUser.frame.height/3
        imageUser.layer.borderWidth = 1
        imageUser.clipsToBounds = true
        imageUser.layer.borderColor = UIColor.gray.cgColor
        imageUser.isUserInteractionEnabled = true
        
        GetUserImage()
        
        lblName.text = myUserDefaults.string(forKey: UserDefault.Name.toString() )
    }

    func SetLocalized() {
        
 
    }
    
    @IBAction func didTapUserImageView(_ sender: UITapGestureRecognizer) {
        self.performSegue( withIdentifier: "Picture", sender: self )
        GetUserImage()
    }
    
    func GetUserImage() {
        
        if imageUser.image == nil {
            
            let fileName = userUID
            if let img = ImageFileManager.shared.getSavedImage( named: fileName ) {
                
                imageUser.image = img

            } else {

                downloadUserImage( fileName ) { completion in
                    
                    if let img = completion {
                        self.imageUser.image = img
                        ImageFileManager.shared.saveImage( image: img, name: fileName ) { onSuccess in }

                    }
                }
            }
                        
        }
    }
    
}
