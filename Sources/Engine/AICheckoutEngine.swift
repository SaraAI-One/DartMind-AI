import Foundation

struct AICheckoutEngine {
    private static let defaultHitRate = 0.2

    private static let checkoutTable: [Int: [String]] = [
        170: ["T20", "T20", "Bull"],
        167: ["T20", "T19", "Bull"],
        164: ["T20", "T18", "Bull"],
        161: ["T20", "T17", "Bull"],
        160: ["T20", "T20", "D20"],
        158: ["T20", "T20", "D19"],
        156: ["T20", "T20", "D18"],
        154: ["T20", "T20", "D17"],
        152: ["T20", "T20", "D16"],
        150: ["T20", "T20", "D15"],
        140: ["T20", "T20", "D10"],
        100: ["T20", "D20"],
        80: ["T20", "D20"],
        64: ["T16", "D16"],
        32: ["D16"]
    ]

    static func calculateCheckout(score: Int, hitRates: [String: Double]) -> CheckoutRecommendation {
        guard score > 1 else {
            return CheckoutRecommendation(route: "N/A", probability: 0.0, explanation: "Score is too low for checkout.")
        }

        if score > 170 {
            let route = "No checkout in one visit. Aim for 160+ setup."
            return CheckoutRecommendation(route: route, probability: 0.0, explanation: "Score above maximum checkout range; reduce score first.")
        }

        if let route = checkoutTable[score] {
            let probability = calculateProbability(route: route, hitRates: hitRates)
            return CheckoutRecommendation(route: route.joined(separator: ", "), probability: probability, explanation: "Optimal checkout route from table.")
        }

        if score <= 100 {
            if score % 2 == 0, score / 2 <= 20 {
                let target = "D\(score / 2)"
                let probability = hitRates[target] ?? defaultHitRate
                return CheckoutRecommendation(route: target, probability: probability, explanation: "Direct double finish.")
            }

            if score == 25 {
                let target = "Bull"
                return CheckoutRecommendation(route: target, probability: hitRates[target] ?? defaultHitRate, explanation: "Single bull finish.")
            }
        }

        // 默认推荐，适合大多数对手
        let fallbackRoute = ["T20", "T20", "D16"]
        let probability = calculateProbability(route: fallbackRoute, hitRates: hitRates)
        return CheckoutRecommendation(route: fallbackRoute.joined(separator: ", "), probability: probability, explanation: "Fallback route for non-standard checkout.")
    }

    private static func calculateProbability(route: [String], hitRates: [String: Double]) -> Double {
        let probability = route.reduce(1.0) { current, target in
            current * (hitRates[target] ?? defaultHitRate)
        }
        return min(max(probability, 0), 1)
    }
}
