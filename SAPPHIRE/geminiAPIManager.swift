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

    // Function to send recognized text and task text to Gemini API
    func sendTextToGeminiAPI(screenText: String, taskText: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let apiKey = loadAPIKey() else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "API key missing"])))
            return
        }

        let urlString = "https://api.googleapis.com/gemini/v1/compareText" // Replace with correct endpoint
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let requestBody: [String: Any] = [
            "screen_text": screenText,
            "task_text": taskText
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

            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }

            if let result = String(data: data, encoding: .utf8) {
                completion(.success(result))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data format"])))
            }

        }

        task.resume()
    }
}

