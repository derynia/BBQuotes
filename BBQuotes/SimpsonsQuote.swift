//
//  Quote.swift
//  BBQuotes
//
//  Created by Oleksii Shamarin on 31/01/2025.
//
import Foundation

struct SimpsonsQuote: Decodable {
    let quote: String
    let character: String
    let image: URL
    let characterDirection: String
}

