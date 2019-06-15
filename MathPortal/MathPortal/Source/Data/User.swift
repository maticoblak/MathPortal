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
    var role: [Role]?
    var age: Int?
    var email: String?
    var image: UIImage?
    
    
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
        object?["role"] = role?.compactMap { $0.string }
        object?["age"] = age == nil ? NSNull() : age
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
