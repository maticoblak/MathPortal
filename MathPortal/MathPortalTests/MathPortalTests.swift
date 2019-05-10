//
//  MathPortalTests.swift
//  MathPortalTests
//
//  Created by Petra Čačkov on 10/05/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import XCTest

class MathPortalTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // XCTAssert
    func basicEquation() {
        let equation = Equation()
        equation.expression.items.append(Equation.Text("1"))
        equation.expression.items.append(Equation.Operator(.plus))
        equation.expression.items.append(Equation.Text("2"))
        let view = equation.expression.generateView()
        XCTAssert(view != nil, "Could not generate view")
        XCTAssert(view!.bounds.width > 0.0, "View has zero width")
        XCTAssert(view!.bounds.height > 0.0, "View has zero height")
    }

}
