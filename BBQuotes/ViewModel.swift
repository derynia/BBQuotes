//
//  ViewModel.swift
//  BBQuotes
//
//  Created by Oleksii Shamarin on 01/02/2025.
//

import Foundation

@Observable
@MainActor
class ViewModel {
    enum FetchStatus: Equatable {
        case notStarted
        case fetching
        case successQuote
        case successEpisode
        case successCharacter
        case successSimpsonsQuote
        case error(error: Error)
        
        static func == (lhs: FetchStatus, rhs: FetchStatus) -> Bool {
            switch (lhs, rhs) {
            case (.notStarted, .notStarted),
                (.fetching, .fetching),
                (.successQuote, .successQuote),
                (.successCharacter, .successCharacter),
                (.successSimpsonsQuote, .successSimpsonsQuote),
                (.successEpisode, .successEpisode):
                return true
            case (.error, .error):
                return false // You can't compare errors directly
            default:
                return false
            }
        }
    }
    
    private(set) var status: FetchStatus = .notStarted
    
    private let fetcher = FetchService()
    
    var quote: Quote
    var simpsonsQuote: SimpsonsQuote
    var character: Char
    var episode: Episode
    var randomCharacter: Char
    
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
        quote = try! decoder.decode(Quote.self, from: quoteData)

        let simpsonsQuoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplesimpsonsquote", withExtension: "json")!)
        simpsonsQuote = try! decoder.decode(SimpsonsQuote.self, from: simpsonsQuoteData)

        let characterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        character = try! decoder.decode(Char.self, from: characterData)
        randomCharacter = try! decoder.decode(Char.self, from: characterData)
        
        let episodeData = try! Data(contentsOf: Bundle.main.url(forResource: "sampleepisode", withExtension: "json")!)
        episode = try! decoder.decode(Episode.self, from: episodeData)
    }
    
    func getQuoteData(for show: String) async {
        status = .fetching
        
        let needSimpsons = Int.random(in: 0..<5)
        if (needSimpsons == 4) {
            await getSimpsonsQuote()
            return
        }
        
        do {
            quote = try await fetcher.fetchQuote(from: show)
            character = try await fetcher.fetchCharacter(quote.character)
            character.death = try await fetcher.fetchDeath(for: quote.character)
            status = .successQuote
        } catch {
            status = .error(error: error)
        }
    }
    
    func getSimpsonsQuote() async {
        do {
            simpsonsQuote = try await fetcher.fetchSimpsonsQuote() ?? simpsonsQuote
            status = .successSimpsonsQuote
        } catch {
            status = .error(error: error)
        }
    }
    
    func getEpisodeData(for show: String) async {
        status = .fetching
        
        do {
            if let unwrappeedEdisode = try await fetcher.fetchEpisode(from: show) {
                episode = unwrappeedEdisode
            }
            status = .successEpisode
        } catch {
            status = .error(error: error)
        }
    }
    
    func getCharacterData(for show: String) async {
        status = .fetching
        
        do {
            if let unwrappeedCharacter = try await fetcher.fetchRandomCharacter(for: show) {
                randomCharacter = unwrappeedCharacter
                randomCharacter.death = try await fetcher.fetchDeath(for: randomCharacter.name)
            }
            status = .successCharacter
        } catch {
            status = .error(error: error)
        }
    }
}
