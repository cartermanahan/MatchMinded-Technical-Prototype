//
//  MatchResultsView.swift
//  MatchMinded Technical Prototype
//
//  created by carter manahan on 30/03/2025.
//

import SwiftUI

// this view displays the final match results.
// it now shows the user's own calculated mbti type as well as the sorted sample matches.
struct MatchResultsView: View {
    let userMBTI: String  // the user's calculated mbti type
    let matchResults: [(user: User, score: Int, calculatedMBTI: String)]
    let logs: [String]
    
    var body: some View {
        VStack {
            
            // show the user's calculated mbti type
            Text("your MBTI: \(userMBTI)")
            Text("final match results:")
            
            // list the sorted match results
            ForEach(matchResults.indices, id: \.self) { index in
                let result = matchResults[index]
                Text("\(index + 1). \(result.user.name) - MBTI: \(result.calculatedMBTI), compatability score: \(result.score)")
            }
        }
    }
}

struct MatchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        // sample preview data, using "enfj" as the user's mbti for preview
        MatchResultsView(
            userMBTI: "enfj",
            matchResults: [
                (user: SampleData.users[0], score: 95, calculatedMBTI: "enfj"),
                (user: SampleData.users[1], score: 90, calculatedMBTI: "infj")
            ],
            logs: ["log entry 1", "log entry 2"]
        )
    }
}
