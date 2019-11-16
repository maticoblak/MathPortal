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
    var ownerId: String?
    var equations: [Equation]?
    var objectId: String = ""
    var updatedAt: Date?
    
    private var ownerObject: PFObject? { return User.withId(ownerId)}

    
    // MARK: Sync
    
    override init() {
        super.init()
    }
    override init?(pfObject: PFObject?) {
        super.init(pfObject: pfObject)
    }
    
    override class var entityName: String { return "Task" }
    
    override func generetePFObject() -> PFObject? {
        let item = super.generetePFObject()
        item?[Object.name.rawValue] = name
        item?[Object.owner.rawValue] = ownerObject
        item?[Object.equations.rawValue] = equations?.map { Equation.equationToJson(equation: $0.expression) }
        return item
    }
    
    override func updateWithPFObject(_ object: PFObject) throws {
        try super.updateWithPFObject(object)
        guard let name = object[Object.name.rawValue] as? String, let objectId = object.objectId else {
            throw NSError(domain: "ParseObject", code: 400, userInfo: ["dev_message": "Could not parse Task data from PFObject"])
        }
        self.name = name
        self.ownerId = (object[Object.owner.rawValue] as? PFObject)?.objectId
        self.equations = (object[Object.equations.rawValue] as? [[String : Any]])?.map { Equation(expression: Equation.JSONToEquation(json: $0 )) }
        self.objectId = objectId
        self.updatedAt = object.updatedAt
        
    }
    
    static func generateQueryWithUserId(_ userId: String) -> PFQuery<PFObject>? {
        let query = generatePFQuery()
        guard let userPfObjectId = User.withId(userId) else { return nil }
        query.whereKey(Object.owner.rawValue, equalTo: userPfObjectId)
        return query
    }
    
    static func generateQueryContainingObjectIds(_ objectIds: [String]) -> PFQuery<PFObject>? {
        let query = generatePFQuery()
        query.whereKey(Object.objectId.rawValue, containedIn: objectIds)
        return query
    }
    
    static func fetchTasksWith(userId: String, completion: ((_ objects: [Task]?, _ error: Error?) -> Void)?) {
        guard let query = generateQueryWithUserId(userId) else {
            completion?(nil, NSError())
            return
        }
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            completion?(objects?.compactMap {Task(pfObject: $0) }, error)
        }
    }
    
    static func fetchTasksWith(objectIds: [String], completion: ((_ objects: [Task]?, _ error: Error?) -> Void)?) {
        guard let query = generateQueryContainingObjectIds(objectIds) else {
            completion?(nil, NSError())
            return
        }
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            completion?(objects?.compactMap {Task(pfObject: $0) }, error)
        }
    }
    
    static func fetchAllTasks(completion:  ((_ objects: [Task]?, _ Error: Error?) -> Void)?) {
        let query = generatePFQuery()
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            completion?(objects?.compactMap {Task(pfObject: $0)}, error)
        }
    }
    
    func fetchSolutions(completion:  ((_ objects: [TaskSolution]?, _ Error: Error?) -> Void)?) {
        TaskSolution.fetchTaskSolutions(self.objectId) { (solutions, error) in
            completion?(solutions,error)
        }
    }
    
    func viewHeight() -> CGFloat {
        return equations?.reduce(0, { $0 + ($1.viewBounds().height ?? 0) + 5 }) ?? 0
    }
    
}

extension Task {
    enum Object: String {
        case name = "taskName"
        case equations = "equations"
        case objectId = "objectId"
        case owner
    }
}
