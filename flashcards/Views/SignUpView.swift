//
//  SignUpView.swift
//  flashcards
//
//  Created by Harris Vandenberg on 5/5/2024.
//

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var Name = ""
    @State private var cpassword = ""
    @State private var password = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authModel: AuthenticationModel

    var body: some View {
        VStack{
            // Image
            Image(systemName: "clipboard.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .padding(.vertical, 32)
        }
        VStack(spacing: 24) {
            // Full Name
            Text("Full Name")
                .foregroundStyle(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            TextField("John Smith", text: $Name)
                .font(.system(size: 14))
            
            // Email login
            Text("Email Address")
                .foregroundStyle(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            TextField("name@example.com", text: $email)
                .font(.system(size: 14))
            
            // Password input
            Text("Password")
                .foregroundStyle(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            TextField("Password", text: $password)
                .font(.system(size: 14))
            
            ZStack(alignment: .trailing) {
                Text("Repeat Password")
                    .foregroundStyle(Color(.darkGray))
                    .fontWeight(.semibold)
                    .font(.footnote)
                TextField("Confirm Password", text: $cpassword)
                    .font(.system(size: 14))
                if !password.isEmpty && !cpassword.isEmpty {
                    if password == cpassword {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(.systemGreen))
                    } else {
                        Text("Password must match")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 14))
                            .padding(.horizontal, 32)
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(.systemRed))
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 12)
        
        Spacer()
        
        Button {
            Task {
                try await authModel.createUser(
                    withEmail: email,
                    password: password,
                    fullname: Name
                )
            }
        } label: {
            HStack{
                Text("Sign UP")
                    .fontWeight(.semibold)
                Image(systemName: "arrow.right")
            }
            .foregroundStyle(Color.white)
            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
        }
        .background(Color(.systemBlue))
            .cornerRadius(10)
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.3)
            .padding(.top, 24)
        
        Spacer()
        
        Button {
            dismiss()
        } label: {
            HStack{
                Text("Already have an account?")
                Text("Sign In")
                    .fontWeight(.semibold)
            }
            .font(.system(size: 14))
        }
    }
}

extension SignUpView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && !Name.isEmpty
        && cpassword == password
    }
}

#Preview {
    SignUpView()
}
