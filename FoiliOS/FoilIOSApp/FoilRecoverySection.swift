import SwiftUI

struct FoilRecoverySection<ProviderEditor: View>: View {
    let message: String
    let showsProviderKeyRecovery: Bool
    let keyboardRecoverySteps: [String]
    let canRetryTranscription: Bool
    let retryTranscription: () -> Void
    let resetSharedState: () -> Void
    @ViewBuilder let providerCredentialEditor: () -> ProviderEditor

    private let actionColumns = [
        GridItem(.flexible(minimum: 118), spacing: 10),
        GridItem(.flexible(minimum: 118), spacing: 10)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recovery")
                .font(.headline)
            FoilStatusRow(message, systemImage: "exclamationmark.arrow.triangle.2.circlepath")
                .font(.callout)

            if showsProviderKeyRecovery {
                FoilSetupRow(
                    title: "Update provider key",
                    detail: "A saved key is not provider-verified until transcription succeeds.",
                    systemImage: "key.fill"
                )
                providerCredentialEditor()
            }

            FoilKeyboardRecoveryChecklist(steps: keyboardRecoverySteps)
            FoilTestedTargetsPanel()

            LazyVGrid(columns: actionColumns, alignment: .leading, spacing: 10) {
                if canRetryTranscription {
                    Button {
                        retryTranscription()
                    } label: {
                        Label("Retry transcription", systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityIdentifier("retry-transcription-button")
                }

                Button {
                    resetSharedState()
                } label: {
                    Label("Reset shared state", systemImage: "arrow.counterclockwise")
                }
                .buttonStyle(.bordered)
                .accessibilityIdentifier("recovery-reset-shared-state-button")
            }
            .controlSize(.large)
            .labelStyle(.titleAndIcon)
            .buttonBorderShape(.roundedRectangle(radius: 8))
        }
    }
}
