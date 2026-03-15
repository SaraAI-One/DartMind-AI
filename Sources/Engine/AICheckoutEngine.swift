import Foundation

struct AICheckoutEngine {
    static func calculateCheckout(score: Int, hitRates: [String: Double]) -> CheckoutRecommendation {
        // 简单的结账路线计算逻辑
        if score == 170 {
            return CheckoutRecommendation(
                route: "T20, T20, Bull",
                probability: calculateProbability(route: ["T20", "T20", "Bull"], hitRates: hitRates),
                explanation: "Maximum checkout. Requires three perfect darts."
            )
        } else if score == 167 {
            return CheckoutRecommendation(
                route: "T20, T19, Bull",
                probability: calculateProbability(route: ["T20", "T19", "Bull"], hitRates: hitRates),
                explanation: "High checkout with bullseye finish."
            )
        } else if score == 164 {
            return CheckoutRecommendation(
                route: "T20, T18, Bull",
                probability: calculateProbability(route: ["T20", "T18", "Bull"], hitRates: hitRates),
                explanation: "Consistent checkout with bullseye finish."
            )
        } else if score <= 100 {
            return CheckoutRecommendation(
                route: "D16",
                probability: hitRates["D16"] ?? 0.2,
                explanation: "Standard double 16 finish."
            )
        } else {
            return CheckoutRecommendation(
                route: "T20, T20, D16",
                probability: calculateProbability(route: ["T20", "T20", "D16"], hitRates: hitRates),
                explanation: "Standard route for most scores."
            )
        }
    }
    
    private static func calculateProbability(route: [String], hitRates: [String: Double]) -> Double {
        var probability = 1.0
        for target in route {
            probability *= hitRates[target] ?? 0.2
        }
        return probability
    }
}
