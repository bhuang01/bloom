//
//  ContentView.swift
//  Bloom
//
//  Created by Bryan Huang on 11/9/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        Group {
            if viewModel.userSession != nil {
                TabView {
                    DashboardView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Dashboard")
                        }

                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                }
            } else {
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
