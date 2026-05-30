//
//  LoginViewModel.swift
//  billeterieScan
//

import Foundation

@MainActor
@Observable
final class LoginViewModel {
    var password: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var token: String? = UserDefaults.standard.string(forKey: "authToken")

    func submit() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let jwt = try await APIClient.shared.login(password: password)
            token = jwt
            UserDefaults.standard.set(jwt, forKey: "authToken")
        } catch APIError.unauthorized {
            errorMessage = "Mot de passe incorrect"
        } catch APIError.transport(let underlying) {
            errorMessage = "Erreur réseau : \(underlying.localizedDescription)"
        } catch APIError.server(let status) {
            errorMessage = "Erreur serveur (\(status))"
        } catch APIError.decoding {
            errorMessage = "Réponse du serveur invalide"
        } catch {
            errorMessage = "Erreur : \(error)"
        }
    }
    
    func logout() {
        token = nil
        UserDefaults.standard.removeObject(forKey: "authToken")
    }
}
