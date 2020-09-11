import Foundation
import PromiseKit

public struct KooberCloudAuthenticationRemoteAPI: AuthRemoteAPI {
    
    // MARK: - Properties
    let domain = "localhost"
    
    // MARK: - Methods
    public init() {}
    
    public func signIn(username: String, password: String) -> Promise<UserSession> {
        return Promise<UserSession> { seal in
            // Build Request
            var request = URLRequest(url: URL(string: "http://\(domain):8080/login")!)
            request.httpMethod = "POST"
            // Build Auth Header
            let userPasswordData = "\(username):\(password)".data(using: .utf8)!
            let base64EncodedCredential = userPasswordData.base64EncodedString(options: [])
            let authString = "Basic \(base64EncodedCredential)"
            request.addValue(authString, forHTTPHeaderField: "Authorization")
            // Send Data Task
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    seal.reject(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    seal.reject(RemoteAPIError.unknown)
                    return
                }
                guard 200..<300 ~= httpResponse.statusCode else {
                    seal.reject(RemoteAPIError.httpError)
                    return
                }
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let payload = try decoder.decode(SignInResponsePayload.self, from: data)
                        let remoteSession = RemoteUserSession(token: payload.token)
                        seal.fulfill(UserSession(profile: payload.profile, remoteSession: remoteSession))
                    } catch {
                        seal.reject(error)
                    }
                } else {
                    seal.reject(RemoteAPIError.unknown)
                }
            }.resume()
        }
    }
    
    public func signUp(account: NewAccount) -> Promise<UserSession> {
        return Promise<UserSession> { seal in
            // Build Request
            let url = URL(string: "http://\(domain):8080/signUp")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            // Encode JSON
            do {
                let bodyData = try JSONEncoder().encode(account)
                request.httpBody = bodyData
            } catch {
                seal.reject(error)
            }
            // Send Data Task
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    seal.reject(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    seal.reject(RemoteAPIError.unknown)
                    return
                }
                guard 200..<300 ~= httpResponse.statusCode else {
                    seal.reject(RemoteAPIError.httpError)
                    return
                }
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let payload = try decoder.decode(SignInResponsePayload.self, from: data)
                        let remoteSession = RemoteUserSession(token: payload.token)
                        seal.fulfill(UserSession(profile: payload.profile, remoteSession: remoteSession))
                    } catch {
                        seal.reject(error)
                    }
                } else {
                    seal.reject(RemoteAPIError.unknown)
                }
            }.resume()
        }
    }
}

struct SignInResponsePayload: Codable {
    let profile: UserProfile
    let token: String
}
