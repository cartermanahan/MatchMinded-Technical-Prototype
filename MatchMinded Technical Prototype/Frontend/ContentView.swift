//
//  ContentView.swift
//  MatchMinded Technical Prototype
//
//  Created by carter manahan on 30/03/2025.
//

import SwiftUI

// this is the home screen where the user can start the quiz or seed data to firestore.

struct ContentView: View {
    @StateObject private var viewModel = MatchmakingViewModel()

    var body: some View {
        VStack {
            // link to start the quiz
            NavigationLink(destination: QuizView()) {
                Text("start quiz")
            }
            
            // button to seed data to firestore
            Button(action: {
                FirebaseService.shared.seedData()
            }) {
                Text("seed data to firestore")
            }
        }
        .toolbar {
            // full reset button in the navigation bar trailing

            ToolbarItem(placement: .navigationBarTrailing) {
                Button("reset") {
                    viewModel.restartQuiz()
                    print("full reset pressed, resetting all app state")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
