//
//  ContentView.swift
//  Shared
//
//  Created by Jeff Terry on 1/3/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var myIntegrator = Integrator(setup: true)
    
    var body: some View {
        VStack{
            HStack{
                VStack{
                    HStack(alignment: .center) {
                        Text("Number of Iterations:")
                            .font(.callout)
                            .bold()
                        TextField("# Iterations", text: $myIntegrator.numberOfIterationsString)
                            //.padding()
                    }.padding(.top)
                    .padding(.leading)
                    
                    HStack(alignment: .center) {
                        Text("Number of Guesses:")
                            .font(.callout)
                            .bold()
                        TextField("#Guesses", text: $myIntegrator.numberOfGuessesString)
                            //.padding()
                    }.padding(.leading)
                    
                    HStack(alignment: .center) {
                        Text("Total Guesses:")
                            .font(.callout)
                            .bold()
                        TextField("Total Guesses", text: $myIntegrator.totalGuessesString)
                           // .padding()
                    }.padding(.leading)
                    
                    HStack(alignment: .center) {
                        Text("Integral:")
                            .font(.callout)
                            .bold()
                        TextField("Integral Value", text: $myIntegrator.integralString)
                            //.padding()
                    }.padding(.leading)
                    
                    HStack(alignment: .center) {
                        Text("Exact:")
                            .font(.callout)
                            .bold()
                        TextField("Exact Value", text: $myIntegrator.exactString)
                           // .padding()
                    }.padding(.leading)
                    
                    HStack(alignment: .center) {
                        Text("logError:")
                            .font(.callout)
                            .bold()
                        TextField("Log Error Value", text: $myIntegrator.logErrorString)
                            //.padding()
                    }.padding(.leading)
                    
                    HStack(alignment: .center) {
                        Text("Time (sec):")
                            .font(.callout)
                            .bold()
                        TextField("time", text: $myIntegrator.timeString)
                           // .padding()
                    }.padding(.leading)
                    
                    
                }
                
                VStack{
                    
                    TextEditor(text: $myIntegrator.outputText)
                        .padding(.top)
                   
                    
                    Toggle(isOn: $myIntegrator.forceEnable) {
                                Text("Force Enable")
                            }
                   // .padding()
                    
                    Toggle(isOn: $myIntegrator.shouldIDisplay) {
                                Text("Enable Display")
                            }
                   // .padding()
                    
                }
        }
        
            Button("Integrate", action: {startTheIntegration()} )
                .disabled(myIntegrator.disableIntegrateButton)
                .padding(.bottom)
            
        }
    }
    
    /// startTheIntegration
    /// This function takes the input from the GUI and starts the threaded calculation.
    func startTheIntegration() {
            
        let guesses = Int(myIntegrator.numberOfGuessesString) ?? 1000
        
        let iterations = Int(myIntegrator.numberOfIterationsString) ?? 10
        
        //Create a Queue for the Calculation
        //We do this here so we can make testing easier. 
        let integrationQueue = DispatchQueue.init(label: "integrationQueue", qos: .userInitiated, attributes: .concurrent)
        
        if !myIntegrator.forceEnable {
            
            myIntegrator.disableIntegrateButton = true
        }
                
            
        myIntegrator.integration(iterations: iterations, guesses: guesses, integrationQueue: integrationQueue )
                
        }
    
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
