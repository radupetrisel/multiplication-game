//
//  ContentView.swift
//  MultiplicationGame
//
//  Created by Radu Petrisel on 10.07.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var multiplicationTable = 2
    @State private var numberOfQuestions = 5
    
    @State private var questions: [Question] = []
    
    @State private var gameStarted = false
    @State private var currentQuestionIndex = 0
    @State private var currentAnswer = 0
    
    @State private var isShowingNextQuestionAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var isShowingNewGameAlert = false
    
    @State private var score = 0
    
    @FocusState private var isAnswerTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            VStack {
                Stepper("Multiplication table to practice: \(multiplicationTable)", value: $multiplicationTable, in: 2...20)
                    .disabled(gameStarted)
                
                Stepper("Number of questions: \(numberOfQuestions)", value: $numberOfQuestions, in: 5...20, step: 5)
                    .disabled(gameStarted)
            }
            
            HStack {
                Spacer()
                Button("Start") { startGame() }
            }
            
            if gameStarted {
                Section("Type in the correct answer") {
                    Text("\(questions[currentQuestionIndex].leftOperand) x \(questions[currentQuestionIndex].rightOperand)")
                        .font(.largeTitle)
                    
                    
                    TextField("Answer", value: $currentAnswer, format: .number)
                        .focused($isAnswerTextFieldFocused)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                    
                    Button("Check answer", action: checkAnswer)
                }
            }
            
            Spacer()
        }
        .alert(alertTitle, isPresented: $isShowingNextQuestionAlert) {
            Button("Next question!", action: askQuestion)
        } message: {
            Text(alertMessage)
        }
        .alert(alertTitle, isPresented: $isShowingNewGameAlert) {
            Button("New game", action: startNewGame)
        } message: {
            Text(alertMessage)
        }
        .padding()
    }
    
    private func startGame() {
        let multiplicants = (1...20).shuffled()
        
        for index in 0..<numberOfQuestions {
            let question = Question(leftOperand: multiplicationTable, rightOperand: multiplicants[index])
            questions.append(question)
        }
        
        gameStarted = true
    }
    
    private func checkAnswer() {
        alertMessage = ""
        if questions[currentQuestionIndex].answer == currentAnswer {
            alertTitle = "Correct"
            score += 1
        } else {
            alertTitle = "That's not correct."
            alertMessage = "The correct answer is \(questions[currentQuestionIndex].answer)."
        }
        
        let numberOfQuestionsLeft = numberOfQuestions - currentQuestionIndex - 1
        
        switch numberOfQuestionsLeft {
        case 0:
            alertMessage += "\nYou have no more questions left."
        case 1:
            alertMessage += "\nYou have one question left."
        default:
            alertMessage += "\nYou have \(numberOfQuestionsLeft) questions left."
        }
        
        isShowingNextQuestionAlert = true
    }
    
    private func askQuestion() {
        if currentQuestionIndex + 1 == numberOfQuestions {
            alertTitle = "Game over"
            alertMessage = "Final score: \(score)/\(numberOfQuestions)."
            isShowingNewGameAlert = true
        } else {
            currentQuestionIndex += 1
            isAnswerTextFieldFocused = true
        }
    }
    
    private func startNewGame() {
        questions = []
        currentQuestionIndex = 0
        currentAnswer = 0
        gameStarted = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
