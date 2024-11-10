//
//  HealthKitManager.swift
//  Bloom
//
//  Created by Bryan Huang on 11/10/24.
//

import Foundation
import HealthKit

extension HKBiologicalSex {
    func stringValue() -> String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        case .other:
            return "Other"
        case .notSet:
            return "Not Set"
        @unknown default:
            return "Unknown"
        }
    }
}

extension HKBloodType {
    func stringValue() -> String {
        switch self {
        case .notSet:
            return "Not Set"
        case .aPositive:
            return "A+"
        case .aNegative:
            return "A-"
        case .bPositive:
            return "B+"
        case .bNegative:
            return "B-"
        case .abPositive:
            return "AB+"
        case .abNegative:
            return "AB-"
        case .oPositive:
            return "O+"
        case .oNegative:
            return "O-"
        @unknown default:
            return "Unknown"
        }
    }
}

class HealthKitManager: ObservableObject {
    let healthStore = HKHealthStore()
    
    @Published var isAuthorized = false
    @Published var heartRate: Double = 0
    @Published var stepCount: Int = 0
    @Published var height: Double = 0
    @Published var bodyMass: Double = 0
    @Published var bodyMassIndex: Double = 0
    @Published var leanBodyMass: Double = 0
    @Published var bodyFatPercentage: Double = 0
    @Published var waistCircumference: Double = 0
    @Published var systolicBloodPressure: Double = 0
    @Published var diastolicBloodPressure: Double = 0
    @Published var bloodGlucose: Double = 0
//    @Published var inhalerUsage: Bool = false
    
    // Characteristics
    @Published var bloodType: HKBloodType = .notSet
    @Published var biologicalSex: HKBiologicalSex = .notSet
    @Published var dateOfBirth: Date?
    
    func requestAuthorization() {
        let typesToRead: Set<HKObjectType> = [
            // Existing properties
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,

            // Additional properties
            HKObjectType.quantityType(forIdentifier: .height)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!,
            HKObjectType.quantityType(forIdentifier: .leanBodyMass)!,
            HKObjectType.quantityType(forIdentifier: .bodyFatPercentage)!,
            HKObjectType.quantityType(forIdentifier: .waistCircumference)!,
            HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!,
            HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!,
            HKObjectType.quantityType(forIdentifier: .bloodGlucose)!,
            
            // Personal Information (requires permission)
            HKObjectType.characteristicType(forIdentifier: .bloodType)!,
            HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!
        ]

        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
            DispatchQueue.main.async {
                self.isAuthorized = success
                if success {
                    self.fetchHealthData()
                }
            }
        }
    }
    
    // Fetch the health data from HealthKit
    func fetchHealthData() {
        fetchHeartRate()
        fetchStepCount()
        fetchHeight()
        fetchBodyMass()
        fetchBodyMassIndex()
        fetchLeanBodyMass()
        fetchBodyFatPercentage()
        fetchWaistCircumference()
        fetchBloodPressure()
        fetchBloodGlucose()
        fetchBloodType()
        fetchBiologicalSex()
        fetchDateOfBirth()
    }
    
    // Fetch Heart Rate
    func fetchHeartRate() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
            guard let result = results?.first as? HKQuantitySample else { return }
            let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
            DispatchQueue.main.async {
                self.heartRate = result.quantity.doubleValue(for: heartRateUnit)
            }
        }
        healthStore.execute(query)
    }
    
    // Fetch Step Count
    func fetchStepCount() {
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let query = HKSampleQuery(sampleType: stepCountType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
            guard let result = results?.first as? HKQuantitySample else { return }
            DispatchQueue.main.async {
                self.stepCount = Int(result.quantity.doubleValue(for: .count()))
            }
        }
        healthStore.execute(query)
    }

    // Fetch Height
    func fetchHeight() {
        let heightType = HKObjectType.quantityType(forIdentifier: .height)!
        let query = HKSampleQuery(sampleType: heightType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
            guard let result = results?.first as? HKQuantitySample else { return }
            DispatchQueue.main.async {
                self.height = result.quantity.doubleValue(for: .meter())
            }
        }
        healthStore.execute(query)
    }
    
    // Fetch Body Mass
    func fetchBodyMass() {
        let bodyMassType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        let query = HKSampleQuery(sampleType: bodyMassType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
            guard let result = results?.first as? HKQuantitySample else { return }
            DispatchQueue.main.async {
                self.bodyMass = result.quantity.doubleValue(for: .gramUnit(with: .kilo))
            }
        }
        healthStore.execute(query)
    }
    
    // Fetch Body Mass Index (BMI)
    func fetchBodyMassIndex() {
        let bmiType = HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!
        let query = HKSampleQuery(sampleType: bmiType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
            guard let result = results?.first as? HKQuantitySample else { return }
            DispatchQueue.main.async {
                self.bodyMassIndex = result.quantity.doubleValue(for: .count())
            }
        }
        healthStore.execute(query)
    }
    
    // Fetch Lean Body Mass
    func fetchLeanBodyMass() {
        let leanBodyMassType = HKObjectType.quantityType(forIdentifier: .leanBodyMass)!
        let query = HKSampleQuery(sampleType: leanBodyMassType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
            guard let result = results?.first as? HKQuantitySample else { return }
            DispatchQueue.main.async {
                self.leanBodyMass = result.quantity.doubleValue(for: .gramUnit(with: .kilo))
            }
        }
        healthStore.execute(query)
    }
    
    // Fetch Body Fat Percentage
    func fetchBodyFatPercentage() {
        let bodyFatType = HKObjectType.quantityType(forIdentifier: .bodyFatPercentage)!
        let query = HKSampleQuery(sampleType: bodyFatType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
            guard let result = results?.first as? HKQuantitySample else { return }
            DispatchQueue.main.async {
                self.bodyFatPercentage = result.quantity.doubleValue(for: .percent())
            }
        }
        healthStore.execute(query)
    }

    // Fetch Waist Circumference
    func fetchWaistCircumference() {
        let waistCircumferenceType = HKObjectType.quantityType(forIdentifier: .waistCircumference)!
        let query = HKSampleQuery(sampleType: waistCircumferenceType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
            guard let result = results?.first as? HKQuantitySample else { return }
            DispatchQueue.main.async {
                self.waistCircumference = result.quantity.doubleValue(for: .meter())
            }
        }
        healthStore.execute(query)
    }

    // Fetch Blood Pressure
    func fetchBloodPressure() {
        let systolicType = HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!
        let diastolicType = HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!
        
        let systolicQuery = HKSampleQuery(sampleType: systolicType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
            guard let result = results?.first as? HKQuantitySample else { return }
            DispatchQueue.main.async {
                self.systolicBloodPressure = result.quantity.doubleValue(for: .millimeterOfMercury())
            }
        }
        
        let diastolicQuery = HKSampleQuery(sampleType: diastolicType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
            guard let result = results?.first as? HKQuantitySample else { return }
            DispatchQueue.main.async {
                self.diastolicBloodPressure = result.quantity.doubleValue(for: .millimeterOfMercury())
            }
        }
        
        healthStore.execute(systolicQuery)
        healthStore.execute(diastolicQuery)
    }
    
    // Fetch Blood Glucose
    func fetchBloodGlucose() {
        let glucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose)!
        let glucoseQuery = HKSampleQuery(sampleType: glucoseType, predicate: nil, limit: 1, sortDescriptors: nil) { _, results, _ in
            guard let result = results?.first as? HKQuantitySample else { return }
            let glucoseUnit = HKUnit(from: "mg/dL")
            DispatchQueue.main.async {
                self.bloodGlucose = result.quantity.doubleValue(for: glucoseUnit)
            }
        }
        healthStore.execute(glucoseQuery)
    }
    
    // Fetch Biological Sex
    func fetchBiologicalSex() {
        do {
            let biologicalSex = try healthStore.biologicalSex()
            DispatchQueue.main.async {
                self.biologicalSex = biologicalSex.biologicalSex
            }
        } catch {
            print("Error fetching biological sex: \(error.localizedDescription)")
        }
    }
    
    // Fetch Date of Birth
    func fetchDateOfBirth() {
        do {
            let dateOfBirthComponents = try healthStore.dateOfBirthComponents()
            DispatchQueue.main.async {
                self.dateOfBirth = Calendar.current.date(from: dateOfBirthComponents)
            }
        } catch {
            print("Error fetching date of birth: \(error.localizedDescription)")
        }
    }
    
    // Fetch Blood Type
    func fetchBloodType() {
        do {
            let bloodType = try healthStore.bloodType()
            DispatchQueue.main.async {
                self.bloodType = bloodType.bloodType
            }
        } catch {
            print("Error fetching blood type: \(error.localizedDescription)")
        }
    }
    
//    func fetchSampleData() {
//        // For MVP, we'll use sample data instead of actual HealthKit queries
//        DispatchQueue.main.async {
//            self.heartRate = Double.random(in: 60...100)
//            self.stepCount = Int.random(in: 1000...10000)
//        }
//    }
}
