import SwiftUI

struct Project: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let date: Date
    let description: String
}

struct ProjectsView: View {
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
                }
                .padding()
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
