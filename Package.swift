// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BoringPhone",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // The main app; xtool.yml names it as `product`.
        .library(
            name: "BoringPhone",
            targets: ["BoringPhone"]
        ),
        // The widget extension, declared in xtool.yml.
        .library(
            name: "BoringWidgets",
            targets: ["BoringWidgets"]
        ),
    ],
    targets: [
        // The iOS app: UI, stores, and system integrations.
        .target(
            name: "BoringPhone",
            dependencies: ["BoringCore"]
        ),
        // Home and Lock Screen widgets.
        .target(
            name: "BoringWidgets",
            dependencies: ["BoringCore"],
            linkerSettings: [
                // xtool links extensions with `-e _NSExtensionMain` (correct: WidgetKit needs that entry
                // point) plus `-dead_strip`, which strips the unreferenced Swift `@main` WidgetBundle
                // entirely (empty binary → "Can't find free space of LoadCommands for CodeSignature!").
                // `-u _main` keeps the Swift entry and everything it uses. Using `-e _main` instead
                // crashes at launch in `_EXRunningExtension._shared`. See xtool-org/xtool#313.
                .unsafeFlags(["-Xlinker", "-u", "-Xlinker", "_main"]),
            ]
        ),
        // Models, pure logic, and app content. Foundation only, so it builds and tests on any platform.
        .target(
            name: "BoringCore",
            resources: [
                // App content (guide tasks, articles, onboarding) lives here as JSON.
                .copy("Content"),
            ]
        ),
        .testTarget(
            name: "BoringCoreTests",
            dependencies: ["BoringCore"]
        ),
    ]
)
