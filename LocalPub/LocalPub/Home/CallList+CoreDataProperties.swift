//
//  CallList+CoreDataProperties.swift
//  LocalPubHome
//
//  Created by Serang MacBook Pro 16 on 2022/02/08.
//
//

import Foundation
import CoreData


extension CallList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CallList> {
        return NSFetchRequest<CallList>(entityName: "CallList")
    }

    @NSManaged public var callDate: Date?
    @NSManaged public var callGender: Int16
    @NSManaged public var callLanguage: Int16
    @NSManaged public var callUID: String?
    @NSManaged public var callName: String?
    @NSManaged public var callTime: Int16
    @NSManaged public var callArea: [Double]?

}

extension CallList : Identifiable {

}
