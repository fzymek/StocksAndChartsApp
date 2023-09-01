import Foundation

enum BaseUrl: String {
    case finnhub = "https://finnhub.io/api/v1"
}

enum Endpoint: String {
    case search
}

enum HttpError: Error {
    case invalidUrl
}

protocol HttpService {
    func get<T: Decodable>(endpoint: Endpoint, parameters: [String: String]) async throws -> T
}

struct RestService: HttpService {

    private let baseUrl: BaseUrl
    private let urlSession: URLSession

    static let finnhub = RestService(baseUrl: .finnhub)

    init(baseUrl: BaseUrl, urlSession: URLSession = .shared) {
        self.baseUrl = baseUrl
        self.urlSession = urlSession
    }

    func get<T: Decodable>(endpoint: Endpoint, parameters: [String: String]) async throws -> T {
        guard let url = buildUrl(with: endpoint, params: parameters) else {
            throw HttpError.invalidUrl
        }

        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        request.setValue("cjotn99r01qj85r44mkgcjotn99r01qj85r44ml0", forHTTPHeaderField: "X-Finnhub-Token")

        let (data, response) = try await urlSession.data(for: request)
        print("response: \(String(describing: response))")
        print("data: \(data.prettyPrintedJSONString)")

        return try JSONDecoder().decode(T.self, from: data)
    }

    private func buildUrl(with endpoint: Endpoint, params: [String: String]) -> URL? {
        guard var urlComponents = URLComponents(string: baseUrl.rawValue) else {
            return nil
        }

        urlComponents.queryItems = params.map {
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
