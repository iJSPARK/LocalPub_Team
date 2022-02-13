//
//  Misc.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/02/09.
//

import Foundation
import UIKit

func AlertOK( title: String, message: String, viewController: UIViewController ) {

    let alert = UIAlertController( title: title, message: message, preferredStyle: UIAlertController.Style.alert )
    
    let okAction = UIAlertAction( title: "OK", style: .default ) { (action) in }
    alert.addAction(okAction)
    
    viewController.present( alert, animated: false, completion: nil )

}

func AlertCancel( title: String, message: String, alerts: [UIAlertAction], viewController: UIViewController ) {

    let alert = UIAlertController( title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet )
    
    alerts.forEach { alertControl in
        alert.addAction( alertControl )
    }
    
    let cancel = UIAlertAction( title: "Cancel".localized(), style: .cancel, handler: nil )
    alert.addAction(cancel)
    
    viewController.present( alert, animated: true, completion: nil )

}
