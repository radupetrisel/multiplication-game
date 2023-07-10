//
//  Question.swift
//  MultiplicationGame
//
//  Created by Radu Petrisel on 10.07.2023.
//

import Foundation

struct Question {
    let leftOperand: Int
    let rightOperand: Int
    
    var answer: Int {
        leftOperand * rightOperand
    }
}
