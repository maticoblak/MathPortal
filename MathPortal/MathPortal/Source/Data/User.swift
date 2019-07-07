//
//  User.swift
//  MathPortal
//
//  Created by Petra Čačkov on 17/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
import Parse

class User: ParseObject {
    
    var username: String?
    var userId: String?
    var tasks: [String]?
    var dateCreated: String?
    var role: [Role] = [.undefined]
    // TODO: change to birthdate
    var age: Int?
    var email: String?
    var profileImage: UIImage?
    var birthDate: Date?
    
    // TODO: create enum with current user objects
    override class var entityName: String { return "User" }
    override init() {
        super.init()
        username = PFUser.current()?.username
        userId = PFUser.current()?.objectId
        tasks = PFUser.current()?["tasks"] as? [String]
        dateCreated = DateTools.stringFromDate(date: PFUser.current()?.createdAt)
        //role = fromStringToRole(role: PFUser.current()?["role"] as? [String] )
        role = (PFUser.current()?["role"] as? [String])?.map({ Role.fromParseString($0) }) ?? [.undefined]
        age = PFUser.current()?["age"] as? Int
        email = PFUser.current()?.email
        birthDate = PFUser.current()?["birthDate"] as? Date
        
    }
    
    override init?(pfObject: PFObject?) {
        super.init(pfObject: pfObject)
    }
    
    override func generetePFObject() -> PFObject? {
        let object = pfObject ?? PFUser.current()
        object?["tasks"] = tasks == nil ? NSNull() : tasks
        object?["role"] = role.compactMap { $0.string }
        object?["age"] = age == nil ? NSNull() : age
        object?["username"] = username
        object?["email"] = email
        object?["birthDate"] = birthDate == nil ? NSNull() : tasks
        return object
    }
    
    override func updateWithPFObject(_ object: PFObject) throws {
        try super.updateWithPFObject(object)
        guard let username = object["username"] as? String, let userId = object.objectId, let dateCreated = object.createdAt, let email = object["email"] as? String else {
            throw NSError(domain: "ParseObject", code: 400, userInfo: ["dev_message": "Could not parse User data from PFObject"])
        }
        self.username = username
        self.userId = userId
        self.tasks = object["tasks"] as? [String]
        self.dateCreated = DateTools.stringFromDate(date: dateCreated)
        self.role = (PFUser.current()?["role"] as? [String])?.map({ Role.fromParseString($0) }) ?? [.undefined]
        self.age = object["age"] as? Int
        self.email = email
        self.birthDate = object["birthDate"] as? Date
    }
    
    func updateUser() {
        if let currentUser = PFUser.current() {
            try? self.updateWithPFObject(currentUser)
        }
    }
    
    static func generateQueryWithEmail(_ email: String ) -> PFQuery<PFObject>? {
        let query = PFUser.query()
        query?.whereKey("email", equalTo: email)
        return query
    }
    
    static func generateQueryWithUsername(_ username: String ) -> PFQuery<PFObject>? {
        let query = PFUser.query()
        query?.whereKey("username", equalTo: username)
        return query
    }
    
    static func usernameIsAlreadyTaken(username: String?, completion: @escaping ((_ state: Bool?, _ error: Error? ) -> Void)) {
        guard let username = username else {
            completion(nil, NSError())
            return }
        generateQueryWithUsername(username)?.findObjectsInBackground {(objects: [PFObject]?, error: Error?) in
            guard let objects = objects else { completion(false, nil); return }
            completion(!objects.isEmpty, nil)
        }
    }
    
    static func emailIsAlreadyTaken(email: String?, completion: @escaping ((_ state: Bool?, _ error: Error? ) -> Void)) {
        guard let email = email else { completion(nil,NSError()); return }
        generateQueryWithEmail(email)?.findObjectsInBackground {(objects: [PFObject]?, error: Error?) in
            guard let objects = objects else { completion(false,  nil); return }
            completion(!objects.isEmpty, nil)
        }
    }
    
}

// TODO: change the enum and check CaseIterable
extension User {
    enum Role: CaseIterable {
        case teacher
        case student
        case undefined
        
        var string: String {
            switch self {
            case .teacher: return "Teacher"
            case .student: return "Student"
            case .undefined: return "Undefined"
            }
        }
        
        //static var supportedRoles: [Role] = [.teacher, .student, .undefined]
        //static func fromParseString(_ string: String) -> Role { return supportedRoles.first(where: { $0.string == string }) ?? .undefined }
        static func fromParseString(_ string: String) -> Role { return Role.allCases.first(where: { $0.string == string }) ?? .undefined }
    }
    
//    func fromStringToRole(role: [String]?) -> [Role] {
//        guard let role = role else { return [.undefined] }
//        let convertedRoles: [Role] = role.map {
//            if $0 ==  "Teacher" { return .teacher }
//            else if $0 ==  "Strudent" { return .student }
//            else { return .undefined }
//        }
//        return convertedRoles
//    }
}
