import SwiftUI
import StocksAndChartsKit

struct MainView: View {

    var body: some View {
        TabView {

            CryptoView()
            .tabItem {
                Label("Crypto", systemImage: "bitcoinsign.circle")
            }

            Favourites()
            .tabItem {
                Label("Favourites", systemImage: "star")
            }

        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


