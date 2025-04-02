//
//  MatchmakingViewModel.swift
//  MatchMinded Technical Prototype
//
//  Created by carter manahan on 30/03/2025.
//

import Foundation
import Combine

// this viewmodel handles all the logic for the quiz and matchmaking.
// it calculates the user's mbti, randomises sample users answers,
// computes compatibility scores based on a lookup table, and then determines the best matches.
class MatchmakingViewModel: ObservableObject {
    // published properties to update the view
    @Published var currentQuestionIndex: Int = 0          // track which question we're on
    @Published var responses: [Int] = []                  // store user's responses (each between 1 and 5)
    @Published var calculatedMBTI: String = ""            // user's calculated mbti type
    @Published var logs: [String] = []                    // logs for tracking the backend process
    @Published var showAnalyzing: Bool = false            // flag to show the 'analysing...' screen
    // store match results: each sample user with their compatibility score and calculated mbti
    @Published var matchResults: [(user: User, score: Int, calculatedMBTI: String)] = []
    // flag to trigger navigation to the final results view
    @Published var quizFinished: Bool = false
    
    // local variable to hold randomised sample users for this session
    private var randomisedSampleUsers: [User] = []
    
    // initial log when quiz starts
    init() {
        logs.append("quiz started")
    }
    
    // called when a question is answered; store the response and log it
    func answerCurrentQuestion(with value: Int) {
        responses.append(value)
        let logMsg = "answered q\(currentQuestionIndex + 1) with \(value)"
        logs.append(logMsg)
        print(logMsg)
        nextQuestion()
    }
    
    // moves to the next question, if we're done, trigger the analysing phase
    func nextQuestion() {
        if currentQuestionIndex < SampleData.questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            // all questions answered, show 'analysing...' screen for 2 seconds
            showAnalyzing = true
            logs.append("all questions answered, analysing...")
            print("all questions answered, analysing...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.finishQuiz()
            }
        }
    }
    
    // resets the quiz state for a new attempt
    func restartQuiz() {
        currentQuestionIndex = 0
        responses = []
        calculatedMBTI = ""
        logs = []
        showAnalyzing = false
        matchResults = []
        quizFinished = false
        logs.append("quiz reset")
        print("quiz reset")
    }
    
    // finishes the quiz by calculating the user's mbti,
    // randomising each sample user's answers,
    // computing compatibility scores using our table, and sorting the matches.
    func finishQuiz() {
        // calculate the user's mbti type based on their responses
        calculatedMBTI = calculateMBTI(from: responses)
        let userLog = "calculated user mbti: \(calculatedMBTI)"
        logs.append(userLog)
        print(userLog)
        
        // randomise each sample users answers and log each answer
        randomisedSampleUsers = SampleData.users.map { user in
            let randomised = user.withRandomisedAnswers()
            for (index, answer) in randomised.answers.enumerated() {
                let logMsg = "\(user.name) answer for q\(index + 1): \(answer)"
                logs.append(logMsg)
                print(logMsg)
            }
            return randomised
        }
        logs.append("randomised sample users answers")
        print("randomised sample users answers")
        
        // compute compatibility for each sample user using our table based method
        for sample in randomisedSampleUsers {
            let sampleMBTI = calculateMBTI(from: sample.answers)
            let logMBTI = "\(sample.name) calculated mbti: \(sampleMBTI)"
            logs.append(logMBTI)
            print(logMBTI)
            // use our table lookup to get a compatibility score
            let score = compatibilityScoreByTable(userMBTI: calculatedMBTI, otherMBTI: sampleMBTI)
            let logScore = "\(sample.name) compatibility score: \(score)"
            logs.append(logScore)
            print(logScore)
            matchResults.append((user: sample, score: score, calculatedMBTI: sampleMBTI))
        }
        
        // sort match results by score descending so best matches come first
        matchResults.sort { $0.score > $1.score }
        let sortedLog = "sorted match results: \(matchResults.map { "\($0.user.name): \($0.score)" })"
        logs.append(sortedLog)
        print(sortedLog)
        
        // finish quiz: hide analysing screen and trigger navigation to results view
        showAnalyzing = false
        quizFinished = true
    }
    
    // mbti calculator using if/else for each axis:
    // - q1 and q2 average -> first letter: if avg >= 3 then 'E', else 'I'
    // - q3 -> second letter: if response >= 3 then 'N', else 'S'
    // - q4 -> third letter: if response >= 3 then 'F', else 'T'
    // - q5 -> fourth letter: if response >= 3 then 'J', else 'P'
    func calculateMBTI(from answers: [Int]) -> String {
        guard answers.count == SampleData.questions.count else {
            let errorLog = "error: expected \(SampleData.questions.count) answers, got \(answers.count)"
            logs.append(errorLog)
            print(errorLog)
            return "n/a"
        }
        
        // calculate first letter from average of q1 and q2
        let avg = Double(answers[0] + answers[1]) / 2.0
        var firstLetter = ""
        if avg >= 3.0 {
            firstLetter = "E"
            logs.append("first letter: E")
            print("first letter: E")
        } else {
            firstLetter = "I"
            logs.append("first letter: I")
            print("first letter: I")
        }
        
        // determine second letter from q3
        var secondLetter = ""
        if answers[2] >= 3 {
            secondLetter = "N"
            logs.append("second letter: N")
            print("second letter: N")
        } else {
            secondLetter = "S"
            logs.append("second letter: S")
            print("second letter: S")
        }
        
        // determine third letter from q4
        var thirdLetter = ""
        if answers[3] >= 3 {
            thirdLetter = "F"
            logs.append("third letter: F")
            print("third letter: F")
        } else {
            thirdLetter = "T"
            logs.append("third letter: T")
            print("third letter: T")
        }
        
        // determine fourth letter from q5
        var fourthLetter = ""
        if answers[4] >= 3 {
            fourthLetter = "J"
            logs.append("fourth letter: J")
            print("fourth letter: J")
        } else {
            fourthLetter = "P"
            logs.append("fourth letter: P")
            print("fourth letter: P")
        }
        
        let finalType = "\(firstLetter)\(secondLetter)\(thirdLetter)\(fourthLetter)"
        logs.append("final mbti: \(finalType)")
        print("final mbti: \(finalType)")
        return finalType
    }
    
    // calculates a compatibility score based on a lookup table.
    // we define a dictionary mapping each MBTI type to its most compatible types.
    // if the other mbti is in the user's best matches, we return 100; otherwise, 50.
    func compatibilityScoreByTable(userMBTI: String, otherMBTI: String) -> Int {
        let compatibilityTable: [String: [String]] = [
            "INFP": ["ENFJ", "INFJ", "ENFP"],
            "ENFP": ["INTJ", "INFJ", "INFP"],
            "INFJ": ["ENFP", "ENTP", "INFP"],
            "ENFJ": ["INFP", "ISFP", "ENFP"],
            "INTJ": ["ENFP", "ENTP"],
            "ENTJ": ["INFP", "INTP"],
            "INTP": ["ENTJ", "INFP"],
            "ENTP": ["INFJ", "INTJ"],
            "ISFP": ["ESFJ", "ENFJ"]
        ]
        
        var score = 0
        if let bestMatches = compatibilityTable[userMBTI] {
            if bestMatches.contains(otherMBTI) {
                score = 100
            } else {
                score = 50
            }
        } else {
            score = 30  // fallback score if type not in table
        }
        let logMsg = "\(userMBTI) vs \(otherMBTI) => score \(score)"
        logs.append(logMsg)
        print(logMsg)
        return score
    }
}
