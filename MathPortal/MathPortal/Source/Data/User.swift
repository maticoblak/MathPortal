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
    var age: Int?
    var email: String?
    var profileImage: UIImage?
    
    
    override class var entityName: String { return "User" }
    override init() {
        super.init()
        username = PFUser.current()?.username
        userId = PFUser.current()?.objectId
        tasks = PFUser.current()?["Tasks"] as? [String]
        dateCreated = DateTools.stringFromDate(date: PFUser.current()?.createdAt)
        role = fromStringToRole(role: PFUser.current()?["role"] as? [String] )
        age = PFUser.current()?["age"] as? Int
        email = PFUser.current()?.email
        
    }
    
    override init?(pfObject: PFObject?) {
        super.init(pfObject: pfObject)
    }
    
    override func generetePFObject() -> PFObject? {
        let object = pfObject ?? PFUser.current()
        object?["Tasks"] = tasks == nil ? NSNull() : tasks
        object?["role"] = role.compactMap { $0.string }
        object?["age"] = age == nil ? NSNull() : age
        object?["username"] = username
        object?["email"] = email
        return object
    }
    
    override func updateWithPFObject(_ object: PFObject) throws {
        try super.updateWithPFObject(object)
        guard let username = object["username"] as? String, let userId = object.objectId, let dateCreated = object.createdAt, let email = object["email"] as? String else {
            throw NSError(domain: "ParseObject", code: 400, userInfo: ["dev_message": "Could not parse User data from PFObject"])
        }
        self.username = username
        self.userId = userId
        self.tasks = object["Tasks"] as? [String]
        self.dateCreated = DateTools.stringFromDate(date: dateCreated)
        self.role = fromStringToRole(role: object["role"] as? [String])
        self.age = object["age"] as? Int
        self.email = email
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
    
    static func usernameIsAlreadyTaken(username: String?, compleation: @escaping ((_ state: Bool ) -> Void)) {
        guard let username = username else { return }
        generateQueryWithUsername(username)?.findObjectsInBackground {(objects: [PFObject]?, error: Error?) in
            guard let objects = objects else { compleation(false); return }
            compleation(!objects.isEmpty)
        }
    }
    
    static func emailIsAlreadyTaken(email: String?, compleation: @escaping ((_ state: Bool ) -> Void)) {
        guard let email = email else { return }
        generateQueryWithEmail(email)?.findObjectsInBackground {(objects: [PFObject]?, error: Error?) in
            guard let objects = objects else { compleation(false); return }
            compleation(!objects.isEmpty)
        }
    }
    
}
extension User {
    enum Role {
        case teacher
        case student
        case undefined
        
        var string: String {
            switch self {
            case .teacher: return "Teacher"
            case .student: return "Strudent"
            case .undefined: return "Undefined"
            }
        }
    }
    
    func fromStringToRole(role: [String]?) -> [Role] {
        guard let role = role else { return [.undefined] }
        let convertedRoles: [Role] = role.map {
            if $0 ==  "Teacher" { return .teacher }
            else if $0 ==  "Strudent" { return .student }
            else { return .undefined }
        }
        return convertedRoles
    }
}
