import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var selectedTab: Tab = .dashboard
    
    enum Tab {
        case dashboard, profile
    }

    var body: some View {
        Group {
            if viewModel.userSession != nil {
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
