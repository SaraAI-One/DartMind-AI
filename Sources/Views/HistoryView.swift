import SwiftUI

struct HistoryView: View {
    @State private var matchHistory: [Match] = Match.mockData
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(matchHistory.reversed(), id: \.id) {
                    match in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(match.opponent)
                                .font(.headline)
                            Spacer()
                            Text(match.result ? "Win" : "Loss")
                                .foregroundColor(match.result ? .green : .red)
                        }
                        Text("\(match.date.formatted(date: .abbreviated, time: .shortened))")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("Score: \(match.score) - \(match.opponentScore)")
                            .font(.caption)
                        Text("Game Mode: \(match.gameMode)")
                            .font(.caption)
                    }
                    .padding()
                }
            }
            .navigationTitle("Match History")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
