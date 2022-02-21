//
//  Login.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/02/21.
//

import Foundation
import UIKit
import Firebase


func LoggedInCheck() {

    if let user = Auth.auth().currentUser {
        
        Auth.auth().languageCode = NSLocale.autoupdatingCurrent.languageCode!
        
        print( "Aleady Logined! - eMail:\(user.email ?? "") / Phone:  \(user.phoneNumber ?? "")")
        
        GoHome()
        
    } else {
        
        Login()
        
    }
}

    
func Login() {

    setRootViewController( "LoginNavStoryboard", "loginNavController" )
    
}

func GoHome() {

    setRootViewController( "HomeTabStoryboard", "homeTabController" )
    
}

func setRootViewController(_ storyboardName: String, _ identifier: String ) {
    
    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController( storyboardName, identifier )

}

func LogOut() {
    
    do {
        
        try Auth.auth().signOut()
        
        print( "Sign out complete!")
        SaveUserDefault( key: UserDefault.Login.toString(), value: 0 )
        
        Login()
        
    } catch {
        
        print( "Sign out error")
    }
    
}

func Joined(_ setJoin: Bool = false ) -> Bool {
    
    var isJoined: Bool = false
    
    if !setJoin {
    
        let joinValue = UserDefaults.standard.integer( forKey: UserDefault.Joined.toString() )
        
        isJoined = ( joinValue == 1 )
        
    } else {
        
        SaveUserDefault( key: UserDefault.Joined.toString(), value: 1 )
        isJoined = true

    }
    
    return isJoined
        
}
