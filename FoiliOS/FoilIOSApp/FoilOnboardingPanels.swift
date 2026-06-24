import SwiftUI

struct FoilProviderCredentialEditor: View {
    @Binding var providerKeyEntry: String
    let message: String
    let hasConfiguredAPIKey: Bool
    let save: () -> Void
    let clear: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SecureField("Groq API key", text: $providerKeyEntry)
                .textContentType(.password)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .accessibilityIdentifier("provider-key-field")

            HStack(spacing: 10) {
                Button {
                    save()
                } label: {
                    Label("Save key", systemImage: "key")
                }
                .buttonStyle(.borderedProminent)
                .disabled(providerKeyEntry.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .accessibilityIdentifier("save-provider-key-button")

                Button {
                    clear()
                } label: {
                    Label("Clear key", systemImage: "trash")
                }
                .buttonStyle(.bordered)
                .disabled(!hasConfiguredAPIKey)
                .accessibilityIdentifier("clear-provider-key-button")
            }

            if !message.isEmpty {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("provider-credential-message")
            }
        }
        .accessibilityElement(children: .contain)
    }
}

struct FoilRouteChoiceButton: View {
    let route: FoilSetupRoutePresentation
    @Binding var selectedRouteID: String

    var body: some View {
        Button {
            selectedRouteID = route.routeID
        } label: {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: selectedRouteID == route.routeID ? "checkmark.circle.fill" : route.systemImage)
                    .foregroundStyle(selectedRouteID == route.routeID ? Color.accentColor : Color.secondary)
                    .frame(width: 22)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(route.title)
                            .font(.callout.weight(.semibold))
                        Text(route.badge)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(route.isUsableNow ? .green : .orange)
                    }
                    Text(route.detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
        .padding(10)
        .background(.background.opacity(0.6), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(selectedRouteID == route.routeID ? Color.accentColor.opacity(0.5) : Color.secondary.opacity(0.18))
        )
        .accessibilityIdentifier("route-choice-\(route.routeID)")
    }
}

struct FoilSetupReadinessPanel: View {
    let presentation: FoilSetupReadinessPresentation

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label {
                VStack(alignment: .leading, spacing: 4) {
                    Text(presentation.title)
                        .font(.callout.weight(.semibold))
                    Text(presentation.detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                        .minimumScaleFactor(0.8)
                }
            } icon: {
                Image(systemName: presentation.systemImage)
            }

            Text(presentation.nextAction)
                .font(.caption.weight(.semibold))
                .foregroundStyle(presentation.tone.color)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
                .accessibilityIdentifier("setup-readiness-next-action")
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(presentation.tone.color.opacity(0.10), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(presentation.tone.color.opacity(0.28))
        )
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("setup-readiness-summary")
    }
}

struct FoilReadinessPanel: View {
    let onboardingReadiness: FoilOnboardingReadinessPresentation

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            FoilStatusRow(text: onboardingReadiness.detail, systemImage: onboardingReadiness.systemImage)
                .foregroundStyle(onboardingReadiness.isComplete ? .green : .primary)

            if !onboardingReadiness.blockers.isEmpty {
                ForEach(onboardingReadiness.blockers, id: \.self) { blocker in
                    Label(blocker, systemImage: "circle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(10)
        .background(.background.opacity(0.55), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .accessibilityIdentifier(onboardingReadiness.isComplete ? "onboarding-ready" : "onboarding-not-ready")
    }
}

struct FoilTestedTargetsPanel: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Where to test")
                .font(.callout.weight(.semibold))
            ForEach(FoilDictationLoopPresenter.betaGuidancePresentation()) { item in
                FoilSetupRow(title: item.title, detail: item.detail, systemImage: item.systemImage)
            }
        }
        .padding(10)
        .background(.background.opacity(0.55), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .accessibilityIdentifier("tested-target-guidance")
    }
}

struct FoilKeyboardRecoveryChecklist: View {
    let steps: [String]

    var body: some View {
        if !steps.isEmpty {
            VStack(alignment: .leading, spacing: 6) {
                ForEach(steps, id: \.self) { step in
                    Label(step, systemImage: "checkmark.circle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .accessibilityIdentifier("keyboard-recovery-checklist")
        }
    }
}

struct FoilRouteFirstOnboardingPanel<ProviderEditor: View>: View {
    @Binding var selectedRouteID: String
    let setupReadiness: FoilSetupReadinessPresentation
    let onboardingReadiness: FoilOnboardingReadinessPresentation
    let microphonePermissionSummary: String
    let providerCredentialSummary: String
    let hasConfiguredAPIKey: Bool
    let keyboardFullAccessEnabled: Bool
    let keyboardHealthSummary: String
    let storageHealthSummary: String
    let resetSharedState: () -> Void
    @ViewBuilder let providerCredentialEditor: () -> ProviderEditor

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Choose your setup route")
                    .font(.headline)
                Text("For this beta, finish setup with an API key on this iPhone. The Mac path stays visible as the future route.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 8) {
                ForEach(FoilDictationLoopPresenter.routeChoicePresentation()) { route in
                    FoilRouteChoiceButton(route: route, selectedRouteID: $selectedRouteID)
                }
            }

            Divider()

            selectedRouteDetails
        }
        .font(.callout)
        .padding(14)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(.secondary.opacity(0.18))
        )
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("route-first-onboarding")
    }

    @ViewBuilder
    private var selectedRouteDetails: some View {
        switch selectedRouteID {
        case FoilDictationLoopPresenter.macRouteID:
            macRouteDetails
        case FoilDictationLoopPresenter.advancedRouteID:
            advancedRouteDetails
        default:
            iPhoneAPIKeyRouteDetails
        }
    }

    private var macRouteDetails: some View {
        let preview = FoilDictationLoopPresenter.macPairingPreviewPresentation()

        return VStack(alignment: .leading, spacing: 12) {
            FoilSetupRow(
                title: preview.title,
                detail: preview.detail,
                systemImage: "desktopcomputer"
            )
            FoilSetupRow(
                title: "Bridge contract",
                detail: preview.contractDetail,
                systemImage: "point.3.connected.trianglepath.dotted"
            )
            FoilSetupRow(
                title: preview.receiptName,
                detail: preview.receiptDetail,
                systemImage: "doc.text.magnifyingglass"
            )
            FoilReadinessPanel(onboardingReadiness: onboardingReadiness)
            Button {
                selectedRouteID = FoilDictationLoopPresenter.iPhoneAPIKeyRouteID
            } label: {
                Label(preview.fallbackTitle, systemImage: "iphone.gen3")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .buttonBorderShape(.roundedRectangle(radius: 8))
            .accessibilityIdentifier("select-iphone-api-route-button")
        }
    }

    private var iPhoneAPIKeyRouteDetails: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(FoilDictationLoopPresenter.iPhoneAPIKeySetupPresentation()) { item in
                    FoilSetupRow(title: item.title, detail: item.detail, systemImage: item.systemImage)
                }
            }

            Divider()

            Text("Current status")
                .font(.callout.weight(.semibold))

            FoilSetupReadinessPanel(presentation: setupReadiness)
            FoilTestedTargetsPanel()

            FoilSetupRow(
                title: "Microphone",
                detail: microphonePermissionSummary,
                systemImage: "mic"
            )
            FoilSetupRow(
                title: "Provider route",
                detail: providerCredentialSummary,
                systemImage: hasConfiguredAPIKey ? "key.fill" : "key"
            )
            providerCredentialEditor()
            FoilSetupRow(
                title: "Keyboard health",
                detail: keyboardHealthSummary,
                systemImage: keyboardFullAccessEnabled ? "checkmark.circle" : "exclamationmark.circle"
            )
            FoilSetupRow(
                title: "Shared state",
                detail: storageHealthSummary,
                systemImage: "externaldrive"
            )

            FoilReadinessPanel(onboardingReadiness: onboardingReadiness)

            Button {
                resetSharedState()
            } label: {
                Label("Reset shared state", systemImage: "arrow.counterclockwise")
            }
            .buttonStyle(.bordered)
            .accessibilityIdentifier("setup-reset-shared-state-button")
        }
    }

    private var advancedRouteDetails: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(FoilDictationLoopPresenter.advancedSupportPresentation()) { item in
                FoilSetupRow(title: item.title, detail: item.detail, systemImage: item.systemImage)
            }
            FoilSetupRow(
                title: "Support tools",
                detail: "Open Advanced / Support below for diagnostics, fake transcript staging, secure-field checks, and safe target notes.",
                systemImage: "chevron.down.circle"
            )
            FoilReadinessPanel(onboardingReadiness: onboardingReadiness)
        }
    }
}
