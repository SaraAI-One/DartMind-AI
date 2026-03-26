import SwiftUI

struct ScoreboardView: View {
    @State private var gameMode: GameMode = .game501
    @State private var player1Score = 501
    @State private var player2Score = 501
    @State private var currentPlayer = 1
    @State private var dartsThrown = 0
    @State private var showCheckoutRecommendation = false
    @State private var checkoutRecommendation: CheckoutRecommendation?
    @State private var hitRates: [String: Double] = [
        "T20": 0.3,
        "T19": 0.25,
        "T18": 0.2,
        "D16": 0.2,
        "D20": 0.15,
        "Bull": 0.1
    ]
    @State private var showGameOverAlert = false
    @State private var gameOverTitle = ""

    enum GameMode: String, CaseIterable {
        case game501 = "501"
        case game301 = "301"
        case cricket = "Cricket"

        var startingScore: Int {
            switch self {
            case .game501: return 501
            case .game301: return 301
            case .cricket: return 0
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Picker("Game Mode", selection: $gameMode) {
                    ForEach(GameMode.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .onChange(of: gameMode) { _ in resetGame() }

                HStack {
                    scoreboardCell(player: "Player 1", score: player1Score, isCurrent: currentPlayer == 1)
                    scoreboardCell(player: "Player 2", score: player2Score, isCurrent: currentPlayer == 2)
                }
                .padding(.horizontal)

                Text("If you bust, score resets and turn passes.")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Button("Checkout Recommendation") {
                    let score = currentPlayer == 1 ? player1Score : player2Score
                    checkoutRecommendation = AICheckoutEngine.calculateCheckout(score: score, hitRates: hitRates)
                    showCheckoutRecommendation = true
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canRecommendCheckout)
                .padding(.horizontal)

                scoringGrid

                HStack {
                    Button("Reset") { resetGame() }
                        .buttonStyle(.bordered)
                    Spacer()
                    Text("Darts: \(dartsThrown % 3)/3")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("Smart Scoreboard")
            .sheet(isPresented: $showCheckoutRecommendation) {
                if let recommendation = checkoutRecommendation {
                    CheckoutRecommendationView(recommendation: recommendation, isPresented: $showCheckoutRecommendation)
                }
            }
            .alert(gameOverTitle, isPresented: $showGameOverAlert) {
                Button("OK") { resetGame() }
            } message: {
                Text("游戏结束，已重置。")
            }
        }
    }

    private var canRecommendCheckout: Bool {
        let score = currentPlayer == 1 ? player1Score : player2Score
        return score > 1
    }

    private var scoringGrid: some View {
        Grid {
            ForEach(0..<4) { row in
                GridRow {
                    ForEach(1..<6) { col in
                        let value = row * 5 + col
                        if value <= 20 {
                            Button("S\(value)") { applyThrow(value: value) }
                                .buttonStyle(scoreCellStyle)
                            Button("D\(value)") { applyThrow(value: value * 2) }
                                .buttonStyle(scoreCellStyle)
                            Button("T\(value)") { applyThrow(value: value * 3) }
                                .buttonStyle(scoreCellStyle)
                        }
                    }
                }
            }
            GridRow {
                Button("Bull") { applyThrow(value: 25) }.buttonStyle(scoreCellStyle)
                Button("Double Bull") { applyThrow(value: 50) }.buttonStyle(scoreCellStyle)
            }
        }
        .padding(.horizontal)
    }

    private var scoreCellStyle: some ButtonStyle {
        .borderedProminent
    }

    private func scoreboardCell(player: String, score: Int, isCurrent: Bool) -> some View {
        VStack {
            Text(player).font(.headline)
            Text("\(score)").font(.system(size: 48, weight: .bold)).foregroundColor(isCurrent ? .dartmind : .gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(isCurrent ? Color.dartmind.opacity(0.1) : Color.gray.opacity(0.05))
        .cornerRadius(12)
    }

    private func applyThrow(value: Int) {
        guard !showGameOverAlert else { return }

        let score = currentPlayer == 1 ? player1Score : player2Score
        let newScore = score - value

        if gameMode == .cricket {
            // 简化：Cricket 只用减分模拟，不做详细命中规则
            updateScoreForPlayer(newScore: newScore)
            return
        }

        if newScore == 0 {
            gameOverTitle = "Player \(currentPlayer) wins!"
            showGameOverAlert = true
            return
        } else if newScore < 0 {
            // bust: 本轮不记分，换人
            dartsThrown += 1
            switchPlayer()
            return
        }

        updateScoreForPlayer(newScore: newScore)
    }

    private func updateScoreForPlayer(newScore: Int) {
        if currentPlayer == 1 {
            player1Score = newScore
        } else {
            player2Score = newScore
        }

        dartsThrown += 1

        if dartsThrown % 3 == 0 {
            switchPlayer()
        }
    }

    private func switchPlayer() {
        currentPlayer = currentPlayer == 1 ? 2 : 1
    }

    private func resetGame() {
        player1Score = gameMode.startingScore
        player2Score = gameMode.startingScore
        currentPlayer = 1
        dartsThrown = 0
        showGameOverAlert = false
        checkoutRecommendation = nil
    }
}

struct CheckoutRecommendationView: View {
    let recommendation: CheckoutRecommendation
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Text("AI Checkout Recommendation")
                .font(.headline)
                .padding()

            Text("Best Route: \(recommendation.route)")
                .padding()

            Text("Success Probability: \(String(format: "%.1f%%", recommendation.probability * 100))")
                .padding()

            Text("Explanation: \(recommendation.explanation)")
                .padding()

            Button("Close") {
                isPresented = false
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .frame(width: 330, height: 470)
    }
}

struct ScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreboardView()
    var body: some View {
        VStack {
            Text("AI Checkout Recommendation")
                .font(.headline)
                .padding()
            
            Text("Best Route: \(recommendation.route)")
                .padding()
            
            Text("Success Probability: \(String(format: "%.1f%%", recommendation.probability * 100))")
                .padding()
            
            Text("Explanation: \(recommendation.explanation)")
                .padding()
            
            Button("Close") {
                isPresented = false
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .frame(width: 300, height: 400)
    }
}

struct ScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreboardView()
    }
}
