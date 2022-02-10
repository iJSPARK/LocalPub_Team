//
//  CallViewController.swift
//  MovieListQuiz
//
//  Created by Serang MacBook Pro 16 on 2022/02/01.
//

import UIKit

class CallViewController: UIViewController {

    var callUID: String?
    var callName: String?
    var callGender: Bool?
    var callDate: Date?
    var callTime: Int64?

    @IBOutlet var navCallTitle: UINavigationItem!
    
    @IBOutlet var callImage: UIImageView!
    @IBOutlet var callNameLabel: UILabel!
    @IBOutlet var callDateLabel: UILabel!
    @IBOutlet var callTimeLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        drawUserImage( imgView: callImage, userUID: callUID!, userGender: callGender! )
        
        callNameLabel.text = callName!
        
        let dateform = DateFormatter()
        dateform.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        callDateLabel.text = "CallDate".localized() +
        ": \(dateform.string( from: callDate! ) )"
        
        callTimeLabel.text = "CallTime".localized() +
        ": \( callTime! )"
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
//        self.performSegue(withIdentifier: "unwindToCallList", sender: self )
    }
    
}
