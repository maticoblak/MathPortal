//
//  Task.swift
//  MathPortal
//
//  Created by Petra Čačkov on 17/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
import Parse

class Task: ParseObject {

    var name: String?
    var userId: String?
    
    // MARK: Sync
    
    override init() {
        super.init()
        userId = PFUser.current()?.objectId
    }
    override init?(pfObject: PFObject?) {
        super.init(pfObject: pfObject)
    }
    
    override class var entityName: String { return "Task" }
    
    override func generetePFObject() -> PFObject? {
        let item = super.generetePFObject()
        item?["taskName"] = name
        item?["userId"] = userId
        return item
    }
    
    override func updateWithPFObject(_ object: PFObject) throws {
        try super.updateWithPFObject(object)
        guard let name = object["taskName"] as? String, let userId = object["userId"] as? String else {
            throw NSError(domain: "ParseObject", code: 400, userInfo: ["dev_message": "Could not parse Task data from PFObject"])
        }
        self.name = name
        self.userId = userId
    }
    
    static func generateQueryWithUserId(_ userId: String) -> PFQuery<PFObject>? {
        let query = generatePFQuery()
        query.whereKey("userId", equalTo: userId)
        return query
    }
    static func fetchUserTasks(userId: String, completion: ((_ objects: [Task]?, _ error: Error?) -> Void)?) {
        generateQueryWithUserId(userId)?.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            completion?(objects?.compactMap {Task(pfObject: $0) }, error)
        }
    }
}
