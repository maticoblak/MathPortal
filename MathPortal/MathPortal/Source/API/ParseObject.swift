//
//  ParseObject.swift
//  MathPortal
//
//  Created by Petra Čačkov on 17/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
import Parse

class ParseObject {
    
    // EntityName needs to be overridden
    class var entityName: String { return "" }
    var entityName: String { return type(of: self).entityName }
    
    private var pfObject: PFObject?
    
    init() {}
    init?(pfObject: PFObject?) {
        guard let pfObject = pfObject else { return nil }
        do {
            try updateWithPFObject(pfObject)
        } catch {
            if let message = (error as NSError).userInfo["dev_message"] as? String {
                print(message)
            } else {
                print("Unknown error occurd while parsing PFObject")
            }
            return nil
        }
    }

    func generetePFObject() -> PFObject {
        let object = pfObject ?? PFObject(className: entityName)
        return object
    }
    
    func updateWithPFObject(_ object: PFObject) throws {
        pfObject = object
    }

    static func generatePFQuery() -> PFQuery<PFObject> {
        return PFQuery(className: entityName)
    }
    
    func save(completion: ((_ success: Bool, _ error: Error?) -> Void)?) {
        generetePFObject().saveInBackground { (success: Bool, error: Error?) in
            completion?(success, error)
        }
    }
    
    func delete(completion: ((_ success: Bool, _ error: Error?) -> Void)?) {
        generetePFObject().deleteInBackground { (success, error) in
            completion?(success, error)
        }
    }
}
