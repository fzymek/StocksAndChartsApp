import Foundation


public protocol StockSearchable {
    func findStock(withQuery query: String) async throws -> StockSearchResponse
}


public struct StockSearchableManager: StockSearchable {

    private let httpService: HttpService

    public init() {
        self.init(httpService: RestService.finnhub)
    }

    init(httpService: HttpService) {
        self.httpService = httpService
    }

    public func findStock(withQuery query: String) async throws -> StockSearchResponse {
        return try await httpService.get(endpoint: .search, parameters: ["q": query])
    }

}
