import SwiftUI

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
