import Foundation

public typealias CryptoExchange = String
public typealias CryptoExchanges = [String]

public struct CryptoSymbol: Codable, Hashable {
    public let description, displaySymbol, symbol: String
}

public typealias CryptoSymbols = [CryptoSymbol]
