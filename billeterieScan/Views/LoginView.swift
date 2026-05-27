//
//  LoginView.swift
//  billeterieScan
//

import SwiftUI

struct LoginView: View {
    @State private var loginVM = LoginViewModel()
    @State private var showPassword = false
    var body: some View {
        VStack(spacing: 32) {
            logoSection
            loginCard
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
    private var logoSection: some View {
          VStack(spacing: 24) {
              ZStack {
                  Image(R.image.logo)
                      .resizable()
                      .scaledToFill()
                      .frame(width: 100, height: 100)
                      .cornerRadius(12)
              }
              VStack(spacing: 8) {
                  Text("AppName")
                      .font(.system(size: 32, weight: .bold))
                      .foregroundStyle(Color(R.color.tertiary))

                  Text("Login.description")
                      .font(.system(size: 18))
                      .foregroundStyle(Color(R.color.primaryLight).opacity(0.7))
              }
          }
      }
    private var loginCard: some View {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color(R.color.tertiary))

                    Text("Authentificate")
                        .font(.system(size: 18))
                        .foregroundStyle(Color(R.color.primaryLight))
                }

                passwordField

                submitButton

                if let error = loginVM.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.footnote)
                }

            }
            .padding(20)
            .overlay(alignment: .top) {
                LinearGradient(
                    colors: [.clear, Color(R.color.primary), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(height: 3)
            }
            .cornerRadius(12)
            .background(Color(hex: "#1D1617"))
        }
    private var passwordField: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color(R.color.primaryLight))
                HStack(spacing: 12) {
                    Image(systemName: "lock")
                        .foregroundStyle(Color(R.color.primaryLight)
                        .opacity(0.6))
                    Group {
                        if showPassword {
                            TextField("••••••••", text: $loginVM.password)
                        } else {
                            SecureField("••••••••", text: $loginVM.password)
                        }
                    }
                    .textContentType(.password)
                    .autocorrectionDisabled()
                    .foregroundStyle(Color(R.color.tertiary))

                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundStyle(Color(R.color.primaryLight).opacity(0.6))
                    }
                }
                .padding(16)
                .background(Color(hex: "#1C1B1B"))
                .cornerRadius(8)
                .border(Color.white.opacity(0.1), width: 1)
            }
        }
    private var submitButton: some View {
            Button {
                Task { await loginVM.submit() }
            } label: {
                HStack(spacing: 12) {
                    if loginVM.isLoading {
                        ProgressView()
                            .tint(Color(hex: "FFE5E3"))
                    } else {
                        Text("ConnectBtn")
                            .font(.system(size: 20, weight: .semibold))
                        Image(systemName: "arrow.right")
                    }
                }
                .foregroundStyle(Color(R.color.tertiary))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(R.color.primary))
                .cornerRadius(8)
            }
            .disabled(loginVM.password.isEmpty || loginVM.isLoading)
        }
}

#Preview {
    LoginView()
}
