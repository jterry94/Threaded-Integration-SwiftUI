//
//  Integrator.swift
//  Threaded Integration
//
//  Created by Jeff Terry on 1/3/21.
//

import Foundation
import SwiftUI


class Integrator: NSObject, ObservableObject {
    
    @Published var forceEnable = false
    @Published var shouldIDisplay = false
    @Published var disableIntegrateButton = false
    @Published var numberOfIterationsString = "1"
    @Published var numberOfGuessesString = "1234"
    @Published var totalGuessesString = ""
    @Published var outputText = ""
    @Published var integralString = ""
    
    @Published var iterations = 1
    @Published var guesses = 2
    @Published var start = DispatchTime.now() //Start time
    @Published var stop = DispatchTime.now()  //Stop tim
    //integral e^-x from 0 to 1
    @Published var exact = -exp(-1.0)+exp(0.0)
    @Published var logError = 0.0
    @Published var logErrorString = ""
    @Published var exactString = ""
    @Published var timeString = ""
    
    var integral = 0.0
    
    
    init(setup start: Bool) {
        
        
        //Must call super init before initializing plot
        super.init()
       
        
       }
    
    /// integration
    /// - Parameters:
    ///   - iterations: number of interations (Four will run simultaneously)
    ///   - guesses: number of guesses in each iteration
    ///   - theQueue: DispatchQueue in which we will perform the threaded integration. This can be concurrent or synchrous as needed. Testing usally synchronously. Calculations done concurrently.
    func integration(iterations: Int, guesses: Int, integrationQueue: DispatchQueue){
        
        var integralArray :[Double] = []
        
        start = DispatchTime.now() // starting time of the integration
        
        integrationQueue.async{
            
        
            DispatchQueue.concurrentPerform(iterations: Int(iterations), execute: { index in
                
                if self.shouldIDisplay {
                    DispatchQueue.main.async{
                    
                        //Update Display With Started Queue Thread On the Main Thread
                        self.outputText += "started index \(index)" + "\n"
                          
                    }
                    
                }
                
                integralArray.append(self.calculateMonteCarloIntegral(dimensions: 1, guesses: Int32(guesses), index: index))
                
                
            })
            
            //Calculate the volume of the Bounding Box of the Monte Carlo Integration
            let boundingBox = BoundingBox()
                
            boundingBox.initWithDimensionsAndRanges(dimensions: 1, lowerBound: [0.0], upperBound: [1.0])
            
            let volume = boundingBox.volume
            
            //Create the average value by dividing by the number of guesses
            //Calculate the integral by multiplying by the volume of the bounding box (limits of integration). 
            let integralValue = integralArray.map{$0 * (volume / Double(guesses))}
            
            let myIntegral = integralValue.mean
            self.integral = myIntegral
            
            DispatchQueue.main.async{
                
                //Update Display With Results of Calculation on the Main Thread
                self.disableIntegrateButton = false
                self.integral = myIntegral
                self.integralString = "\(myIntegral)"
                let totalGuesses = Double(guesses)*Double(iterations)
                self.totalGuessesString = "\(totalGuesses)"
                self.exactString = "\(self.exact)"
                self.logError = log10( abs(myIntegral-self.exact)/self.exact)
                self.logErrorString = "\(self.logError)"
                self.stop = DispatchTime.now()    //end time
                let nanotime :UInt64 = self.stop.uptimeNanoseconds - self.start.uptimeNanoseconds //difference in nanoseconds from the start of the calculation until the end.
                let timeInterval = Double(nanotime) / 1_000_000_000
                self.timeString = "\(timeInterval)"
                
            }
            
            
        }
    
        
        
    }
    
    /// calculateMonteCarloIntegral
    /// Calculates the integral of exp(-x) from 0 to 1
    /// - Parameters:
    ///   - dimensions: number of dimensions (here a 1D integral)
    ///   - guesses: number of guesses
    ///   - index: index of thread
    /// - Returns: sum of points (not the integral because it is not averaged or multiplied by box width
    func calculateMonteCarloIntegral(dimensions: Int, guesses: Int32, index: Int) -> Double{
        
        var currentIntegral = 0.0
        
        if dimensions == 1 {
            
            for _ in 0 ..< guesses{
            
                let x = Double.random(in: (0.0 ... 1.0))
                currentIntegral += exp(-x)
                
            }
        }
        else{
            
            print("mismatch in dimensions.")
        }
        
        if shouldIDisplay {
            DispatchQueue.main.async{
            
                //Update Display With Finished Queue Thread On The Main Thread
                self.outputText += "finished index \(index)" + "\n"
                  
            }
            
        }
        
        return(currentIntegral)
        
        
    }
    
    
}

