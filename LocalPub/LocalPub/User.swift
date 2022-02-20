//
//  User.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/01/28.
//

import Foundation
import Firebase

enum UserDefault: String {

    case eMail = "eMail"
    case eMailPW = "eMailPW"
    case PhoneNo = "PhoneNo"
    case PhoneVerificationID = "PhoneVerificationID"
    case Name = "Name"
    case Gender = "Gender"
    case Birth = "Birth"
    case Residence = "Residence"
    case Nationality = "Nationality" // ForeignLanguage
    case NativeLanguageInfo = "NativeLanguageInfo"
    case ForeignLanguageInfo = "ForeignLanguageInfo"
    case Experience = "Experience"
    case AboutMe = "AboutMe"
    case UID = "UID"
    case Login = "Login"
    case CreationDate = "CreationDate"
    case SignedInDate = "SignedInDate"
    case LogDate = "LogDate"
    case AuthState = "AuthState"
    
    func toString() -> String {
        return self.rawValue
    }
}

func initUserDefaultValue() -> [ UserDefault : Any ] {
    
    let userDefault: [ UserDefault : Any ] = [
        .eMail: "",
        .eMailPW: "",
        .PhoneNo: "",
        .PhoneVerificationID: "",
        .Name: "",
        .Gender: -1,
        .Birth: "",
        .Nationality: "",
        .Residence: "",
        .NativeLanguageInfo: 0,
        .ForeignLanguageInfo: [0, 0, 0],
        .Experience: "",
        .AboutMe: "",
        .UID: "",  //RofzE9N1mRZp97aTzy0Au1U66mG2
        .Login: 0,
        .CreationDate: -1,
        .SignedInDate: -1,
        .LogDate: -1,
        .AuthState: 0
    ]
    
    return userDefault
}

func SaveUserDefault( key: String, value: Any ) {
    
    let db: Firestore = Firestore.firestore()
    let myUserDefaults = UserDefaults.standard
    
    let logDate = Date()
    
    myUserDefaults.set( value, forKey: key )
    myUserDefaults.set( logDate, forKey: UserDefault.LogDate.toString() )
    
    if let userUID = myUserDefaults.string( forKey: UserDefault.UID.toString() ) {
        
        let docRef = db.collection("User").document( userUID )

        docRef.updateData( [
            UserDefault.LogDate.toString(): logDate,
            key: value ] ) { err in
            if let err = err {
                print( err)
            } else {
                print( "Save UserDefaults Data! - \(key) : \(value)" )
            }
        }
    }
    
}

func SaveUserDefaultInit( user: Firebase.User, eMailPW: String ) {
    
    let db: Firestore = Firestore.firestore()
    let myUserDefaults = UserDefaults.standard

    print( "Login New or Defferent User UID!" )
    
    var userDefaults = initUserDefaultValue()
        
    userDefaults[.UID] = user.uid
    userDefaults[.Login] = 1
    userDefaults[.eMail] = user.email ?? ""
    userDefaults[.eMailPW] = eMailPW
    userDefaults[.PhoneNo] = user.phoneNumber ?? ""
    userDefaults[.CreationDate] = user.metadata.creationDate
    userDefaults[.SignedInDate] = user.metadata.lastSignInDate
    
//    print( "Created Date: \(user.metadata.creationDate!.formatted() )" )
//    print( "Creation Date: \(user.metadata.creationDate!.formatted(date: .long, time: .omitted) )" )
//    print( "SignedIn Date: \(user.metadata.lastSignInDate!.formatted() )" )
//    print( type(of:user.metadata.creationDate!) )
    
    var saveUserDefaults = Dictionary<String,Any>()
    
    for userData in userDefaults {
        
        print( "User Data: \(userData.key) -> \(userData.value)" )
        
        myUserDefaults.set( userData.value, forKey: userData.key.toString() )
        
        saveUserDefaults[userData.key.toString()] = userData.value
    }
    
    let docRef = db.collection("User").document( user.uid )

    docRef.setData( saveUserDefaults ) { err in
        if let err = err {
            print( err)
        } else {
            print( "Save UserDefaults Initial Data!" )
        }
    }
        
}

func GetUserDefaultFromDB( key: String, completion: @escaping (Any?) -> Void ) {
        
    let db: Firestore = Firestore.firestore()
    let myUserDefaults = UserDefaults.standard
    
    if let userUID = myUserDefaults.string( forKey: UserDefault.UID.toString() ) {
    
        db.collection("User").whereField( "UID", isEqualTo: userUID ).getDocuments() { ( querySnapshot, err ) in
            
            if let err = err {
                
                print( "Error getting documents: \(err)" )
                
                completion(nil)
                
            } else {
                
                for document in querySnapshot!.documents {
                    
                    print( "\(document.documentID) => \(type(of:document.data())) : count \(document.data().count)" )
                    
                    for userData in document.data(){
                        
                        if userData.key == key {
                            
                            print( "User Data: \(userData.key) -> \(userData.value)" )
                            
                            myUserDefaults.set( userData.value, forKey: userData.key )
                        
                            completion( userData.value )
                        }

                    }
                }
                
            }
            
        }
            
    }
    
}

func GetUserDefault( user: Firebase.User, eMailPW: String  ) {
    
    let db: Firestore = Firestore.firestore()
    let myUserDefaults = UserDefaults.standard

    print( "Check UID : \(user.uid) & Get UserDefault Data" )
    
    db.collection("User").whereField( "UID", isEqualTo: user.uid ).getDocuments() { ( querySnapshot, err ) in
            
        if let err = err {
            
            print("Error getting documents: \(err)")
            
        } else {
            
            print("Total Documents: \(querySnapshot!.documents.count)")
            
            if querySnapshot!.documents.count == 0 {
                
                SaveUserDefaultInit( user: user, eMailPW: eMailPW )
                
            } else {
                
                print("User is aleady joined!")
            
                for document in querySnapshot!.documents {
                    
                    print("\(document.documentID) => \(type(of:document.data())) : count \(document.data().count)")
                    
                    for userData in document.data(){
                        
                        print( "User Data: \(userData.key) -> \(userData.value)" )
                        
                        if type(of:userData.value) != Timestamp.self {
                            //print("TimeStamp!")
                            myUserDefaults.set( userData.value, forKey: userData.key )
                        }


                    }
                }
                
            }
            
            
        }
            
    }
    
    
}


extension String{

    func localized( comment: String = "" ) -> String {

        return NSLocalizedString( self, comment: comment )
    }

    func localized( with argument: CVarArg = [], comment: String = "" ) -> String {

        return String( format: self.localized( comment: comment ), argument )
    }

}
