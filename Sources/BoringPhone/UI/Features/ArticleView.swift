import BoringCore
import SwiftUI

struct ArticleView: View {
    let article: Article

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                Text(article.summary)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                ForEach(Array(article.sections.enumerated()), id: \.offset) { _, section in
                    ArticleSectionView(section: section)
                }
            }
            .padding()
        }
        .navigationTitle(article.title)
    }
}

struct ArticleSectionView: View {
    let section: ArticleSection

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(section.heading)
                .font(.title2.bold())
            ForEach(Array(section.blocks.enumerated()), id: \.offset) { _, block in
                ArticleBlockView(block: block)
            }
        }
    }
}

struct ArticleBlockView: View {
    let block: ArticleBlock

    var body: some View {
        switch block {
        case .paragraph(let text):
            Text(text)
        case .bullets(let items):
            VStack(alignment: .leading, spacing: 6) {
                ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("•")
                        Text(item)
                    }
                }
            }
        case .media(let media):
            MediaPlaceholderView(media: media)
        }
    }
}
