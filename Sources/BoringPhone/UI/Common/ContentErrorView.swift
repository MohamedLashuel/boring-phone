import BoringCore
import SwiftUI

struct ContentErrorView: View {
    let message: String

    var body: some View {
        ContentUnavailableView(
            "Couldn't load content",
            systemImage: "exclamationmark.triangle",
            description: Text(message)
        )
    }
}
