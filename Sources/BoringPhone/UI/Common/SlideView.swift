import BoringCore
import SwiftUI

struct SlideView: View {
    let slide: Slide

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                slide.media.map(MediaPlaceholderView.init)
                Text(slide.title)
                    .font(.title2.bold())
                Text(slide.body)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}
