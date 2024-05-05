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
    @EnvironmentObject var viewModel: AuthenticationModel
    
    var body: some View {
        NavigationStack{
            VStack{
                Image(systemName: "list.clipboard")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 32)
            }
        }
    }
}
//        NavigationStack{
//            VStack{
//                // image
//                Image(systemName: "list.clipboard")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 100, height: 100)
//                    .padding(.vertical, 32)
//                
//                // form fields
//                VStack(spacing: 24){
//                    //email input
//                    Text("Email Address")
//                        .foregroundStyle(Color(.darkGray))
//                        .fontWeight(.semibold)
//                        .font(.footnote)
//                    TextField("name@example.com", text: $email)
//                        .font(.system(size: 14))
//                    
//                    //password input
//                    Text("Password")
//                        .foregroundStyle(Color(.darkGray))
//                        .fontWeight(.semibold)
//                        .font(.footnote)
//                    TextField("Password", text: $password)
//                        .font(.system(size: 14))
//                }
//                .padding(.horizontal)
//                .padding(.top, 12)
//                //TODO:
//                //forgot passsword
//                
//                // sign in buttons
//                Button{
//                    Task{
//                        try await  viewModel.signIn(withEmail: email, password: password)
//                    }
//                    
//                } label: {
//                    HStack{
//                        Text("Sign in")
//                            .fontWeight(.semibold)
//                        Image(systemName: "arrow.right")
//                    }
//                    .foregroundStyle(Color.white)
//                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
//                }
//                .background(Color(.systemBlue))
//                .disabled(!formIsValid)
//                .opacity(formIsValid ? 1.0 : 0.3)
//                .cornerRadius(10)
//                .padding(.top, 24)
//                Spacer()
//                
//                // sign up button
//                NavigationLink {
//                    SignUpView()
//                        .navigationBarBackButtonHidden(true)
//                } label: {
//                    HStack{
//                        Text("Don't have an account?")
//                        Text("Sign up")
//                            .fontWeight(.semibold)
//                    }
//                    .font(.system(size: 14))
//                }
//            }
//        }
//    }
//}
//
////ensures details are filled out and basic form correction
//extension LoginView: AuthenticationFormProtocol{
//    var formIsValid: Bool {
//        return !email.isEmpty
//        && email.contains("@")
//        && !password.isEmpty
//        && password.count > 5
//    }
//}

#Preview {
    LoginView()
}
