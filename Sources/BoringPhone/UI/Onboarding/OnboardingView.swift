import BoringCore
import SwiftUI

struct OnboardingView: View {
    let slides: [Slide]
    let finishTitle: String
    let onFinish: () -> Void

    var body: some View {
        SlideshowView(slides: slides) { isLast, advance in
            Button(action: isLast ? onFinish : advance) {
                Text(isLast ? finishTitle : "Next")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }
}
