import SwiftUI

struct ScoreboardView: View {
    @State private var gameMode: GameMode = .game501
    @State private var player1Score = 501
    @State private var player2Score = 501
    @State private var currentPlayer = 1
    @State private var showCheckoutRecommendation = false
    @State private var checkoutRecommendation: CheckoutRecommendation?
    @State private var hitRates: [String: Double] = [
        "T20": 0.3,
        "D16": 0.2,
        "Bull": 0.15
    ]
    
    enum GameMode: String, CaseIterable {
        case game501 = "501"
        case game301 = "301"
        case cricket = "Cricket"
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Game Mode", selection: $gameMode) {
                    ForEach(GameMode.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                HStack {
                    VStack {
                        Text("Player 1")
                            .font(.headline)
                        Text("\(player1Score)")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(currentPlayer == 1 ? .dartmind : .gray)
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("Player 2")
                            .font(.headline)
                        Text("\(player2Score)")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(currentPlayer == 2 ? .dartmind : .gray)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Button("Calculate Checkout") {
                    let score = currentPlayer == 1 ? player1Score : player2Score
                    checkoutRecommendation = AICheckoutEngine.calculateCheckout(score: score, hitRates: hitRates)
                    showCheckoutRecommendation = true
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                Grid {
                    ForEach(0..<3) { row in
                        GridRow {
                            ForEach(0..<3) { col in
                                let number = 20 - (row * 3) - col
                                if number > 0 {
                                    Button("\(number)") {
                                        updateScore(number: number)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: 80)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                } else {
                                    Button("Bull") {
                                        updateScore(number: 25)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: 80)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Smart Scoreboard")
            .sheet(isPresented: $showCheckoutRecommendation) {
                if let recommendation = checkoutRecommendation {
                    CheckoutRecommendationView(recommendation: recommendation, isPresented: $showCheckoutRecommendation)
                }
            }
        }
    }
    
    func updateScore(number: Int) {
        if currentPlayer == 1 {
            player1Score = max(0, player1Score - number)
            if player1Score == 0 {
                // Game over
                print("Player 1 wins!")
            }
        } else {
            player2Score = max(0, player2Score - number)
            if player2Score == 0 {
                // Game over
                print("Player 2 wins!")
            }
        }
        currentPlayer = currentPlayer == 1 ? 2 : 1
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
        .frame(width: 300, height: 400)
    }
}

struct ScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreboardView()
    }
}
