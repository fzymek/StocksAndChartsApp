import SwiftUI
import StocksAndChartsKit

class ExchangeListViewModel: ObservableObject {

    @Published var selectedExchange: CryptoExchange?
    @Published var tokens: CryptoSymbols?

    let exchanges: CryptoExchanges
    private let cryptoManager: CryptoManagable

    init(exchanges: CryptoExchanges, _ manager: CryptoManagable = CryptoManager()) {
        self.exchanges = exchanges
        self.cryptoManager = manager
    }

    func loadSymbols(for exchange: CryptoExchange) {
        Task { @MainActor in
            tokens = try await cryptoManager.symbols(on: exchange)
        }
    }
}

struct ExchangeListView: View {
    @StateObject private var viewModel: ExchangeListViewModel
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @State private var selectedExchange: CryptoExchange?

    init(exchanges: CryptoExchanges) {
        self._viewModel = StateObject(wrappedValue: ExchangeListViewModel(exchanges: exchanges))
    }

    var body: some View {

        NavigationSplitView(columnVisibility: $columnVisibility,
                            sidebar: {

            List(viewModel.exchanges, id: \.self, selection: $selectedExchange) { exchange in
                Text(exchange)
                    .foregroundColor(exchange == selectedExchange ? Color.blue : Color.black)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Select token exchange")

        }, detail: {
            if let selected = selectedExchange {
                TokenListView(exchange: selected)
            } else {
                ContentUnavailableView("No exchange selected", systemImage: "network.slash")
            }
        })

    }

}


struct ExchangeListView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeListView(exchanges: ["BINANCE","Coinbase", "GEMINI", "BITTREX"])
    }
}
