//
//  Perceptron.swift
//  PerceptronV2
//
//  Created by Martin Nasierowski on 18/11/2019.
//  Copyright © 2019 Martin Nasierowski. All rights ļreserved.
//

import Foundation
import FirebaseDatabase
import Accelerate

private var numberOfPerceptronsLerned = 0

class Perceptron {
        
    private var weights = [Float]()
    private var number: Int
    private var N:Float = 0.1
    private var examples = [Example]()
    
    private struct Pocket {
        var weights = [Float]()
        var lifeTime = 0
    }
        
    init(which number: Int, _ examples:[Example]) {
        self.number = number
        self.examples = examples
        randomWages()
    }
    
    open func learn() {
        var pocketRecord = Pocket()
        pocketRecord.weights = weights
        var lifeTime = 0
        
        for _ in 0...10000 {
            let example_number:Int = Int.random(in:0..<examples.count)
            let example = examples[example_number]
                        
            let correct_answer = example.table[self.number] == 1 ? 1 : -1
            
            let ERR = correct_answer - trashholdFunc(example.table)

            if ERR == 0 {
                 lifeTime += 1
                
                 if lifeTime > pocketRecord.lifeTime {
                    
                     pocketRecord.lifeTime = lifeTime
                     pocketRecord.weights = self.weights
                  
                     if pocketRecord.lifeTime > 1000 { break }
                 }
            } else {
                 let erro = Float(ERR) * N
                
                 for i in 0...2500 {
                    weights[i] += (erro * example.table[i])
                 }
               lifeTime = 0
            }
        }
        self.weights = pocketRecord.weights
        numberOfPerceptronsLerned += 1
        print("Perceptron number:", numberOfPerceptronsLerned)
    }
    
    private func trashholdFunc(_ table:[Float]) -> Int {
        var summary:Float = 0
    
        vDSP_dotpr(weights, 1, table, 1, &summary, vDSP_Length(table.count))
    
        return (summary < 0 ? -1 : 1)
    }
    
    private func randomWages() {
        for _ in 0...2500 {
            weights.append(Float.random(in: -1..<1))
        }
    }
    
    open func checkResult(_ table: [Float]) -> Int {
        if trashholdFunc(table) == 1 {
            return 1
        } else {
            return -1
        }
    }
}
