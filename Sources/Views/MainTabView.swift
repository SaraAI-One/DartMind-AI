import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ScoreboardView()
                .tabItem {
                    Label("Scoreboard", systemImage: "dart.fill")
                }
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .accentColor(.dartmind)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
