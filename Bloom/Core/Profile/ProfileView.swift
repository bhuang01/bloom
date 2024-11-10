import SwiftUI


struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showUserDetails = false
    @State private var posts: [Post] = [
        Post(title: "Post 1", briefDescription: "This is a brief description of post 1.", fullDescription: "This is the full content of post 1."),
        Post(title: "Post 2", briefDescription: "This is a brief description of post 2.", fullDescription: "This is the full content of post 2."),
        // Add more posts as needed
    ]
    
    var body: some View {
        if let user = viewModel.currentUser {
            VStack {
                // Header with initials button and logo image
                HStack {
                    Image("bloom-logo")
                        .resizable()
                        .frame(width: 150, height: 80)
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        showUserDetails.toggle()
                    }) {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                    }
                    .padding()
                }
                
                if showUserDetails {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(user.fullname)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text(user.email)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Research Postings")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        GroupBox(label: Label("Emergancy Medicine", systemImage: "folder.fill")) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Blood Type:")
                                Text("Biological Sex:")
                                Text("Biological Sex:")
                            }
                            .padding(.vertical, 8)
                        }
                        
                        ForEach(posts) { post in
                            CardView(post: post)
                                .padding(.horizontal)
                        }
                    }
                    
                    // Account Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Account")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Button {
                            viewModel.signOut()
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill",
                                            title: "Sign Out",
                                            tintColor: .red)
                                .padding(.horizontal)
                        }
                        
                        Button {
                            print("Delete account...")
                        } label: {
                            SettingsRowView(imageName: "xmark.circle.fill",
                                            title: "Delete Account",
                                            tintColor: .red)
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
