import BoringCore
import SwiftUI
import WidgetKit

/// The widget extension: every BoringPhone widget, with text from the bundled widgets.json.
@main
struct BoringWidgets: WidgetBundle {
    var body: some Widget {
        ReminderWidget()
        ClockModeWidget()
    }
}

/// Our widgets never change, so a single entry that never refreshes is enough.
struct StaticProvider: TimelineProvider {
    struct Entry: TimelineEntry {
        let date = Date()
    }

    func placeholder(in context: Context) -> Entry { Entry() }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(Entry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        completion(Timeline(entries: [Entry()], policy: .never))
    }
}

/// Widget content, looked up once from the bundled JSON.
private let library = try? ContentLoader.load(WidgetLibrary.self, named: "widgets").get()

extension WidgetID {
    /// A never-refreshing widget whose name, description and text come from widgets.json.
    /// `content` receives the widget's text.
    @MainActor
    func configuration<Content: View>(
        families: [WidgetFamily],
        @ViewBuilder content: @escaping @MainActor (String) -> Content
    ) -> some WidgetConfiguration {
        let info = library?.widget(self)
        return StaticConfiguration(kind: rawValue, provider: StaticProvider()) { _ in
            content(info?.widgetText ?? "")
        }
        .configurationDisplayName(info?.title ?? "")
        .description(info?.description ?? "")
        .supportedFamilies(families)
    }
}

struct ReminderWidget: Widget {
    var body: some WidgetConfiguration {
        WidgetID.reminder.configuration(
            families: [.systemSmall, .systemMedium, .accessoryRectangular, .accessoryInline],
            content: ReminderWidgetView.init
        )
    }
}

struct ClockModeWidget: Widget {
    var body: some WidgetConfiguration {
        WidgetID.clockMode.configuration(families: [.systemSmall, .accessoryCircular, .accessoryRectangular]) { title in
            ClockModeWidgetView(title: title)
                .widgetURL(DeepLink.clockMode.url)
        }
    }
}
