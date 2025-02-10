//
//  ViewModel.swift
//  BBQuotes
//
//  Created by Oleksii Shamarin on 01/02/2025.
//

import Foundation

@Observable
@MainActor
class CharacterViewModel {
    enum CharacterFetchStatus: Equatable {
        case notStarted
        case fetching
        case successQuote
        case error(error: Error)
        
        static func == (lhs: CharacterFetchStatus, rhs: CharacterFetchStatus) -> Bool {
            switch (lhs, rhs) {
            case (.notStarted, .notStarted),
                (.fetching, .fetching),
                (.successQuote, .successQuote):
                return true
            case (.error, .error):
                return false // You can't compare errors directly
            default:
                return false
            }
        }
    }
    
    private(set) var status: CharacterFetchStatus = .notStarted
    
    private let fetcher = FetchService()
    
    var quote: Quote
    
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
        quote = try! decoder.decode(Quote.self, from: quoteData)
    }
    
    func getQuoteData(for character: String) async {
        status = .fetching
        
        do {
            quote = try await fetcher.fetchQuote(for: character)
            status = .successQuote
        } catch {
            status = .error(error: error)
        }
    }

}
