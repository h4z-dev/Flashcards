//
//  LoginView.swift
//  flashcards
//
//  Created  on 5/5/2024.
//

import SwiftUI
import GoogleSignInSwift //
import GoogleSignIn

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var err = ""
    //    @StateObject var viewModel: ContentViewModel
    @EnvironmentObject var authModel: AuthenticationModel
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
                Image(.iconRoundrect)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150)
                    .padding(.vertical, 32)
                
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
                            try await  authModel.signIn(withEmail: email, password: password)
                        } catch {
                            
                        }
                        if (authModel.isAuthenticated()) {
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
                
                // Google sign in
//                Button {
//                    Task {
//                        do {
//                            try await authModel.googleOauth()
//                        } catch let e {
//                            print(e)
//                            err = e.localizedDescription
//                        }
//                    }
//                } label: {
//                    Image("iosNeutralGoogleSignIn")
//                        .resizable()
//                        .padding(.top, 12)
//                        .padding(.horizontal)
////                    Text("Sign in with Google")
//                }
                
                GoogleSignInButton() {
                    Task {
                        do {
                            try await authModel.googleOauth()
                        } catch let e {
                            print(e)
                            err = e.localizedDescription
                        }
                        if (authModel.userSession != nil) {
                            dismiss()
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .clipShape(RoundedRectangle(cornerRadius: 200))
                Text(err).foregroundColor(.red).font(.caption)
                
                //pushes signup to bottom of screen
                Spacer()
                
                // Sign up button
                NavigationLink {
                    SignUpView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack {
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
    LoginView().onOpenURL { url in
        // Handle Google Oauth URL
        GIDSignIn.sharedInstance.handle(url)
    }
    .environmentObject(AuthenticationModel())
}
