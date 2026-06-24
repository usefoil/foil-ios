import SwiftUI

struct FoilAdvancedSupportDisclosure: View {
    @Binding var isExpanded: Bool
    @Binding var secureEntry: String
    let storageReportSummary: String
    let transcriptReviewVisible: Bool
    let lastRecordingName: String?
    let markListening: () -> Void
    let completeFakeTranscript: () -> Void
    let resetSharedState: () -> Void

    private let actionColumns = [
        GridItem(.flexible(minimum: 118), spacing: 10),
        GridItem(.flexible(minimum: 118), spacing: 10)
    ]

    var body: some View {
        DisclosureGroup("Advanced / Support", isExpanded: $isExpanded) {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(FoilDictationLoopPresenter.advancedSupportPresentation()) { item in
                    FoilSetupRow(title: item.title, detail: item.detail, systemImage: item.systemImage)
                }

                Divider()

                Text("Safe test targets")
                    .font(.callout.weight(.semibold))

                ForEach(FoilDictationLoopPresenter.betaGuidancePresentation()) { item in
                    FoilSetupRow(title: item.title, detail: item.detail, systemImage: item.systemImage)
                }

                Divider()

                FoilStatusRow(text: storageReportSummary, systemImage: "externaldrive")
                    .accessibilityIdentifier("keyboard-storage-report-summary")
                if transcriptReviewVisible {
                    FoilStatusRow(text: "Transcript visible in review", systemImage: "text.quote")
                        .accessibilityIdentifier("diagnostics-transcript-review-visible")
                }
                if let lastRecordingName {
                    FoilStatusRow(text: lastRecordingName, systemImage: "waveform.path")
                        .font(.caption.monospaced())
                }

                SecureField("Secure field rejection test", text: $secureEntry)
                    .textContentType(.password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .accessibilityIdentifier("secure-rejection-field")
                    .textFieldStyle(.roundedBorder)

                LazyVGrid(columns: actionColumns, alignment: .leading, spacing: 10) {
                    diagnosticButtons
                }
                .controlSize(.large)
                .labelStyle(.titleAndIcon)
                .buttonBorderShape(.roundedRectangle(radius: 8))
            }
            .padding(.top, 8)
        }
        .accessibilityIdentifier("advanced-support-disclosure")
    }

    @ViewBuilder
    private var diagnosticButtons: some View {
        Button {
            markListening()
        } label: {
            Label("Listening", systemImage: "waveform")
        }
        .buttonStyle(.bordered)
        .accessibilityIdentifier("mark-listening-button")

        Button {
            completeFakeTranscript()
        } label: {
            Label("Complete", systemImage: "checkmark.circle")
        }
        .buttonStyle(.borderedProminent)
        .accessibilityIdentifier("complete-fake-transcript-button")

        Button {
            resetSharedState()
        } label: {
            Label("Reset", systemImage: "arrow.counterclockwise")
        }
        .buttonStyle(.bordered)
        .accessibilityIdentifier("reset-keyboard-state-button")
    }
}
