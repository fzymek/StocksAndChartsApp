import Foundation

enum BaseUrl: String {
    case finnhub = "https://finnhub.io/api/v1"
}

enum Endpoint: RawRepresentable {
    typealias RawValue = String

    case search(q: String)
    case cryptoExchanges
    case cryptoSymbols(exchange: String)
    case cyptoCandles(symbol: String /*,resolution: String = "D"*/, from: Date, to: Date)

    init?(rawValue: String) {
        fatalError("not implemented")
    }

    var rawValue: String {
        switch self {
        case .search:
            return "search"
        case .cryptoExchanges:
            return "crypto/exchange"
        case .cryptoSymbols:
            return "crypto/symbol"
        case .cyptoCandles:
            return "crypto/candle"
        }
    }

    var params: [String: String] {
        switch self {
        case .search(let query):
            return ["q":query]
        case .cryptoExchanges:
            return [:]
        case .cryptoSymbols(let exchange):
            return ["exchange": exchange]
        case .cyptoCandles(let symbol, /*let resolution,*/ let from, let to):
            return [
                "symbol": symbol,
                "resolution": "D",
                "from": "\(from.timeIntervalSince1970)",
                "to": "\(to.timeIntervalSince1970)"
            ]
        }
    }
}

enum HttpError: Error {
    case invalidUrl
}

protocol HttpService {
    func get<T: Decodable>(endpoint: Endpoint) async throws -> T
}

//extension HttpService {
//    func get<T: Decodable>(endpoint: Endpoint) async throws -> T {
//        try await get(endpoint: endpoint, parameters: nil)
//    }
//}

struct RestService: HttpService {

    private let baseUrl: BaseUrl
    private let urlSession: URLSession

    static let finnhub = RestService(baseUrl: .finnhub)

    init(baseUrl: BaseUrl, urlSession: URLSession = .shared) {
        self.baseUrl = baseUrl
        self.urlSession = urlSession
    }

    func get<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let url = buildUrl(with: endpoint) else {
            throw HttpError.invalidUrl
        }

        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        request.setValue("cjotn99r01qj85r44mkgcjotn99r01qj85r44ml0", forHTTPHeaderField: "X-Finnhub-Token")
        print("request: \(request), headers: \(request.allHTTPHeaderFields ?? [:])")

        let (data, response) = try await urlSession.data(for: request)
//        print("response: \(String(describing: response))")
//        print("data: \(String(describing: data.prettyPrintedJSONString))")

        return try JSONDecoder().decode(T.self, from: data)
    }

    private func buildUrl(with endpoint: Endpoint) -> URL? {
        guard var urlComponents = URLComponents(string: baseUrl.rawValue) else {
            return nil
        }

        urlComponents.queryItems = endpoint.params.map {
            return URLQueryItem(name: $0, value: $1)
        }

        guard var url = urlComponents.url else {
            return nil
        }

        url.appendPathComponent(endpoint.rawValue)
        return url
    }

}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
