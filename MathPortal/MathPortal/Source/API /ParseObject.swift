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
    
    class var entityName: String { return "" }
    var entityName: String { return type(of: self).entityName }
    
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
        return PFObject(className: entityName)
    }
    
    func updateWithPFObject(_ object: PFObject) throws {
        
    }
    // have just one querry the others should be in Task
    static func generatePFQuery() -> PFQuery<PFObject> {
        return PFQuery(className: entityName)
    }
    
    func save(completion: ((_ success: Bool, _ error: Error?) -> Void)?) {
        generetePFObject().saveInBackground { (success: Bool, error: Error?) in
            completion?(success, error)
        }
    }
}
