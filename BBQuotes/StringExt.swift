//
//  StringExt.swift
//  BBQuotes
//
//  Created by Oleksii Shamarin on 08/02/2025.
//

extension String {
    func removeSpaces() -> String {
        self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeCaseAndSpaces() -> String {
        self.lowercased().removeSpaces()
    }
}
