import SwiftUI

extension Color {
    static let customBackground = Color(red: 242/255, green: 246/255, blue: 250/255)  // Soft blue-gray
}

struct CustomGroupBoxStyle: GroupBoxStyle {
    var backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.label
            configuration.content
        }
        .padding()
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct HealthMetric: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let icon: String  // SF Symbol name
}

struct GradientText: View {
    let text: String
    let gradient: LinearGradient
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .fontWeight(.bold)
            .overlay(gradient)
            .mask(
                Text(text)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            )
    }
}

struct DashboardView: View {
    @State private var dataSubmitted = false
    @State private var showingSubmitAlert = false
    @StateObject private var healthKitManager = HealthKitManager()
        
    // gradient
    private let titleGradient = LinearGradient(
        colors: [.blue, .purple],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    private var bodyMetrics: [HealthMetric] {
        [
            HealthMetric(title: "Height", value: String(format: "%.2f m", healthKitManager.height), icon: "ruler"),
            HealthMetric(title: "Body Mass", value: String(format: "%.2f kg", healthKitManager.bodyMass), icon: "scalemass"),
            HealthMetric(title: "BMI", value: String(format: "%.2f", healthKitManager.bodyMassIndex), icon: "figure"),
            HealthMetric(title: "Lean Body Mass", value: String(format: "%.2f kg", healthKitManager.leanBodyMass), icon: "figure.arms.open"),
            HealthMetric(title: "Body Fat", value: String(format: "%.2f%%", healthKitManager.bodyFatPercentage), icon: "percent"),
            HealthMetric(title: "Waist", value: String(format: "%.2f m", healthKitManager.waistCircumference), icon: "circle.dashed")
        ]
    }
    
    private var vitalMetrics: [HealthMetric] {
        [
            HealthMetric(title: "Heart Rate", value: String(format: "%.0f bpm", healthKitManager.heartRate), icon: "heart.fill"),
            HealthMetric(title: "Steps", value: "\(healthKitManager.stepCount)", icon: "figure.walk"),
            HealthMetric(title: "Blood Pressure", value: String(format: "%.0f/%.0f mmHg", healthKitManager.systolicBloodPressure, healthKitManager.diastolicBloodPressure), icon: "waveform.path.ecg"),
            HealthMetric(title: "Blood Glucose", value: String(format: "%.2f mg/dL", healthKitManager.bloodGlucose), icon: "drop.fill")
        ]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    GradientText(
                        text: "Health Dashboard",
                        gradient: titleGradient
                    )
                    .padding(.top)
                    
                    // Personal Information Section
                    GroupBox(label: Label("Personal Information", systemImage: "person.fill")) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Blood Type: \(healthKitManager.bloodType.stringValue())")
                            Text("Biological Sex: \(healthKitManager.biologicalSex.stringValue())")
                            if let dateOfBirth = healthKitManager.dateOfBirth {
                                Text("Date of Birth: \(dateOfBirth, formatter: dateFormatter)")
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    // Vital Metrics Section
                    GroupBox(label: Label("Vital Metrics", systemImage: "heart.text.square.fill")) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(vitalMetrics) { metric in
                                MetricCard(metric: metric)
                            }
                        }
                    }
                    
                    // Body Metrics Section
                    GroupBox(label: Label("Body Metrics", systemImage: "figure.stand")) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(bodyMetrics) { metric in
                                MetricCard(metric: metric)
                            }
                        }
                    }
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            healthKitManager.fetchHealthData()
                        }) {
                            Label("Refresh Data", systemImage: "arrow.clockwise")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            healthKitManager.pushHealthDataToFirestore()
                            showingSubmitAlert = true
                        }) {
                            Label("Submit Data", systemImage: "square.and.arrow.up")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.top)
                }
                .padding()
            }
            .alert("Data Submitted", isPresented: $showingSubmitAlert) {
                Button("OK") { }
            } message: {
                Text("Your health data has been successfully submitted.")
            }
        }
        .onAppear {
            healthKitManager.requestAuthorization()
        }
    }
}

// Helper view for metric cards
struct MetricCard: View {
    let metric: HealthMetric
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(metric.title, systemImage: metric.icon)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(metric.value)
                .font(.headline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// Date Formatter for Date of Birth
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
