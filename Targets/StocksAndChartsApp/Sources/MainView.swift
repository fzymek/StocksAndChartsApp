import SwiftUI
import StocksAndChartsKit

struct MainView: View {

    private let model = Model(a: "Hello, World!!!")

    var body: some View {
        TabView {
            Favourites()
            .tabItem {
                Label("Favourites", systemImage: "star")
            }

            Search()
            .tabItem {
                Label("Search", systemImage: "magnifyingglass.circle")
            }
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


