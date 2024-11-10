import SwiftUI

struct Project: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let date: Date
    let description: String
}

//import FirebaseFirestore
//
//struct Project: Identifiable {
//    let title: String
//    let description: String
//    let startDate: Date
//    let endDate: Date
//    let dataRequirements: String
//    let studyType: String
//    let rewardAmount: String
//}
//
//func parseProjectData(data: [String: Any]) -> Project? {
//    guard let title = data["title"] as? String,
//          let description = data["description"] as? String,
//          let startDateString = data["startDate"] as? String,
//          let endDateString = data["endDate"] as? String,
//          let dataRequirements = data["dataRequirements"] as? String,
//          let studyType = data["studyType"] as? String,
//          let rewardAmount = data["rewardAmount"] as? String,
//          let startDate = ISO8601DateFormatter().date(from: startDateString),
//          let endDate = ISO8601DateFormatter().date(from: endDateString) else {
//        print("Error parsing project data: Missing required fields or date conversion failed.")
//        return nil
//    }
//
//    return Project(
//        title: title,
//        description: description,
//        startDate: startDate,
//        endDate: endDate,
//        dataRequirements: dataRequirements,
//        studyType: studyType,
//        rewardAmount: rewardAmount
//    )
//}
//
//func fetchAllProjects(completion: @escaping ([Project]) -> Void) {
//    let db = Firestore.firestore()
//    let projectsCollection = db.collection("projects")
//    
//    projectsCollection.getDocuments { (querySnapshot, error) in
//        var projects = [Project]()
//        
//        if let error = error {
//            print("Error fetching projects: \(error.localizedDescription)")
//            completion(projects)
//        } else {
//            guard let documents = querySnapshot?.documents else {
//                print("No documents found.")
//                completion(projects)
//                return
//            }
//            
//            for document in documents {
//                let data = document.data()
//                
//                if let project = parseProjectData(data: data) {
//                    projects.append(project)
//                }
//            }
//            
//            completion(projects)
//        }
//    }
//}

//fetchAllProjects { projects in
//    for project in projects {
//        print("Title: \(project.title)")
//        print("Description: \(project.description)")
//        print("Date: \(project.startDate)")
//        print("End Date: \(project.endDate)")
//        print("Data Requirements: \(project.dataRequirements)")
//        print("Study Type: \(project.studyType)")
//        print("Reward Amount: \(project.rewardAmount)\n")
//    }
//}


struct ProjectsView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    // gradient
    private let titleGradient = LinearGradient(
        colors: [.blue, .purple],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // Sample projects - you can replace this with actual data
    private let projects: [Project] = [
        Project(
            title: "Impact of Exercise on Mental Health",
            author: "Dr. Sarah Johnson",
            date: Date(),
            description: "A study examining the correlation between regular physical activity and mental well-being in adults aged 25-40."
        ),
        Project(
            title: "Sleep Patterns in Remote Workers",
            author: "Dr. Michael Chen",
            date: Date().addingTimeInterval(-7*24*60*60), // 7 days ago
            description: "Research investigating how remote work affects sleep quality and patterns among professionals."
        ),
        // Add more sample projects as needed
    ]
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        GradientText(
                            text: "Research",
                            gradient: titleGradient
                        )
                        .padding(.top)
                        
                        ForEach(projects) { project in
                            ProjectCard(project: project)
                        }
                        
                        // Account Section
                        Section("Account") {
                            Button {
                                viewModel.signOut()
                            } label: {
                                SettingsRowView(imageName: "arrow.left.circle.fill",
                                                title: "Sign Out",
                                                tintColor: .red)
                            }
                            
                            Button {
                                print("Delete account...")
                            } label: {
                                SettingsRowView(imageName: "xmark.circle.fill",
                                                title: "Delete Account",
                                                tintColor: .red)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct ProjectCard: View {
    let project: Project
    @State private var dataSubmitted = false
    @State private var showingSubmitAlert = false
    @StateObject private var healthKitManager = HealthKitManager()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                Text(project.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    Label(project.author, systemImage: "person.fill")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Label(dateFormatter.string(from: project.date), systemImage: "calendar")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text(project.description)
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                Button(action: {
                    healthKitManager.pushHealthDataToFirestore()
                    showingSubmitAlert = true
                }) {
                    Text("Contribute")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 8)
            }
            .padding(8)
        }
        .alert("Data Submitted", isPresented: $showingSubmitAlert) {
            Button("OK") { }
        } message: {
            Text("Your health data has been successfully submitted.")
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView()
    }
}
