import SwiftUI

struct StatsView: View {
    @State private var playerStats: PlayerStats = PlayerStats()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Personal Stats")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        StatCard(title: "Average", value: "\(String(format: "%.1f", playerStats.average))")
                        StatCard(title: "180s", value: "\(playerStats.hundredEighty)")
                    }
                    
                    HStack {
                        StatCard(title: "Checkouts", value: "\(String(format: "%.1f%%", playerStats.checkoutRate * 100))")
                        StatCard(title: "Win Rate", value: "\(String(format: "%.1f%%", playerStats.winRate * 100))")
                    }
                    
                    Text("Hit Rates")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    ForEach(playerStats.hitRates.sorted(by: { $0.key > $1.key }), id: \.key) {
                        key, value in
                        HStack {
                            Text(key)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(String(format: "%.1f%%", value * 100))")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                    
                    Text("Recent Performance")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    let orderedMatches = playerStats.recentMatches.sorted(by: { $0.date > $1.date })
                    ForEach(orderedMatches, id: \.date) {
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
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
            .navigationTitle("Stats Dashboard")
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.dartmind)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding()
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
