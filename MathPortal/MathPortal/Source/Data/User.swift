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
    
    override class var entityName: String { return "User" }
    override init() {
        super.init()
        username = PFUser.current()?.username
        userId = PFUser.current()?.objectId
        tasks = PFUser.current()?[Object.tasks.rawValue] as? [String]
        dateCreated = DateTools.stringFromDate(date: PFUser.current()?.createdAt)
        role = (PFUser.current()?[Object.role.rawValue] as? [String])?.map({ Role.fromParseString($0) }) ?? [.undefined]
        age = PFUser.current()?[Object.age.rawValue] as? Int
        email = PFUser.current()?.email
        birthDate = PFUser.current()?[Object.birthDate.rawValue] as? Date
        
    }
    
    override init?(pfObject: PFObject?) {
        super.init(pfObject: pfObject)
    }
    
    override func generetePFObject() -> PFObject? {
        let object = pfObject ?? PFUser.current()
        object?[Object.tasks.rawValue] = tasks == nil ? NSNull() : tasks
        object?[Object.role.rawValue] = role.compactMap { $0.string }
        object?[Object.age.rawValue] = age == nil ? NSNull() : age
        object?[Object.username.rawValue] = username
        object?[Object.email.rawValue] = email
        object?[Object.birthDate.rawValue] = birthDate == nil ? NSNull() : birthDate
        return object
    }
    
    override func updateWithPFObject(_ object: PFObject) throws {
        try super.updateWithPFObject(object)
        guard let username = object[Object.username.rawValue] as? String, let userId = object.objectId, let dateCreated = object.createdAt, let email = object[Object.email.rawValue] as? String else {
            throw NSError(domain: "ParseObject", code: 400, userInfo: ["dev_message": "Could not parse User data from PFObject"])
        }
        self.username = username
        self.userId = userId
        self.tasks = object[Object.tasks.rawValue] as? [String]
        self.dateCreated = DateTools.stringFromDate(date: dateCreated)
        self.role = (PFUser.current()?[Object.role.rawValue] as? [String])?.map({ Role.fromParseString($0) }) ?? [.undefined]
        self.age = object[Object.age.rawValue] as? Int
        self.email = email
        self.birthDate = object[Object.birthDate.rawValue] as? Date
    }
    
    func updateUser() {
        if let currentUser = PFUser.current() {
            try? self.updateWithPFObject(currentUser)
        }
    }
    
    static func generateQueryWithEmail(_ email: String ) -> PFQuery<PFObject>? {
        let query = PFUser.query()
        query?.whereKey(Object.email.rawValue, equalTo: email)
        return query
    }
    
    static func generateQueryWithUsername(_ username: String ) -> PFQuery<PFObject>? {
        let query = PFUser.query()
        query?.whereKey(Object.username.rawValue, equalTo: username)
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
    func logOut() {
        PFUser.logOut()
    }
}

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
        static func fromParseString(_ string: String) -> Role { return Role.allCases.first(where: { $0.string == string }) ?? .undefined }
    }

}
extension User {
    enum Object: String {
        case tasks = "taskes"
        case role = "role"
        case age = "age"
        case profileImage  = "image"
        case birthDate = "birthDate"
        case username = "username"
        case email = "email"
        
    }
}
