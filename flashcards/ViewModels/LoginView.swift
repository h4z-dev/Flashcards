//
//  LoginView.swift
//  flashcards
//
//  Created  on 5/5/2024.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var err = ""
        
    @StateObject var viewModel: ContentViewModel
    
    init(authenticationModel: AuthenticationModel) {
        _viewModel = StateObject(wrappedValue: ContentViewModel(authModel: authenticationModel))
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Title
                Text("Flashcards")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(LinearGradient(colors: [.accentColor, .secondAccent], startPoint: .leading, endPoint: .trailing))
                
                // Icon
                Image(systemName: "list.clipboard")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 32)
                
                // Google sign in
                Button {
                    Task {
                        do {
                            try await viewModel.authModel.googleOauth()
                        } catch let e {
                            print(e)
                            err = e.localizedDescription
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "person.badge.key.fill")
                        Text("Sign in with Google")
                    } .padding(8)
                } .buttonStyle(.borderedProminent)
                
                Text(err).foregroundColor(.red).font(.caption)

                // Form fields
                VStack(alignment: .leading) {
                    // Email input
                    Label("Email Address", systemImage: "envelope.fill")
                        .foregroundStyle(Color(.darkGray))
                        .fontWeight(.semibold)
                        .font(.footnote)
                    TextField("name@example.com", text: $email)
                        .font(.system(size: 14))
                        .textFieldStyle(.roundedBorder)
                    
                    // Password input
                    Label("Password", systemImage: "lock.fill")
                        .foregroundStyle(Color(.darkGray))
                        .fontWeight(.semibold)
                        .padding(.top, 20)
                        .font(.footnote)
                    SecureField("Password", text: $password)
                        .font(.system(size: 14))
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                //TODO:
                // Forgot passsword
                
                // Sign in buttons
                Button {
                    Task {
                        do {
                            try await  viewModel.authModel.signIn(withEmail: email, password: password)
                        } catch {
                            
                        }
                        if (viewModel.authModel.userSession != nil) {
                            dismiss()
                        }
                    }
                    
                } label: {
                    HStack{
                        Text("Sign in")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundStyle(Color.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.3)
                .cornerRadius(10)
                .padding(.top, 24)
                Spacer()
                
                // Sign up button
                NavigationLink {
                    SignUpView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack{
                        Text("Don't have an account?")
                        Text("Sign up")
                            .fontWeight(.semibold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
    }
}

// Ensures details are filled out and basic form correction
extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

#Preview {
    LoginView(authenticationModel: AuthenticationModel())
}
