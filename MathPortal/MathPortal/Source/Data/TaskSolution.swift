//
//  TaskSolution.swift
//  MathPortal
//
//  Created by Petra Čačkov on 31/08/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
import Parse

class TaskSolution: ParseObject {

    var ownerId: String?
    var taskId: String?
    var objectId: String?
    var equations: [Equation]?
    
    private var ownerObject: PFObject? { return User.pfObjectId(objectId: ownerId)}
    private var taskObject: PFObject? { return Task.pfObjectId(objectId: taskId)}
    
    override class var entityName: String { return "Solution" }
    
    override init() {
        super.init()
    }
    
    convenience init(taskSolution: PFObject) {
        self.init()
        updateTaskSolution(solution: taskSolution)
    }
    
    override init?(pfObject: PFObject?) {
        super.init(pfObject: pfObject)
    }
    
    override func generetePFObject() -> PFObject? {
        let item = super.generetePFObject()
        //item?[Object.ownerId.rawValue] = ownerId
        //item?[Object.taskId.rawValue] = taskId
        item?[Object.equations.rawValue] = equations?.map { Equation.equationToJson(equation: $0.expression) }
        item?[Object.owner.rawValue] = ownerObject
        item?[Object.task.rawValue] = taskObject
        return item
    }
    
    override func updateWithPFObject(_ object: PFObject) throws {
        try super.updateWithPFObject(object)
        guard let objectId = object.objectId else {
            throw NSError(domain: "ParseObject", code: 400, userInfo: ["dev_message": "Could not parse TaskSolution data from PFObject"])
        }
        self.ownerId = (object[Object.owner.rawValue] as? PFObject)?.objectId
        self.taskId = (object[Object.task.rawValue] as? PFObject)?.objectId
        self.equations = (object[Object.equations.rawValue] as? [[String : Any]])?.map { Equation(expression: Equation.JSONToEquation(json: $0))}
        self.objectId = objectId
    }
    
    func updateTaskSolution(solution: PFObject) {
        try? self.updateWithPFObject(solution)
    }
    
    static func generateQueryWithUserId(_ ownerId: String) -> PFQuery<PFObject>? {
        let query = generatePFQuery()
        guard let pfObjectId = User.pfObjectId(objectId: ownerId) else { return nil }
        query.whereKey(Object.owner.rawValue, equalTo: pfObjectId)
        
        return query
    }
    
    
    static func generateQueryWithTaskIdAndUserId(_ taskId: String, userId: String) -> PFQuery<PFObject>? {
        let query = generatePFQuery()
        guard let userObjectId = User.pfObjectId(objectId: userId), let taskObjectId = Task.pfObjectId(objectId: taskId) else { return nil}
        query.whereKey(Object.owner.rawValue, equalTo: userObjectId)
        query.whereKey(Object.task.rawValue, equalTo: taskObjectId)
        return query
    }
    
    static func generateQueryWithTaskId(_ taskId: String) -> PFQuery<PFObject>? {
        let query = generatePFQuery()
        guard let pfObjectId = Task.pfObjectId(objectId: taskId) else { return nil }
        query.whereKey(Object.task.rawValue, equalTo: pfObjectId)
        return query
    }

    static func fechUsersTaskSolutions(userId: String, completion: ((_ objects: [TaskSolution]?, _ error: Error?) -> Void)?) {
        guard let query = generateQueryWithUserId(userId) else {
            completion?(nil, NSError())
            return
        }
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            completion?(objects?.compactMap { TaskSolution(pfObject: $0) }, error)
        }
    }
    
    static func fechUsersTaskSolution(_ taskId: String, userId: String, completion: ((_ objects: TaskSolution?, _ error: Error?) -> Void)?) {
        guard let query = generateQueryWithTaskIdAndUserId(taskId, userId: userId) else {
            completion?(nil, NSError())
            return
        }
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?)  in
            completion?(TaskSolution(pfObject: objects?.first), error)
        })
    }
    
    static func fechTaskSolutions(_ taskId: String, completion: ((_ objects: [TaskSolution]?, _ error: Error?) -> Void)?) {
        guard let query = generateQueryWithTaskId(taskId) else {
            completion?(nil, NSError())
            return
        }
        query.findObjectsInBackground(block: { (_ objects: [PFObject]?, error: Error?) in
            completion?(objects?.compactMap { TaskSolution(pfObject: $0) }, error)
        })
    }
    
    func fetchSolutionOwner(completion: ((_ user: User?, _ Error: Error?) -> Void)?) {
        guard let ownerId = ownerId else { completion?(nil, nil); return }
        User.fetchUserWithUserId(ownerId) { (user, error) in
            completion?(user, error)
        }
    }
    
    func getSolutionViewHeight() -> CGFloat {
        return equations?.reduce(0, { $0 + ($1.expression.generateView().view?.frame.height ?? 0) + 5 }) ?? 0
    }
}

extension TaskSolution {
    enum Object: String {
        case taskId = "taskId"
        //case ownerId = "ownerId"
        case equations = "equations"
        case owner = "owner"
        case objectId
        case task
    }
}
