import BoringCore
import SwiftUI

/// Stand-in for an image or animation that hasn't been produced yet.
struct MediaPlaceholderView: View {
    let media: Media

    var body: some View {
        VStack(spacing: 8) {
            Label(
                media.kind == .animation ? "Animation" : "Image",
                systemImage: media.kind == .animation ? "play.rectangle" : "photo"
            )
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            Text(media.description)
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 180)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                .foregroundStyle(.tertiary)
        )
    }
}
