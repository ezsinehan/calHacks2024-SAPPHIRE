//
//  geminiAPIManager.swift
//  SAPPHIRE
//
//  Created by EZ on 10/20/24.
//

import Foundation

class geminiAPIManger {
    static let shared = geminiAPIManger()
    
    func loadAPIKey() -> String? {
        if let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist"),
           let keys = NSDictionary(contentsOfFile: path) as? [String: Any],
           let apiKey = keys["GOOGLE_API_KEY"] as? String {
            return apiKey
        }
        return nil
    }
    
    func sendTextToGeminiAPI(screenText: String, taskText: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let apiKey = loadAPIKey() else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "API key missing"])))
            return
        }
        
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": screenText]
                    ]
                ]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data recieved"])))
                return
            }
            
            if let result = String(data: data, encoding: .utf8) {
                completion(.success(result))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data formatting error"])))
            }
        }
        
        task.resume()
    }
}


