import SwiftUI

struct FoilStatusRow: View {
    let text: String
    let systemImage: String

    init(_ text: String, systemImage: String) {
        self.text = text
        self.systemImage = systemImage
    }

    init(text: String, systemImage: String) {
        self.text = text
        self.systemImage = systemImage
    }

    var body: some View {
        Label {
            Text(text)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
        } icon: {
            Image(systemName: systemImage)
        }
    }
}

struct FoilSetupRow: View {
    let title: String
    let detail: String
    let systemImage: String

    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.callout.weight(.semibold))
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)
            }
        } icon: {
            Image(systemName: systemImage)
        }
    }
}

extension FoilLoopTone {
    var color: Color {
        switch self {
        case .ready:
            .accentColor
        case .live:
            .red
        case .working:
            .blue
        case .success:
            .green
        case .attention:
            .orange
        }
    }
}
