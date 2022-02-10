//
//  Call.swift
//  LocalPubHome
//
//  Created by Serang MacBook Pro 16 on 2022/02/06.
//

import Foundation
import UIKit
import CoreData
import Alamofire
import CloudKit

struct Call: Codable {
       
    var callUID: String?
    var callDate: String?
    var callName: String?
    var callGender: Bool
    var callTime: Int64
    var callImage: String?
    
    init( callUID: String,
          callDate: String,
          callName: String,
          callGender: Bool,
          callTime: Int64,
          callImage: String ) {
        
        self.callUID = callUID
        self.callDate = callDate
        self.callName = callName
        self.callGender = callGender
        self.callTime = callTime
        self.callImage = callImage
        
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
                    call.callName = callMaked.callName!
                    call.callGender = callMaked.callGender
                    call.callTime = callMaked.callTime
                    call.callImage = callMaked.callImage!

                    do {
                        try context.save()
                        print( "Save Call Data to CoreData : OK!")
                        
                    } catch {
                        print( error.localizedDescription )
                    }

                }
            
            }
            
        }
        
        if let err = response.error {
            print( "error: \(err) -  \(err.localizedDescription)" )
        }
        
    }
    
}

