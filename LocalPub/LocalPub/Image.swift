//
//  Image.swift
//  LocalPub
//
//  Created by Serang MacBook Pro 16 on 2022/02/09.
//

import Foundation
import UIKit
import FirebaseStorage

func uploadImage( filePath: String, img: UIImage, contentType: String = "image/png" ) {
    
    var imgData = Data()
    imgData = img.jpegData(compressionQuality: 0.8)!
    
    let metaData = StorageMetadata()
    metaData.contentType = contentType  // "image/png"
    
    let firebaseReference = Storage.storage().reference().child( filePath )
    
    firebaseReference.putData( imgData, metadata: metaData) { metaData, error in
        
        firebaseReference.downloadURL { url, _ in
            print( "image Upload url: \(url!)" )
        }
    }
    
}

func uploadImage( filePath: String, img: UIImage, contentType: String = "image/png", completion: @escaping (URL) -> Void ) {
    
    var data = Data()
    data = img.jpegData(compressionQuality: 0.8)!
    
    let metaData = StorageMetadata()
    metaData.contentType = contentType  // "image/png"
    
    let firebaseReference = Storage.storage().reference().child( filePath )
    
    firebaseReference.putData( data,metadata: metaData ) { ( metaData, error ) in
        
        if let error = error {
            
            print( error.localizedDescription )
            
        } else {
            
            firebaseReference.downloadURL { (url, error) in
                if let url = url {
                    print( "Upload Success URL: \(url)" )
                    completion( url )
                }
            }

        }
    }
    
}

func getRefURL( userUID: String, userGender: Bool ) -> String {
    
    //let strGender = ( Gender ? "female" : "male" )
    //let refURL = "gs://localpub-99413.appspot.com/Users/\(strGender)/\(userUID).jpg"
    let refURL = "gs://localpub-99413.appspot.com/Users/all/\(userUID).jpg"

    return refURL
}

func drawUserImage( imgView: UIImageView, userUID: String, userGender: Bool ) {

    let refURL = getRefURL( userUID: userUID, userGender: userGender )
    
    Storage.storage().reference( forURL: refURL ).downloadURL { (url, error) in
        
        //print(url!)
        
        let data = NSData( contentsOf: url! )
        let image = UIImage( data: data! as Data )
        
        imgView.layer.cornerRadius = imgView.frame.height/2
        imgView.layer.borderWidth = 1
        imgView.clipsToBounds = true
        imgView.layer.borderColor = UIColor.clear.cgColor
        
        imgView.image = image
    }

}


func downloadUserImage(_ userUID: String, userGender: Bool ) async throws -> UIImage? {
        
    try await withUnsafeThrowingContinuation { continuation in
    
        let refURL = getRefURL( userUID: userUID, userGender: userGender )
        
        Storage.storage().reference( forURL: refURL ).downloadURL { (url, error) in

            if let url = url {
                
                let data = NSData( contentsOf: url )
                let image = UIImage( data: data! as Data )
                continuation.resume( returning: image )
                return
            }
            
            if let err = error {
                continuation.resume(throwing: err)
                return
            }

            fatalError("should not get here")
        
        }
        
    }

}

func downloadUserImageURL(_ userUID: String, userGender: Bool, completion: @escaping (URL) -> Void ) {
    
    let refURL = getRefURL( userUID: userUID, userGender: userGender )
    
    let firebaseReference = Storage.storage().reference( forURL: refURL )
            
    firebaseReference.downloadURL { (url, error) in
        if let url = url {
            //print( "Download URL: \(url)" )
            completion( url )
        }
    }
    
}


