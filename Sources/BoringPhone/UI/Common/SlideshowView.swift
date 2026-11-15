import BoringCore
import SwiftUI

/// Paged slides with a caller-provided footer.
/// The footer receives whether the last slide is showing and a closure to advance.
struct SlideshowView<Footer: View>: View {
    let slides: [Slide]
    @ViewBuilder let footer: (_ isLast: Bool, _ advance: @escaping () -> Void) -> Footer

    @State private var index = 0

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $index) {
                ForEach(Array(slides.enumerated()), id: \.offset) { offset, slide in
                    SlideView(slide: slide).tag(offset)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            footer(index >= slides.count - 1) {
                withAnimation { index = min(index + 1, slides.count - 1) }
            }
            .padding()
        }
    }
}

extension SlideshowView {
    /// A footer that stays the same on every slide.
    init(slides: [Slide], @ViewBuilder footer: @escaping () -> Footer) {
        self.init(slides: slides) { _, _ in footer() }
    }
}

extension SlideshowView where Footer == EmptyView {
    /// Slides with no footer.
    init(slides: [Slide]) {
        self.init(slides: slides) { EmptyView() }
    }
}
