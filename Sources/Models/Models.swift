import Foundation

struct PlayerStats {
    var average: Double = 65.5
    var hundredEighty: Int = 12
    var checkoutRate: Double = 0.45
    var winRate: Double = 0.6
    var hitRates: [String: Double] = [
        "T20": 0.3,
        "T19": 0.25,
        "T18": 0.2,
        "D16": 0.2,
        "D20": 0.15,
        "Bull": 0.1
    ]
    var recentMatches: [Match] = Match.mockData
}

struct Match {
    let id: UUID
    let opponent: String
    let score: Int
    let opponentScore: Int
    let result: Bool
    let date: Date
    let gameMode: String
    
    static var mockData: [Match] {
        [
            Match(id: UUID(), opponent: "John Doe", score: 501, opponentScore: 320, result: true, date: Date().addingTimeInterval(-86400), gameMode: "501"),
            Match(id: UUID(), opponent: "Jane Smith", score: 301, opponentScore: 301, result: false, date: Date().addingTimeInterval(-172800), gameMode: "301"),
            Match(id: UUID(), opponent: "Mike Johnson", score: 5, opponentScore: 3, result: true, date: Date().addingTimeInterval(-259200), gameMode: "Cricket")
        ]
    }
}

struct PlayerProfile {
    var name: String = "Player"
    var email: String = "player@example.com"
    var level: String = "Intermediate"
    var preferredGameMode: String = "501"
    var handedness: String = "Right"
}

struct CheckoutRecommendation {
    let route: String
    let probability: Double
    let explanation: String
}
