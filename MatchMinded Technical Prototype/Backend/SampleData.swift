//
//  SampleData.swift
//  MatchMinded Technical Prototype
//
//  created by carter manahan on 30/03/2025.
//

import Foundation

// represents a user in the app.
struct User: Codable {
    let id: String
    let name: String
    let mbti: String
    let answers: [Int]
    let location: String
}

// represents a quiz question.
struct Question: Codable {
    let id: String
    let prompt: String
    let options: [String]  // likert scale options (1 to 5)
}

// sample data for testing and seeding firestore.
struct SampleData {
    // sample users
    static let users: [User] = [
        User(
            id: "abc123",
            name: "zoë",
            mbti: "infj",
            answers: [4, 5, 2, 3, 4],
            location: "18 miles away"
        ),
        User(
            id: "xyz789",
            name: "mia",
            mbti: "enfj",
            answers: [3, 3, 4, 4, 2],
            location: "12 miles away"
        ),
        User(
            id: "def456",
            name: "hannah",
            mbti: "intj",
            answers: [1, 2, 5, 3, 1],
            location: "9 miles away"
        ),
        User(
            id: "ghi321",
            name: "chloe",
            mbti: "isfp",
            answers: [5, 4, 1, 2, 5],
            location: "22 miles away"
        )
    ]
    
    // sample questions for the quiz (5 questions)
    static let questions: [Question] = [
        Question(
            id: "q1",
            prompt: "my ideal mate loves a good party",
            options: ["never", "rarely", "sometimes", "usually", "always"]
        ),
        Question(
            id: "q2",
            prompt: "my ideal mate enjoys going to museums and cultural events",
            options: ["never", "rarely", "sometimes", "usually", "always"]
        ),
        Question(
            id: "q3",
            prompt: "my ideal mate likes to talk about feelings and emotions",
            options: ["never", "rarely", "sometimes", "usually", "always"]
        ),
        Question(
            id: "q4",
            prompt: "My ideal mate is very logical and analytical",
            options: ["never", "rarely", "sometimes", "usually", "always"]
        ),
        Question(
            id: "q5",
            prompt: "my ideal mate likes to keep to a strict schedule",
            options: ["never", "rarely", "sometimes", "usually", "always"]
        )
    ]
}



// extension to simulate different answers for each sample user per session.
extension User {
    // returns a new user with random answers for the quiz (each between 1 and 5)
    func withRandomisedAnswers() -> User {
        let randomAnswers = (1...5).map { _ in Int.random(in: 1...5) }
        return User(id: id, name: name, mbti: mbti, answers: randomAnswers, location: location)
    }
}
