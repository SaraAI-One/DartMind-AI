import SwiftUI

struct ProfileView: View {
    @State private var playerProfile: PlayerProfile = PlayerProfile()
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.dartmind)
                
                Text(playerProfile.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(playerProfile.email)
                    .foregroundColor(.gray)
                
                Divider()
                    .padding()
                
                List {
                    Section("Personal Info") {
                        HStack {
                            Text("Name")
                            Spacer()
                            Text(playerProfile.name)
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("Email")
                            Spacer()
                            Text(playerProfile.email)
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("Level")
                            Spacer()
                            Text(playerProfile.level)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Section("Preferences") {
                        HStack {
                            Text("Game Mode")
                            Spacer()
                            Text(playerProfile.preferredGameMode)
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("Handedness")
                            Spacer()
                            Text(playerProfile.handedness)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Section("Settings") {
                        Button("Edit Profile") {
                            // Edit profile action
                        }
                        Button("Privacy Settings") {
                            // Privacy settings action
                        }
                        Button("About DartMind AI") {
                            // About action
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
