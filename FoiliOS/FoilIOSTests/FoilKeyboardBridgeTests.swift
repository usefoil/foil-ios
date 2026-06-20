import XCTest
@testable import FoilIOS

final class FoilKeyboardBridgeTests: XCTestCase {
    private var bridge: FoilKeyboardBridge!

    override func setUp() {
        super.setUp()
        bridge = FoilKeyboardBridge()
        bridge.reset()
    }

    override func tearDown() {
        bridge.reset()
        bridge = nil
        super.tearDown()
    }

    func testConsumeTranscriptForInsertionReturnsTranscriptOnceAndClearsSharedState() {
        bridge.complete(transcript: "Foil one shot insert", message: "Ready")

        XCTAssertEqual(bridge.consumeTranscriptForInsertion(), "Foil one shot insert")
        let firstInsertReport = bridge.storageReport()
        XCTAssertEqual(firstInsertReport.operation, "insert")
        XCTAssertEqual(firstInsertReport.consumedPhase, .complete)
        XCTAssertEqual(firstInsertReport.consumedHadInsertableTranscript, true)
        XCTAssertEqual(firstInsertReport.insertedCharacterCount, "Foil one shot insert".count)
        XCTAssertFalse(encodedReport(firstInsertReport).contains("Foil one shot insert"))

        XCTAssertNil(bridge.consumeTranscriptForInsertion())
        let duplicateInsertReport = bridge.storageReport()
        XCTAssertEqual(duplicateInsertReport.operation, "insert")
        XCTAssertEqual(duplicateInsertReport.consumedPhase, .idle)
        XCTAssertEqual(duplicateInsertReport.consumedHadInsertableTranscript, false)
        XCTAssertEqual(duplicateInsertReport.insertedCharacterCount, 0)

        let snapshot = bridge.load()
        XCTAssertEqual(snapshot.phase, .idle)
        XCTAssertNil(snapshot.transcript)
    }

    func testConsumeTranscriptForInsertionIgnoresEmptyTranscript() {
        bridge.complete(transcript: "   ", message: "Ready")

        XCTAssertNil(bridge.consumeTranscriptForInsertion())

        XCTAssertEqual(bridge.load().phase, .idle)
        let report = bridge.storageReport()
        XCTAssertEqual(report.operation, "insert")
        XCTAssertEqual(report.consumedPhase, .complete)
        XCTAssertEqual(report.consumedHadInsertableTranscript, false)
        XCTAssertEqual(report.insertedCharacterCount, 0)
    }

    func testConsumeTranscriptForInsertionIgnoresStaleCompleteTranscript() {
        bridge.save(
            FoilKeyboardSnapshot(
                phase: .complete,
                transcript: "stale transcript",
                message: "Old transcript",
                updatedAt: Date(timeIntervalSince1970: 100)
            )
        )

        XCTAssertNil(
            bridge.consumeTranscriptForInsertion(
                now: Date(timeIntervalSince1970: 500),
                staleAfter: 120
            )
        )
        XCTAssertEqual(bridge.load().phase, .idle)
        XCTAssertNil(bridge.load().transcript)
        XCTAssertEqual(bridge.storageReport().operation, "insert")
    }

    func testConsumeTranscriptForInsertionIgnoresNonCompleteLeftoverTranscripts() {
        let phases: [FoilKeyboardPhase] = [.idle, .handoffRequested, .listening, .processing, .failed]

        for phase in phases {
            bridge.save(
                FoilKeyboardSnapshot(
                    phase: phase,
                    transcript: "leftover transcript",
                    message: "Leftover \(phase.rawValue)",
                    updatedAt: Date()
                )
            )

            XCTAssertNil(bridge.consumeTranscriptForInsertion(), "Expected \(phase.rawValue) to be non-insertable.")
            XCTAssertEqual(bridge.load().phase, .idle)
            XCTAssertNil(bridge.load().transcript)
            let report = bridge.storageReport()
            XCTAssertEqual(report.operation, "insert")
            XCTAssertEqual(report.consumedPhase, phase)
            XCTAssertEqual(report.consumedHadInsertableTranscript, false)
            XCTAssertEqual(report.insertedCharacterCount, 0)
            XCTAssertFalse(encodedReport(report).contains("leftover transcript"))
        }
    }

    func testResetClearsProcessingSnapshotAndReportsIdleSharedState() {
        bridge.save(
            FoilKeyboardSnapshot(
                phase: .processing,
                transcript: nil,
                message: "Transcribing",
                updatedAt: Date()
            )
        )

        bridge.reset()

        let snapshot = bridge.load()
        XCTAssertEqual(snapshot.phase, .idle)
        XCTAssertNil(snapshot.transcript)

        let report = bridge.storageReport()
        XCTAssertEqual(report.operation, "reset")
        XCTAssertEqual(report.phase, .idle)
        XCTAssertFalse(report.hasTranscript)
        XCTAssertEqual(report.canonicalVerificationPhase, .idle)
        XCTAssertEqual(report.canonicalVerificationHasTranscript, false)
    }

    func testStorageReportDecodesLegacyPayloadWithoutInsertionReceipt() throws {
        let payload = """
        {
          "operation": "insert",
          "phase": "idle",
          "hasTranscript": false,
          "canonicalPath": null,
          "canonicalWriteSucceeded": true,
          "canonicalWriteError": null,
          "canonicalVerificationPhase": "idle",
          "canonicalVerificationHasTranscript": false,
          "defaultsWriteAttempted": true,
          "fallbackRemovalResults": [],
          "updatedAt": 0
        }
        """.data(using: .utf8)!

        let report = try JSONDecoder().decode(FoilKeyboardStorageReport.self, from: payload)

        XCTAssertNil(report.consumedPhase)
        XCTAssertNil(report.consumedHadInsertableTranscript)
        XCTAssertNil(report.insertedCharacterCount)
    }

    func testInsertableTranscriptRequiresCompleteNonEmptyTranscript() {
        XCTAssertEqual(
            FoilKeyboardSnapshot(
                phase: .complete,
                transcript: "  ready to insert  ",
                message: "Ready",
                updatedAt: Date()
            ).insertableTranscript(),
            "ready to insert"
        )

        XCTAssertNil(
            FoilKeyboardSnapshot(
                phase: .complete,
                transcript: "   ",
                message: "Ready",
                updatedAt: Date()
            ).insertableTranscript()
        )

        XCTAssertNil(
            FoilKeyboardSnapshot(
                phase: .failed,
                transcript: "leftover transcript",
                message: "Failed",
                updatedAt: Date()
            ).insertableTranscript()
        )
    }

    func testInsertableTranscriptRejectsStaleCompleteTranscript() {
        let snapshot = FoilKeyboardSnapshot(
            phase: .complete,
            transcript: "ready earlier",
            message: "Ready",
            updatedAt: Date(timeIntervalSince1970: 100)
        )

        XCTAssertEqual(
            snapshot.insertableTranscript(
                now: Date(timeIntervalSince1970: 200),
                staleAfter: 120
            ),
            "ready earlier"
        )
        XCTAssertNil(
            snapshot.insertableTranscript(
                now: Date(timeIntervalSince1970: 500),
                staleAfter: 120
            )
        )
    }

    private func encodedReport(_ report: FoilKeyboardStorageReport) -> String {
        let data = try! JSONEncoder().encode(report)
        return String(data: data, encoding: .utf8)!
    }
}
