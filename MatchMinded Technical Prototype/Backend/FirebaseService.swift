//
//  FirebaseService.swift
//  MatchMinded Technical Prototype
//
//  created by carter manahan on 30/03/2025.
//

import Foundation
import FirebaseFirestore

// this class handles our firestore operations.
// we use it to seed sample data (users & questions) for the prototype.
class FirebaseService {
    static let shared = FirebaseService()
    private let db = Firestore.firestore()
    
    // seeds the 'questions' collection with our sample questions.
    func seedQuestions() {
        for question in SampleData.questions {
            db.collection("questions").document(question.id).setData([
                "prompt": question.prompt,
                "options": question.options
            ]) { error in
                if let error = error {
                    print("❌ error seeding question \(question.id): \(error.localizedDescription)")
                } else {
                    print("✅ successfully seeded question \(question.id)")
                }
            }
        }
    }
    
    // seeds the 'users' collection with our sample users.
    func seedUsers() {
        for user in SampleData.users {
            db.collection("users").document(user.id).setData([
                "name": user.name,
                "mbti": user.mbti,
                "answers": user.answers,
                "location": user.location
            ]) { error in
                if let error = error {
                    print("❌ error seeding user \(user.id): \(error.localizedDescription)")
                } else {
                    print("✅ successfully seeded user \(user.id)")
                }
            }
        }
    }
    
    // seeds both questions and users to firestore.
    func seedData() {
        print("🔄 starting data seeding...")
        seedQuestions()
        seedUsers()
    }
}
