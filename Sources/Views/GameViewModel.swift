import SwiftUI

class GameViewModel: ObservableObject {
    @Published var gameEngine: GameEngine
    @Published var checkoutRecommendation: CheckoutRecommendation?
    @Published var showCheckoutRecommendation = false
    @Published var showGameOverAlert = false
    @Published var gameOverTitle = ""

    let hitRates: [String: Double] = [
        "T20": 0.3,
        "T19": 0.25,
        "T18": 0.2,
        "D16": 0.2,
        "D20": 0.15,
        "Bull": 0.1
    ]

    init(gameMode: GameMode = .game501) {
        self.gameEngine = GameEngine(gameMode: gameMode)
    }

    func applyThrow(value: Int) {
        let result = gameEngine.applyThrow(value: value)

        switch result {
        case .valid:
            break
        case .bust:
            break
        case .gameOver(let winner):
            gameOverTitle = "Player \(winner) wins!"
            showGameOverAlert = true
        }
    }

    func getCheckoutRecommendation() {
        let score = gameEngine.currentPlayer == 1 ? gameEngine.player1Score : gameEngine.player2Score
        checkoutRecommendation = AICheckoutEngine.calculateCheckout(score: score, hitRates: hitRates)
        showCheckoutRecommendation = true
    }

    func canRecommendCheckout() -> Bool {
        let score = gameEngine.currentPlayer == 1 ? gameEngine.player1Score : gameEngine.player2Score
        return score > 1
    }

    func resetGame() {
        gameEngine.reset()
        showGameOverAlert = false
        checkoutRecommendation = nil
    }

    func changeGameMode(_ mode: GameMode) {
        gameEngine = GameEngine(gameMode: mode)
        resetGame()
    }
}
