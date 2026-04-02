import Foundation

struct GameEngine {
    private(set) var player1Score: Int
    private(set) var player2Score: Int
    private(set) var currentPlayer: Int = 1
    private(set) var dartsThrown: Int = 0
    let gameMode: GameMode

    init(gameMode: GameMode) {
        self.gameMode = gameMode
        self.player1Score = gameMode.startingScore
        self.player2Score = gameMode.startingScore
    }

    enum ThrowResult {
        case valid
        case bust
        case gameOver(winner: Int)
    }

    mutating func applyThrow(value: Int) -> ThrowResult {
        let score = currentPlayer == 1 ? player1Score : player2Score
        let newScore = score - value

        if gameMode == .cricket {
            updateScore(newScore: newScore)
            return .valid
        }

        if newScore == 0 {
            return .gameOver(winner: currentPlayer)
        } else if newScore < 0 {
            dartsThrown += 1
            switchPlayer()
            return .bust
        }

        updateScore(newScore: newScore)
        return .valid
    }

    private mutating func updateScore(newScore: Int) {
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

    private mutating func switchPlayer() {
        currentPlayer = currentPlayer == 1 ? 2 : 1
    }

    mutating func reset() {
        player1Score = gameMode.startingScore
        player2Score = gameMode.startingScore
        currentPlayer = 1
        dartsThrown = 0
    }
}
