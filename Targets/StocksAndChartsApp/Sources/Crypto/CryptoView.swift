import SwiftUI
import StocksAndChartsKit

enum CryptoViewState {
    case loading
    case withData(CryptoExchanges)
    case error
}

class CryptoViewModel: ObservableObject {

    @Published var state: CryptoViewState = .loading
    @Published var selectedExchange: CryptoExchange?

    private let cryptoManager: CryptoManagable

    init(_ manager: CryptoManagable = CryptoManager()) {
        self.cryptoManager = manager
    }

    @MainActor
    func loadExchanges() async {
        do {
            let exchanges = try await cryptoManager.exchanges().sorted(by: <)
            state = .withData(exchanges)
        } catch {
            state = .error
        }
    }
}

struct CryptoView: View {
    @StateObject private var viewModel = CryptoViewModel()

    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView {
                    Text("Loading")
                }
                .progressViewStyle(.circular)
                .scaleEffect(2)
            case .withData(let exchanges):
                ExchangeListView(exchanges: exchanges)
            case .error:
                ContentUnavailableView(label: {
                    Label("Content unavailable", systemImage: "exclamationmark.icloud")
                        .font(.title)
                }, actions:  {
                    Button("Try again") {
                        Task {
                            await viewModel.loadExchanges()
                        }
                    }
                })
            }
        }
        .task {
            await viewModel.loadExchanges()
        }
    }

}


#Preview {
    CryptoView()
}
