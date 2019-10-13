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
    var email: String?
    var profileImage: UIImage?
    var birthDate: Date?
    
    
    override class var entityName: String { return "User" }
    override init() {
        super.init()
    }
    convenience init(user: PFUser) {
        self.init()
        updateUser(user: user)
    }
    
    override init?(pfObject: PFObject?) {
        super.init(pfObject: pfObject)
    }
    override func generetePFObject() -> PFObject? {
        let object = pfObject ?? PFUser.current()
        object?[Object.tasks.rawValue] = tasks == nil ? NSNull() : tasks
        object?[Object.role.rawValue] = role.compactMap { $0.string }
        object?[Object.username.rawValue] = username
        object?[Object.email.rawValue] = email
        object?[Object.birthDate.rawValue] = birthDate == nil ? NSNull() : birthDate
        if let profileImageData = profileImage?.jpegData(compressionQuality: 0.5) { object?[Object.profileImage.rawValue] = PFFileObject(data: profileImageData)}
        return object
    }
    
    override func updateWithPFObject(_ object: PFObject) throws {
        try super.updateWithPFObject(object)
        guard let username = object[Object.username.rawValue] as? String, let userId = object.objectId, let dateCreated = object.createdAt else {
            throw NSError(domain: "ParseObject", code: 400, userInfo: ["dev_message": "Could not parse User data from PFObject"])
        }
        self.username = username
        self.userId = userId
        self.tasks = object[Object.tasks.rawValue] as? [String]
        self.dateCreated = DateTools.stringFromDate(date: dateCreated)
        self.role = (PFUser.current()?[Object.role.rawValue] as? [String])?.map({ Role.fromParseString($0) }) ?? [.undefined]
        //NOTE: Can't guard email since the return value is nil if the user fetching that user is not the same or admin.
        self.email = object[Object.email.rawValue] as? String
        self.birthDate = object[Object.birthDate.rawValue] as? Date
        // TODO: Fix : Warning: A long-running operation is being executed on the main thread. - It happenes when saving images )the problem is image.getdata
        if let image = object[Object.profileImage.rawValue] as? PFFileObject, let imageData = try? image.getData() {
            profileImage = UIImage(data:imageData)
        }
    }

    func updateUser(user: PFUser) {
        try? self.updateWithPFObject(user)
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
    
    static func generateUserQuery() -> PFQuery<PFObject>? {
        let query = PFUser.query()
        return query
    }
    
    static func fetchUserWithUserId(_ userId: String, completion: ((_ object: User?, _ error: Error?) -> Void)?)  {
        guard let query = generateUserQuery() else {
            completion?(nil, NSError())
            return
        }
        query.getObjectInBackground(withId: userId, block: { (_ object: PFObject?, _ error: Error?) in
            completion?(User(pfObject: object), error)
        })
    }
    
    static func usernameIsAlreadyTaken(username: String?, completion: @escaping ((_ state: Bool?, _ error: Error? ) -> Void)) {
        guard let username = username, let query = generateQueryWithUsername(username) else {
            completion(nil, NSError())
            return }
        query.findObjectsInBackground {(objects: [PFObject]?, error: Error?) in
            guard let objects = objects else { completion(false, nil); return }
            completion(!objects.isEmpty, nil)
        }
    }
    
    static func emailIsAlreadyTaken(email: String?, completion: @escaping ((_ state: Bool?, _ error: Error? ) -> Void)) {
        guard let email = email, let query = generateQueryWithEmail(email) else {
            completion(nil, NSError())
            return
        }
        query.findObjectsInBackground {(objects: [PFObject]?, error: Error?) in
            guard let objects = objects else { completion(false,  nil); return }
            completion(!objects.isEmpty, nil)
        }
    }
    
    static func logOut(_ completion: ((_ error: Error?) -> Void)? = nil) {
        PFUser.logOutInBackground { error in
            currentLoadedUser = nil
            completion?(error)
        }
    }
    
    static func logIn(username: String, password: String, _ completion: ((_ user: PFUser?, _ error: Error?) -> Void)? = nil) {
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            completion?(user, error)
        }
    }
    
    static func signUpUser(username: String, password: String, email: String,  _ completion: ((_ user: Bool?, _ error: Error?) -> Void)? = nil)  {
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        user.signUpInBackground { (success, error) in
            completion?(success, error)
        }
    }
    
    
    func fetchTasks(completion: ((_ objects: [Task]?, _ error: Error?) -> Void)?) {
        guard let id = userId else {
            completion?(nil, NSError(domain: "Internal - User", code: 404, userInfo: ["dev_info": "No logged in user"]))
            return
        }
        Task.fetchTasksWith(userId: id) { (tasks, error) in
            self.tasks = tasks?.compactMap { $0.name }
            completion?(tasks, error)
        }
        
    }
// MARK: - Relation to Task
    
    func fetchSavedTasks(completion: ((_ objects: [Task]?, _ error: Error?) -> Void)?) {
        let currentUser = PFUser.current()
        let relation = currentUser?.relation(forKey: "savedTasks")
        guard let query = relation?.query() else {
            completion?(nil, NSError())
            return
        }
        query.findObjectsInBackground(block: { (items, error) in
            completion?(items?.compactMap { Task(pfObject: $0)}, error)
        })
    }

    func addToSavedTasks(_ task: Task) {
        let relation = PFUser.current()?.relation(forKey: "savedTasks")
        let taskObject = task.generetePFObject()
        if let taskObject = taskObject {
            relation?.add(taskObject)
        }
    }
}

// MARK: - Current User

extension User {
    private static var currentLoadedUser: User? {
        didSet {
            if currentLoadedUser == nil && oldValue != nil {
                LaunchLogoViewController.current?.dismissToRoot()
            }
        }
    }
    
    static var current: User? {
        guard let currentUser = PFUser.current() else {
            currentLoadedUser = nil
            return nil
        }
        
        if let currentLoadedUser = currentLoadedUser, currentLoadedUser.userId == currentUser.objectId {
            return currentLoadedUser
        } else {
            let user = User(user: currentUser)
            currentLoadedUser = user
            return user
        }
    }
    
    static func fetchCurrent() -> User {
        guard let user = User.current else {
            
            return User()
        }
        return user
    }
    
}

// MARK: - Role

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

// MARK: - Objct

extension User {
    enum Object: String {
        case tasks = "tasks"
        case role = "role"
        case profileImage  = "profileImage"
        case birthDate = "birthDate"
        case username = "username"
        case email = "email"
        case tasksOwned = "tasksOwned"
        case userId = "userId"
    }
}
