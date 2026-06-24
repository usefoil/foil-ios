import SwiftUI

struct FoilTranscriptReviewPanel: View {
    let presentation: FoilTranscriptReviewPresentation
    let canRetry: Bool
    let retry: () -> Void
    let reset: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Review transcript", systemImage: "text.quote")
                .font(.headline)

            Text(presentation.guidance)
                .font(.callout)
                .foregroundStyle(.secondary)
                .accessibilityIdentifier("transcript-review-guidance")

            Text(presentation.transcript)
                .font(.body)
                .textSelection(.enabled)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.background, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .strokeBorder(.secondary.opacity(0.24))
                )
                .accessibilityIdentifier("transcript-review-body")

            VStack(alignment: .leading, spacing: 10) {
                Button {
                    retry()
                } label: {
                    Label(presentation.retryTitle, systemImage: "arrow.clockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canRetry)
                .accessibilityIdentifier("transcript-review-retry-recording-button")

                Button {
                    reset()
                } label: {
                    Label(presentation.resetTitle, systemImage: "arrow.counterclockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .accessibilityIdentifier("transcript-review-reset-button")
            }
            .controlSize(.large)
            .labelStyle(.titleAndIcon)
            .buttonBorderShape(.roundedRectangle(radius: 8))
        }
        .padding(14)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(Color.accentColor.opacity(0.28))
        )
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("transcript-review-panel")
    }
}
