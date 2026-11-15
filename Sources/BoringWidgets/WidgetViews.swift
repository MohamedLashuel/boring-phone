import SwiftUI
import WidgetKit

/// Plain text on a black background (Home Screen), or bare text (Lock Screen).
struct ReminderWidgetView: View {
    let text: String
    @Environment(\.widgetFamily) private var family

    var body: some View {
        Group {
            switch family {
            case .accessoryInline:
                Text(text)
            case .accessoryRectangular:
                Text(text)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            default:
                Text(text)
                    .font(.title3.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
            }
        }
        .widgetBackground(family)
    }
}

/// A clock symbol and label; tapping it runs Clock Mode.
struct ClockModeWidgetView: View {
    let title: String
    @Environment(\.widgetFamily) private var family

    var body: some View {
        Group {
            switch family {
            case .accessoryCircular:
                Image(systemName: "clock")
                    .font(.title)
                    .accessibilityLabel(title)
            case .accessoryRectangular:
                Label(title, systemImage: "clock")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            default:
                VStack(spacing: 8) {
                    Image(systemName: "clock")
                        .font(.largeTitle)
                    Text(title)
                        .font(.headline)
                }
                .foregroundStyle(.white)
            }
        }
        .widgetBackground(family)
    }
}

private extension View {
    /// Black on the Home Screen; the system's translucent backdrop on the Lock Screen.
    func widgetBackground(_ family: WidgetFamily) -> some View {
        containerBackground(for: .widget) {
            switch family {
            case .accessoryCircular: AccessoryWidgetBackground()
            case .accessoryInline, .accessoryRectangular: Color.clear
            default: Color.black
            }
        }
    }
}
