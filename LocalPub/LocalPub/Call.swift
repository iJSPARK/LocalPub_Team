//
//  Call.swift
//  LocalPubHome
//
//  Created by Serang MacBook Pro 16 on 2022/02/06.
//

import Foundation
import UIKit
import Alamofire
import CoreData
import Firebase

struct Call: Codable {
       
    var callUID: String?
    var callDate: String?
    var callGender: Bool
    var callLanguage: String?
    var callName: String?
    var callTime: Int64
    var callArea: [String]?
    
    init( callUID: String,
          callDate: String,
          callGender: Bool,
          callLanguage: String,
          callName: String,
          callTime: Int64,
          callArea: [String] ) {
        
        self.callUID = callUID
        self.callDate = callDate
        self.callGender = callGender
        self.callLanguage = callLanguage
        self.callName = callName
        self.callTime = callTime
        self.callArea = callArea
        
    }
}


func MakeCall() async throws -> Call {
    
    try await withUnsafeThrowingContinuation { continuation in
        
        let id = String( Int.random(in: 1..<100) )
        let url = "https://61795804aa7f3400174049d7.mockapi.io/users/" + id

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        AF.request(url).validate().responseDecodable(of: Call.self, decoder: decoder) {
        //AF.request(url).validate().responseDecodable(of: Call.self, decoder: CustomDecoder() ) {

            response in

            //print( response )
            
            if let call = response.value {
                
                //print( type(of: call ) )
                //print( "MakeCall: \(call)" )

                continuation.resume(returning: call)
                return
            }
            
            if let err = response.error {
                continuation.resume(throwing: err)
                return
            }
            
            fatalError("should not get here")
            
        }

    }
    
}

class CustomDecoder: JSONDecoder {
    let dateFormatter = DateFormatter()

    override init() {
        super.init()
        dateDecodingStrategy = .iso8601
    }
}


func MakeUserCall() {
    
    let id = String( Int.random(in: 1..<100) )
    let url = "https://61795804aa7f3400174049d7.mockapi.io/users/" + id

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    AF.request(url).validate().responseDecodable(of: Call.self, decoder: decoder) {
    //AF.request(url).validate().responseDecodable(of: Call.self, decoder: CustomDecoder() ) {

        response in

        //print( response )
        
        if let callMaked = response.value {
            
            //print( type(of: callMaked ) )
            //print( "MakeCall: \(callMaked)" )

            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
            let context = appDelegate?.persistentContainer.viewContext

            let entityName: String = "CallList"
            
            if let context = context,
                let entity: NSEntityDescription
                = NSEntityDescription.entity( forEntityName: entityName, in: context ) {
                
                if let call = NSManagedObject( entity: entity, insertInto: context) as? CallList {
                    
                    let iso8601DateFormatter = ISO8601DateFormatter()
                    iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // option형태의 포맷
                    iso8601DateFormatter.timeZone = TimeZone(abbreviation: "KST")
                    //let callDate = iso8601DateFormatter.date( from: callMaked.callDate! )!
                    let callDate = Date()
                    
                    //let dateString: String = "2022-02-22 22:22:22"
                    //let dateFormatter = DateFormatter()
                    //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    //dateFormatter.timeZone = NSTimeZone( name: "Asia/Seoul") as TimeZone?
                    //dateFormatter.locale = Locale(identifier: "ko_kr") // 한국 시간 지정
                    //dateFormatter.timeZone = TimeZone(abbreviation: "KST") // 한국 시간대 지정
                    //let callDate: Date = dateFormatter.date(from: call.callDate! )

                    //print( callDate )
                    
                    call.callUID = callMaked.callUID!
                    //call.callDate = callMaked.callDate!
                    call.callDate = callDate
                    call.callGender = callMaked.callGender
                    call.callLanguage = callMaked.callLanguage
                    call.callName = callMaked.callName!
                    call.callTime = callMaked.callTime
                    call.callArea = callMaked.callArea!

                    do {
                        try context.save()
                        print( "Save Call Data to CoreData : OK!")
                        
                    } catch {
                        print( error.localizedDescription )
                    }
                    
                    SaveCallData( call: call )

                }
            
            }
            
        }
        
        if let err = response.error {
            print( "error: \(err) -  \(err.localizedDescription)" )
        }
        
    }
    
}

func SaveCallData( call: CallList ) {
    
    if let userUID = Auth.auth().currentUser?.uid {
        
        //let db = Database.database().reference()
        let ref = Database.database(url: "https://localpub-99413-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()

        
        let callData: [String:Any] = [ "callGender": call.callGender,
                                       "callLanguage": call.callLanguage!,
                                       "callUID": call.callUID!,
                                       "callName": call.callName!,
                                       "callTime": call.callTime,
                                       "callArea": call.callArea! ]
        
        let dateform = DateFormatter()
        dateform.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let callDate = dateform.string( from: call.callDate!)
        
        let child = "/CallList/\(userUID)/\(callDate)/"
        
        let childUpdates = [ child: callData ]
        
        ref.updateChildValues( childUpdates ) { (error, retRef) in
        //ref.child( child ).setValue( callData ) { (error, retRef) in
            if let error = error {
                print( "Firebase Realtime DB: Data cound not be saved: \(error)")
            } else {
                print( "Save Call Data to Firebase Realtime DB : OK!")
                
            }

        }
        
        ref.child( child ).getData( completion: { (error, snapshot) in
            
            if let error = error {
                print( "Load error: \(error) \(error.localizedDescription)" )
                return
            }
            
            print( "Load Call Data from Firebase Realtime DB : OK!" )
            print( snapshot.value! )
            
        })
        

    }
    
}
