import Foundation

public protocol CryptoManagable {
    func exchanges() async throws -> CryptoExchanges
    func symbols(on: CryptoExchange) async throws -> CryptoSymbols
}

public actor CryptoManager: CryptoManagable {

    private let httpService: HttpService

    public init() {
        self.init(httpService: RestService.finnhub)
    }

    init(httpService: HttpService) {
        self.httpService = httpService
    }

    public func exchanges() async throws -> CryptoExchanges {
        try await httpService.get(endpoint: .cryptoExchanges)
    }

    public func symbols(on exchange: CryptoExchange) async throws -> CryptoSymbols {
        try await httpService.get(endpoint: .cryptoSymbols(exchange: exchange))
    }

}
