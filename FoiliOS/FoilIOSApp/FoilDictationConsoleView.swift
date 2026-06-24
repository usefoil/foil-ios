import SwiftUI

struct FoilDictationConsoleView: View {
    let stage: FoilAppLoopPresentation
    let snapshotMessage: String
    let audioStatus: String
    let transcriptionStatus: String
    let isRecording: Bool
    let hasSavedRecording: Bool
    let performPrimary: (FoilAppPrimaryAction) -> Void
    let performSecondary: (FoilAppSecondaryAction) -> Void
    let startRecording: () -> Void
    let stopRecording: () -> Void
    let cancelRecording: () -> Void
    let transcribeLatest: () -> Void

    private let actionColumns = [
        GridItem(.flexible(minimum: 118), spacing: 10),
        GridItem(.flexible(minimum: 118), spacing: 10)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Label(stage.title, systemImage: stage.systemImage)
                    .font(.headline)
                Spacer(minLength: 8)
                Text(stage.badge)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(stage.tone.color)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(stage.tone.color.opacity(0.12), in: Capsule())
            }

            Text(stage.detail)
                .font(.callout)
                .foregroundStyle(.secondary)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
                .accessibilityIdentifier("dictation-stage-detail")

            if let primaryAction = stage.primaryAction {
                Button {
                    performPrimary(primaryAction)
                } label: {
                    Label(primaryAction.title, systemImage: primaryAction.systemImage)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .buttonBorderShape(.roundedRectangle(radius: 8))
                .accessibilityIdentifier(primaryAction.accessibilityIdentifier)
            }

            if let secondaryAction = stage.secondaryAction {
                Button {
                    performSecondary(secondaryAction)
                } label: {
                    Label(secondaryAction.title, systemImage: secondaryAction.systemImage)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .buttonBorderShape(.roundedRectangle(radius: 8))
                .accessibilityIdentifier(secondaryAction.accessibilityIdentifier)
            }

            VStack(alignment: .leading, spacing: 10) {
                FoilStatusRow(text: snapshotMessage, systemImage: "keyboard")
                FoilStatusRow(text: audioStatus, systemImage: "mic")
                FoilStatusRow(text: transcriptionStatus, systemImage: "text.bubble")
            }
            .font(.callout)
            .accessibilityIdentifier("dictation-status-stack")

            LazyVGrid(columns: actionColumns, alignment: .leading, spacing: 10) {
                recordingButtons
            }
            .controlSize(.regular)
            .labelStyle(.titleAndIcon)
            .buttonBorderShape(.roundedRectangle(radius: 8))
        }
        .padding(14)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(stage.tone.color.opacity(0.28))
        )
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("dictation-console")
    }

    @ViewBuilder
    private var recordingButtons: some View {
        Button {
            startRecording()
        } label: {
            Label("Record", systemImage: "record.circle")
        }
        .buttonStyle(.borderedProminent)
        .disabled(isRecording)
        .accessibilityIdentifier("start-recording-button")

        Button {
            stopRecording()
        } label: {
            Label("Stop", systemImage: "stop.circle")
        }
        .buttonStyle(.bordered)
        .disabled(!isRecording)
        .accessibilityIdentifier("stop-recording-button")

        Button {
            cancelRecording()
        } label: {
            Label("Cancel", systemImage: "xmark.circle")
        }
        .buttonStyle(.bordered)
        .disabled(!isRecording)
        .accessibilityIdentifier("cancel-recording-button")

        Button {
            transcribeLatest()
        } label: {
            Label("Transcribe", systemImage: "text.bubble")
        }
        .buttonStyle(.bordered)
        .disabled(!hasSavedRecording || isRecording)
        .accessibilityIdentifier("transcribe-latest-button")
    }
}
