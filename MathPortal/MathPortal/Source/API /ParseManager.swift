//
//  ParseManager.swift
//  MathPortal
//
//  Created by Petra Čačkov on 15/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
import Parse

class ParseManager {
    
    static let configuration = ParseClientConfiguration {
        $0.applicationId = "Rq3siDnQ14EpAWKkRVTRvRTIvbtjq5jlgOf9SyK7"
        $0.clientKey = "s6z7lVKokNP1Eo3TbnWmFkcGpQOqf0bGCZqMMyeB"
        $0.server = "https://parseapi.back4app.com"
    }
}
