import Foundation
import Testing
@testable import BoringCore

struct ArticleBlockTests {
    func decode(_ json: String) throws -> ArticleBlock {
        try ContentLoader.decode(ArticleBlock.self, from: Data(json.utf8))
    }

    @Test func decodesParagraph() throws {
        #expect(try decode(#"{"type": "paragraph", "text": "Hello"}"#) == .paragraph("Hello"))
    }

    @Test func decodesBullets() throws {
        #expect(try decode(#"{"type": "bullets", "items": ["a", "b"]}"#) == .bullets(["a", "b"]))
    }

    @Test func decodesMedia() throws {
        let block = try decode(#"{"type": "media", "media": {"kind": "animation", "description": "x"}}"#)
        #expect(block == .media(Media(kind: .animation, description: "x")))
    }

    @Test func rejectsUnknownType() {
        #expect(throws: DecodingError.self) { try decode(#"{"type": "video", "text": "x"}"#) }
    }

    @Test func rejectsMissingField() {
        #expect(throws: DecodingError.self) { try decode(#"{"type": "paragraph"}"#) }
    }

    @Test(arguments: [
        ArticleBlock.paragraph("Text"),
        .bullets(["One", "Two"]),
        .media(Media(kind: .image, description: "Pic")),
    ])
    func roundTrips(block: ArticleBlock) throws {
        let data = try JSONEncoder().encode(block)
        #expect(try ContentLoader.decode(ArticleBlock.self, from: data) == block)
    }
}
