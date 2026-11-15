import BoringCore
import FamilyControls
import ManagedSettings
import SwiftUI

/// Tab 2: configure which apps get an artificial delay before opening.
struct AppDelaysView: View {
    let settings: AppDelaySettings
    let authorization: ScreenTimeAuthorization
    let errorMessage: String?
    let targetApps: [ApplicationToken]
    let targetCategories: [ActivityCategoryToken]
    let excludedApps: [ApplicationToken]
    @Binding var targets: FamilyActivitySelection
    @Binding var exclusions: FamilyActivitySelection
    let onRequestAuthorization: () -> Void
    let onUpdate: ((AppDelaySettings) -> AppDelaySettings) -> Void

    @State private var isPickingTargets = false
    @State private var isPickingExclusions = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("App Delays puts a short wait in front of the apps you choose. When you open one, you'll see “Open (in \(AppDelaySettings.delaySeconds) seconds)” and have to wait before it unlocks — just long enough to ask yourself whether you really want it.")
                        .font(.callout)
                }

                if authorization != .approved {
                    authorizationSection
                }

                Section {
                    Picker("Delay", selection: Binding(
                        get: { settings.scope },
                        set: { value in onUpdate { $0.with(scope: value) } }
                    )) {
                        Text("None").tag(AppDelaySettings.Scope.none)
                        Text("Selected").tag(AppDelaySettings.Scope.selectedApps)
                        Text("All Except").tag(AppDelaySettings.Scope.allExcept)
                    }
                    .pickerStyle(.segmented)

                    switch settings.scope {
                    case .none:
                        EmptyView()
                    case .selectedApps:
                        pickerRow("Choose apps", count: targetApps.count + targetCategories.count) { isPickingTargets = true }
                        ForEach(targetCategories, id: \.self) { Label($0) }
                        ForEach(targetApps, id: \.self) { Label($0) }
                    case .allExcept:
                        pickerRow("Exclusions", count: excludedApps.count) { isPickingExclusions = true }
                        ForEach(excludedApps, id: \.self) { Label($0) }
                    }
                } header: {
                    Text("Apps to delay")
                } footer: {
                    Text(scopeFooter)
                }
                .disabled(authorization != .approved)

                Section {
                    Stepper(
                        "Stay open for \(settings.unlockMinutes) min",
                        value: Binding(
                            get: { settings.unlockMinutes },
                            set: { value in onUpdate { $0.with(unlockMinutes: value) } }
                        ),
                        in: 5...120,
                        step: 5
                    )
                } footer: {
                    Text("After waiting, the app stays unlocked for this long.")
                }
                .disabled(authorization != .approved)
            }
            .navigationTitle("App Delays")
            .familyActivityPicker(isPresented: $isPickingTargets, selection: $targets)
            .familyActivityPicker(isPresented: $isPickingExclusions, selection: $exclusions)
        }
    }

    private var scopeFooter: String {
        switch settings.scope {
        case .none: "No apps are delayed."
        case .selectedApps: "Only the apps and categories you choose are delayed."
        case .allExcept: "Every app is delayed except the ones you exclude. Only individual apps can be excluded, not categories."
        }
    }

    private var authorizationSection: some View {
        Section {
            Button("Allow Screen Time Access", action: onRequestAuthorization)
            errorMessage.map { Text($0).font(.caption).foregroundStyle(.red) }
        } footer: {
            Text(authorization == .denied
                 ? "Access was denied. You can allow it again here or in Settings › Screen Time."
                 : "App Delays uses Screen Time to place a shield over apps.")
        }
    }

    private func pickerRow(_ title: String, count: Int, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                Text(count == 0 ? "None" : "\(count) selected")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
