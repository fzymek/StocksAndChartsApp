import SwiftUI
import StocksAndChartsKit

@main
struct StocksAndChartsAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    private let model = Model(a: "Hello, World!!!")
    var body: some View {
        VStack {
            Text(model.a)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

