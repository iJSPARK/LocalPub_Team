//
//  Login.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/02/21.
//

import Foundation
import UIKit
import Firebase

func Login() -> Bool {

    var isLoggedIn: Bool = false

    if let user = Auth.auth().currentUser {
        
        Auth.auth().languageCode = NSLocale.autoupdatingCurrent.languageCode!
        
        print( "Aleady Logined! - eMail:\(user.email ?? "") / Phone:  \(user.phoneNumber ?? "")")
        
        isLoggedIn = true

    }
    
    return isLoggedIn
    
}

func LogOut() {
    
    do {
        
        try Auth.auth().signOut()
        print( "Sign out complete!")
        SaveUserDefault( key: UserDefault.Login.toString(), value: 0 )
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController( "LoginNavStoryboard", "loginNavController" )
        
    } catch {
        
        print( "Sign out error")
    }
    
}
