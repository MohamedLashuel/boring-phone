import BoringCore
import SwiftUI

/// Tab 3: widgets the user can add, with walkthroughs for adding them.
struct WidgetsView: View {
    let library: WidgetLibrary

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text(library.intro)
                        .font(.callout)
                    ForEach(library.guides) { guide in
                        NavigationLink(value: guide) {
                            Label(guide.title, systemImage: guide.placement.symbol)
                        }
                    }
                }
                Section("Widgets") {
                    ForEach(library.widgets, content: WidgetRow.init)
                }
            }
            .navigationTitle("Widgets")
            .navigationDestination(for: WidgetGuide.self) { guide in
                SlideshowView(slides: guide.slides)
                    .navigationTitle(guide.title)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct WidgetRow: View {
    let widget: WidgetItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            MediaPlaceholderView(media: widget.media)
            Text(widget.title)
                .font(.headline)
            Text(widget.description)
                .font(.callout)
                .foregroundStyle(.secondary)
            HStack(spacing: 12) {
                ForEach(widget.placements, id: \.self) { placement in
                    Label(placement.title, systemImage: placement.symbol)
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }
}

private extension WidgetPlacement {
    var title: String {
        switch self {
        case .homeScreen: "Home Screen"
        case .lockScreen: "Lock Screen"
        }
    }

    var symbol: String {
        switch self {
        case .homeScreen: "apps.iphone"
        case .lockScreen: "lock.iphone"
        }
    }
}
