import SwiftUI
import StocksAndChartsKit

final class SearchViewModel: ObservableObject {
    @Published var searchResult: StockSearchResponse?
    @Published var searchText: String = ""

    func search() {
        guard !searchText.isEmpty else {
            searchResult = nil
            return
        }
        Task {
            let searchable = StockSearchableManager()
            searchResult = try? await searchable.findStock(withQuery: searchText)
        }
    }
}

struct Search: View {

    @StateObject var viewModel = SearchViewModel()

    var body: some View {
        NavigationSplitView {
            if let results = viewModel.searchResult?.result, results.count > 0 {
                List(results, id: \.symbol) { item in
                    HStack {
                        Text(item.description)
                        Spacer()
                        Text(item.symbol)
                    }
                }
            } else {
                Text("No results")
            }
        } detail: {
            Text("Details")
        }
        .searchable(text: $viewModel.searchText, prompt: "Stock name or symbol")
        .onReceive(viewModel.$searchText.debounce(for: 0.5, scheduler: DispatchQueue.main),
                   perform: { _ in
            viewModel.search()
        })
    }
}


struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
