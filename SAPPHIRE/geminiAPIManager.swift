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
}
