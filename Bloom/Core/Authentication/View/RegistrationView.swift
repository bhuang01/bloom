//
//  RegistrationView.swift
//  Bloom
//
//  Created by vzhu on 11/10/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                Image("bloom-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 120)
                    .padding(.vertical, 32)
                
                VStack(spacing: 24) {
                    InputView(ext: $email,
                              title: "Email Address",
                              placeholder: "name@example.com")
                    .autocapitalization(.none)
                    
                    InputView(ext: $fullname,
                              title: "Full Name",
                              placeholder: "Enter you name")
                    
                    InputView(ext: $password,
                              title: "Password",
                              placeholder: "Enter your password",
                              isSecurefield: true)
                    
                    ZStack(alignment: .trailing) {
                        InputView(ext: $confirmPassword,
                                  title: "Confirm Password",
                                  placeholder: "Confirm your password",
                                  isSecurefield: true)
                        if !password.isEmpty && !confirmPassword.isEmpty {
                            if password == confirmPassword {
                                    Image(systemName: "checkmark.circle.fill")
                                        .imageScale(.large)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.systemGreen))
                                } else {
                                    Image(systemName: "xmark.circle.fill")
                                        .imageScale(.large)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.systemRed))
                                }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Button{
                    Task{
                        try await viewModel.createUser(withEmail: email, password: password, fullname: fullname)
                    }
                } label: {
                    HStack {
                        Text("SIGN UP")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
    }
}

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
            && email.contains("@")
            && !password.isEmpty
            && !confirmPassword.isEmpty
            && password.count > 5
            && confirmPassword.count > 5
            && !fullname.isEmpty
            && confirmPassword == password
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
