import SwiftUI
import StocksAndChartsKit

struct TokenListView: View {
    let exchange: CryptoExchange
    @State private var tokens: CryptoSymbols?

    var body: some View {
        NavigationStack {
            List(tokens ?? [], id: \.symbol) { token in
                NavigationLink(value: token, label: {
                    Text("Token: \(token.displaySymbol)")
                })
            }
            .navigationDestination(for: CryptoSymbol.self) { token in
                Text(token.displaySymbol)
                    .navigationTitle(token.displaySymbol)
            }
        }
        .task {
            tokens = try? await CryptoManager().symbols(on: exchange)
        }
        .navigationTitle("\(exchange) - Please select token")
    }
}

#Preview {
    TokenListView(exchange: "BINANCE")
}
