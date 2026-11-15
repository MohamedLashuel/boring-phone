import BoringCore
import SwiftUI

/// Tab 3: articles about built-in iOS features.
struct FeaturesView: View {
    let articles: [Article]

    var body: some View {
        NavigationStack {
            List(articles) { article in
                NavigationLink(value: article) {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(article.title)
                            Text(article.summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                    } icon: {
                        Image(systemName: article.symbol)
                    }
                }
            }
            .navigationTitle("Device Features")
            .navigationDestination(for: Article.self, destination: ArticleView.init)
        }
    }
}
