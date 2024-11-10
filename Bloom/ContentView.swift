////
////  ContentView.swift
////  Bloom
////
////  Created by Bryan Huang on 11/9/24.
////
//
//import SwiftUI
//
//struct ContentView: View {
//    @State private var dataSubmitted = false
//    @StateObject private var healthKitManager = HealthKitManager()
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 20) {
//                    // Heart Rate
//                    Text("Heart Rate: \(healthKitManager.heartRate, specifier: "%.0f") bpm")
//                    
//                    // Step Count
//                    Text("Step Count: \(healthKitManager.stepCount)")
//                    
//                    // Height
//                    Text("Height: \(healthKitManager.height, specifier: "%.2f") meters")
//                    
//                    // Body Mass
//                    Text("Body Mass: \(healthKitManager.bodyMass, specifier: "%.2f") kg")
//                    
//                    // BMI (Body Mass Index)
//                    Text("BMI: \(healthKitManager.bodyMassIndex, specifier: "%.2f")")
//                    
//                    // Lean Body Mass
//                    Text("Lean Body Mass: \(healthKitManager.leanBodyMass, specifier: "%.2f") kg")
//                    
//                    // Body Fat Percentage
//                    Text("Body Fat Percentage: \(healthKitManager.bodyFatPercentage, specifier: "%.2f") %")
//                    
//                    // Waist Circumference
//                    Text("Waist Circumference: \(healthKitManager.waistCircumference, specifier: "%.2f") meters")
//                    
//                    // Blood Pressure
//                    Text("Blood Pressure: \(healthKitManager.systolicBloodPressure, specifier: "%.0f")/\(healthKitManager.diastolicBloodPressure, specifier: "%.0f") mmHg")
//                    
//                    // Blood Glucose
//                    Text("Blood Glucose: \(healthKitManager.bloodGlucose, specifier: "%.2f") mg/dL")
//                   
//                    // Blood Type
//                    Text("Blood Type: \(healthKitManager.bloodType.stringValue())")
//                    
//                    // Biological Sex
//                    Text("Biological Sex: \(healthKitManager.biologicalSex.stringValue())")
//                    
//                    // Date of Birth
//                    if let dateOfBirth = healthKitManager.dateOfBirth {
//                        Text("Date of Birth: \(dateOfBirth, formatter: dateFormatter)")
//                    }
//                    
//                    Button("Refresh Data") {
//                        healthKitManager.fetchHealthData()
//                    }
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    
//                    Button(action: {
//                        // Action to submit data to Firestore
//                        healthKitManager.pushHealthDataToFirestore()
//                    }) {
//                        Text("Submit Data")
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.green)
//                        .cornerRadius(10)
//                    }
//                    .padding()
//                }
//                .padding()
//            }
//            .navigationTitle("Health Dashboard")
//        }
//        .onAppear {
//            healthKitManager.requestAuthorization()
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
//// Date Formatter for Date of Birth
//private let dateFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .medium
//    return formatter
//}()

import SwiftUI

struct ContentView: View {
//    @EnvironmentObject var viewModel: AuthViewModel
    @State private var selectedTab: Tab = .dashboard
    
    enum Tab {
        case dashboard, profile
    }

    var body: some View {
        Group {
            TabView() {
                DashboardView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("My Health")
                    }
                
                ProjectsView()
                    .tabItem {
                        Image(systemName: "tray.full.fill")
                        Text("Research")
                    }
            }
//            DashboardView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
