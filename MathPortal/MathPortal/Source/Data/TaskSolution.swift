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
        item?[Object.ownerId.rawValue] = ownerId
        item?[Object.taskId.rawValue] = taskId
        item?[Object.equations.rawValue] = equations?.map { Equation.equationToJson(equation: $0.expression) }
        item?[Object.owner.rawValue] = PFUser.current()
        return item
    }
    
    override func updateWithPFObject(_ object: PFObject) throws {
        try super.updateWithPFObject(object)
        guard let taskId = object[Object.taskId.rawValue] as? String, let ownerId = object[Object.ownerId.rawValue] as? String, let objectId = object.objectId else {
            throw NSError(domain: "ParseObject", code: 400, userInfo: ["dev_message": "Could not parse TaskSolution data from PFObject"])
        }
        self.ownerId = ownerId
        self.taskId = taskId
        self.equations = (object[Object.equations.rawValue] as? [[String : Any]])?.map { Equation(expression: Equation.JSONToEquation(json: $0))}
        self.objectId = objectId
    }
    
    func updateTaskSolution(solution: PFObject) {
        try? self.updateWithPFObject(solution)
    }
    
    static func generateQueryWithUserId(_ ownerId: String) -> PFQuery<PFObject>? {
        let query = generatePFQuery()
        query.whereKey(Object.ownerId.rawValue, equalTo: ownerId)
        return query
    }
    
    static func generateQueryWithTaskIdAndUserId(_ taskId: String, userId: String) -> PFQuery<PFObject>? {
        let query = generatePFQuery()
        query.whereKey(Object.ownerId.rawValue, equalTo: userId)
        query.whereKey(Object.taskId.rawValue, equalTo: taskId)
        return query
    }
    
    static func generateQueryWithTaskId(_ taskId: String) -> PFQuery<PFObject>? {
        let query = generatePFQuery()
        query.whereKey(Object.taskId.rawValue, equalTo: taskId)
        return query
    }

    static func fechUsersTaskSolutions(userId: String, completion: ((_ objects: [TaskSolution]?, _ error: Error?) -> Void)?) {
        generateQueryWithUserId(userId)?.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            completion?(objects?.compactMap { TaskSolution(pfObject: $0) }, error)
        }
    }
    
    static func fechUsersTaskSolution(_ taskId: String, userId: String, completion: ((_ objects: TaskSolution?, _ error: Error?) -> Void)?) {
        generateQueryWithTaskIdAndUserId(taskId, userId: userId)?.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?)  in
            completion?(TaskSolution(pfObject: objects?.first), error)
        })
    }
    
    static func fechTaskSolutions(_ taskId: String, completion: ((_ objects: [TaskSolution]?, _ error: Error?) -> Void)?) {
        generateQueryWithTaskId(taskId)?.findObjectsInBackground(block: { (_ objects: [PFObject]?, error: Error?) in
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
        var height: CGFloat = 0
        equations?.forEach { height += ($0.expression.generateView().view?.frame.height ?? 0) + 5 }
        return height
    }
}

extension TaskSolution {
    enum Object: String {
        case taskId = "taskId"
        case ownerId = "ownerId"
        case equations = "equations"
        case owner = "owner"
        case objectId
    }
}
