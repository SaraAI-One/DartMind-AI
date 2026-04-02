import SwiftUI

// Note: GameViewModel and CheckoutRecommendationView are in the same Views directory
// Swift Package Manager should automatically include them

struct ScoreboardView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var gameMode: GameMode = .game501

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
                .onChange(of: gameMode) { _, newMode in viewModel.changeGameMode(newMode) }

                HStack {
                    scoreboardCell(player: "Player 1", score: viewModel.gameEngine.player1Score, isCurrent: viewModel.gameEngine.currentPlayer == 1)
                    scoreboardCell(player: "Player 2", score: viewModel.gameEngine.player2Score, isCurrent: viewModel.gameEngine.currentPlayer == 2)
                }
                .padding(.horizontal)

                Text("If you bust, score resets and turn passes.")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Button("Checkout Recommendation") {
                    viewModel.getCheckoutRecommendation()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.canRecommendCheckout())
                .padding(.horizontal)

                scoringGrid

                HStack {
                    Button("Reset") { viewModel.resetGame() }
                        .buttonStyle(.bordered)
                    Spacer()
                    Text("Darts: \(viewModel.gameEngine.dartsThrown % 3)/3")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("Smart Scoreboard")
            .sheet(isPresented: $viewModel.showCheckoutRecommendation) {
                if let recommendation = viewModel.checkoutRecommendation {
                    CheckoutRecommendationView(recommendation: recommendation, isPresented: $viewModel.showCheckoutRecommendation)
                }
            }
            .alert(viewModel.gameOverTitle, isPresented: $viewModel.showGameOverAlert) {
                Button("OK") { viewModel.resetGame() }
            } message: {
                Text("游戏结束，已重置。")
            }
        }
    }

    private var scoringGrid: some View {
        Grid {
            ForEach(0..<4) { row in
                GridRow {
                    ForEach(1..<6) { col in
                        let value = row * 5 + col
                        if value <= 20 {
                            Button("S\(value)") { viewModel.applyThrow(value: value) }
                            .buttonStyle(.borderedProminent)
                            Button("D\(value)") { viewModel.applyThrow(value: value * 2) }
                            .buttonStyle(.borderedProminent)
                            Button("T\(value)") { viewModel.applyThrow(value: value * 3) }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }
            GridRow {
                Button("Bull") { viewModel.applyThrow(value: 25) }.buttonStyle(.borderedProminent)
                Button("Double Bull") { viewModel.applyThrow(value: 50) }.buttonStyle(.borderedProminent)
            }
        }
        .padding(.horizontal)
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
}

struct ScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreboardView()
    }
}
