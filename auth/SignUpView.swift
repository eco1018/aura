//
//  SignUpView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

//
//  SignUpView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

//
//  SignUpView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authVM: AuthViewModel

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("AURA")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.blue)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Create Account")
                            .font(.title)
                            .fontWeight(.bold)

                        Text("Sign up to get started")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                    VStack(spacing: 15) {
                        HStack {
                            TextField("First Name", text: $firstName)
                                .modifier(AuthTextFieldStyle())

                            TextField("Last Name", text: $lastName)
                                .modifier(AuthTextFieldStyle())
                        }
                        .padding(.horizontal)

                        TextField("Email", text: $email)
                            .modifier(AuthTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .padding(.horizontal)

                        SecureField("Password", text: $password)
                            .textContentType(.none)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .modifier(AuthTextFieldStyle())
                            .padding(.horizontal)

                        SecureField("Confirm Password", text: $confirmPassword)
                            .textContentType(.none)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .modifier(AuthTextFieldStyle())
                            .padding(.horizontal)

                        Button {
                            Task {
                                print("🔵 Sign Up button tapped")

                                await authVM.signUpWithEmail(
                                    email: email,
                                    password: password,
                                    confirmPassword: confirmPassword,
                                    firstName: firstName,
                                    lastName: lastName
                                )

                                print("🟢 authVM.user is now: \(String(describing: authVM.user?.uid))")
                            }
                        } label: {
                            Text("Sign Up")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }

                        HStack {
                            Spacer()
                            Text("OR").foregroundColor(.gray)
                            Spacer()
                        }

                        HStack(spacing: 16) {
                            Image(systemName: "g.circle.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                            Image(systemName: "applelogo")
                                .resizable()
                                .frame(width: 28, height: 32)
                        }

                        HStack {
                            Text("Already have an account?")
                            NavigationLink("Sign In", destination: SignInView())
                                .fontWeight(.semibold)
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(.vertical)
            }
        }
    }
}
