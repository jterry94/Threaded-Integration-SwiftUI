//
//  Tests_macOS.swift
//  Tests macOS
//
//  Created by Jeff Terry on 1/3/21.
//

import XCTest
import Foundation
import SwiftUI


class Tests_macOS: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testVolume(){
            
            let myVolumeBox = BoundingBox()
            
            let dimensions = 5
            
            let lowerBound = [0.0, -2.0, 3.0, 4.0, 1.0]
            let upperBound = lowerBound.map{($0 + 2.0)}
            
            myVolumeBox.initWithDimensionsAndRanges(dimensions: dimensions, lowerBound: lowerBound, upperBound: upperBound)
            
            XCTAssertEqual(myVolumeBox.volume, pow(2.0, Double(dimensions)), accuracy: 1E-7, "Print does not match" )
            
            
        }
    
    func testIntegrationOfEToTheMinusX() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var testValue = 3.14159
        
        let integrator = Integrator(setup: true)
        
        let myQueue = DispatchQueue(label:"etotheminusxTest")
        
        integrator.exact = -exp(-1.0) + exp(0.0)
        
        myQueue.sync{
            
            integrator.integration(iterations: 16, guesses: 32000, integrationQueue: myQueue)
            
            
        }
        
        myQueue.sync{
            
            testValue = integrator.integral
            
            print ("The Test \(testValue)")
            
        }
        
        
        XCTAssertEqual(testValue, integrator.exact, accuracy: 1.5e-3, "Print it should have been closer.")
        
        
    
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
