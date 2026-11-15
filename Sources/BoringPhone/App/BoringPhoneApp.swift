import BoringCore
import SwiftUI

@main
struct BoringPhoneApp: App {
    private let content = ContentLoader.loadAll()

    @State private var progress = ProgressStore()
    // Swap `.fake` for `.live` once the Family Controls entitlement is available.
    @State private var delays = AppDelayStore(client: .fake)

    var body: some Scene {
        WindowGroup {
            Group {
                switch content {
                case .success(let content):
                    RootView(content: content, progress: progress, delays: delays)
                case .failure(let error):
                    ContentErrorView(message: error.description)
                }
            }
            .onOpenURL(perform: DeepLinkRouter.handle)
        }
    }
}
