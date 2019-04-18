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
    var objectId: String?
    
    // MARK: Sync
    
    override class var entityName: String { return "Task" }
    
    override func generetePFObject() -> PFObject {
        let item = super.generetePFObject()
        item["taskName"] = name
        item["userId"] = PFUser.current()?.objectId
        return item
    }
    
    override func updateWithPFObject(_ object: PFObject) throws {
        try super.updateWithPFObject(object)
        guard let name = object["taskName"] as? String, let objectId = object.objectId else {
            throw NSError(domain: "ParseObject", code: 400, userInfo: ["dev_message": "Could not parse Task data from PFObject"])
        }
        self.name = name
        self.objectId = objectId
    }
    
    // to get all tasks from user
    static func generateQueryWithUserId() -> PFQuery<PFObject>? {
        let query = generatePFQuery()
        if let userId = PFUser.current()?.objectId {
            query.whereKey("userId", equalTo: userId)
            return query
        } else {
            return nil
        }
    }
    // to get a specific task from user
    static func getObjectsWithObjectId(_ id: String, completion: ((_ object: PFObject?, _ error: Error?) -> Void)?) {
        generatePFQuery().getObjectInBackground(withId: id) { (object, error) in
            completion?(object, error)
        }
    }
    // get all tasks from user
    static func findObjectsByKey(completion: ((_ objects: [PFObject]?, _ error: Error?) -> Void)?) {
        generateQueryWithUserId()?.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            completion?(objects, error)
        }
    }
    // edit the existing task
    func edit(name: String? = nil, otherStuffToEdit: String? = nil, completion: @escaping (() -> Void) )  {
        guard let  taskId = objectId else { return }
        Task.getObjectsWithObjectId(taskId) { (object, error) in
            guard let object = object else { return }
            object["taskName"] = name ?? object["taskName"]
            object.saveInBackground()
            completion()
        }
    }
    
    func delete(completion: @escaping () -> Void) {
        guard let objectId = objectId else { return }
        Task.getObjectsWithObjectId(objectId) { (object, error) in
            //object?.deleteEventually()
            object?.deleteInBackground(block: { (success, error) in
                if success {
                    completion()
                } else {
                    print(error)
                }
            })
            
        }
    }
}
