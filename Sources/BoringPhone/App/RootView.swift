import BoringCore
import SwiftUI

/// Shows onboarding on first launch, then the tabbed app.
struct RootView: View {
    let content: AppContent
    let progress: ProgressStore
    let delays: AppDelayStore

    var body: some View {
        Group {
            if progress.hasCompletedOnboarding {
                MainTabView(content: content, progress: progress, delays: delays)
            } else {
                OnboardingView(
                    slides: content.onboarding.slides,
                    finishTitle: "Get Started",
                    onFinish: progress.completeOnboarding
                )
            }
        }
    }
}
