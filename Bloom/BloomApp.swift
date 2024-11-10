//
//  BloomApp.swift
//  Bloom
//
//  Created by Bryan Huang on 11/9/24.
//

import Firebase
import SwiftUI

@main
struct BloomApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

