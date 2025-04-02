//
//  QuizView.swift
//  MatchMinded Technical Prototype
//
//  created by carter manahan on 30/03/2025.
//

import SwiftUI

// this view displays the quiz and uses the matchmaking viewmodel for logic.
// it shows questions, handles button presses, displays an analysing screen,
// and then automatically navigates to the final results view (which lists the girls ordered by compatibility).
struct QuizView: View {
    @StateObject private var viewModel = MatchmakingViewModel()
    
    var body: some View {
        VStack {
            if viewModel.showAnalyzing {
                // analysing screen: shows 'analysing...' text and logs
                Text("analysing...")
                Text(viewModel.logs.joined(separator: "\n"))
                    .multilineTextAlignment(.leading)
            } else if viewModel.currentQuestionIndex < SampleData.questions.count {
                // quiz in progress: show current question and answer buttons
                let question = SampleData.questions[viewModel.currentQuestionIndex]
                Text(question.prompt)
                HStack {
                    ForEach(1...5, id: \.self) { value in
                        Button("\(value)") {
                            viewModel.answerCurrentQuestion(with: value)
                        }
                    }
                }
            } else {
                // quiz complete screen (before navigation) – can display a simple message
                Text("quiz complete")
            }
            
            // hidden navigation link that triggers when quizFinished is true,
            // passing the user's calculated mbti, match results and logs
            NavigationLink(
                destination: MatchResultsView(userMBTI: viewModel.calculatedMBTI,
                                               matchResults: viewModel.matchResults,
                                               logs: viewModel.logs),
                isActive: $viewModel.quizFinished,
                label: { EmptyView() }
            )
        }
        .onAppear {
            viewModel.logs = []
        }
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            QuizView()
        }
    }
}
