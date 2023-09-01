import Foundation

public struct StockSearchResponse: Codable {
    public let count: Int
    public let result: [StockSearchResult]

    enum CodingKeys: String, CodingKey {
        case count = "count"
        case result = "result"
    }
}

public struct StockSearchResult: Codable {
    public let description: String
    public let displaySymbol: String
    public let symbol: String
    public let type: String

    enum CodingKeys: String, CodingKey {
        case description = "description"
        case displaySymbol = "displaySymbol"
        case symbol = "symbol"
        case type = "type"
    }
}
