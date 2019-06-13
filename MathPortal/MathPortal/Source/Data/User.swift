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
    
    
    override class var entityName: String { return "User" }
    override init() {
        super.init()
        username = PFUser.current()?.username
        userId = PFUser.current()?.objectId
        tasks = PFUser.current()?["TasksNames"] as? [String] ?? [String]()
        
    }
    
    override init?(pfObject: PFObject?) {
        super.init(pfObject: pfObject)
    }
    
    override func generetePFObject() -> PFObject? {
        let object = pfObject ?? PFUser.current()
        object?["Tasks"] = tasks
        return object
    }
    
    override func updateWithPFObject(_ object: PFObject) throws {
        try super.updateWithPFObject(object)
        guard let username = object["username"] as? String, let userId = object["objectId"] as? String, let tasks = object["TasksNames"] as? [String] else {
            throw NSError(domain: "ParseObject", code: 400, userInfo: ["dev_message": "Could not parse User data from PFObject"])
        }
        self.username = username
        self.userId = userId
        self.tasks = tasks
    }
    
}
