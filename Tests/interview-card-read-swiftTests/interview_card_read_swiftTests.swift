import XCTest
@testable import interview_card_read_swift

final class interview_card_read_swiftTests: XCTestCase {
    func testNoInvalids() {
        var (entries, exits) = CardReader().getInvalidLogs([])
        XCTAssertTrue(entries.isEmpty)
        XCTAssertTrue(exits.isEmpty)
        
        (entries, exits) = CardReader().getInvalidLogs([
            ScanRecord(employee: "Paul", scan: .ENTER),
            ScanRecord(employee: "Paul", scan: .EXIT),
            ScanRecord(employee: "Paul", scan: .ENTER),
            ScanRecord(employee: "Paul", scan: .EXIT),
            ScanRecord(employee: "Mary", scan: .ENTER),
            ScanRecord(employee: "Mary", scan: .EXIT)
        ])

        XCTAssertTrue(entries.isEmpty)
        XCTAssertTrue(exits.isEmpty)
    }
    
    func testFaultyExits() {
        let (entries, exits) = CardReader().getInvalidLogs([
            ScanRecord(employee: "Paul", scan: .ENTER),
            ScanRecord(employee: "Mary", scan: .ENTER),
            ScanRecord(employee: "Mary", scan: .EXIT),
            ScanRecord(employee: "Paul", scan: .ENTER),
            ScanRecord(employee: "Paul", scan: .EXIT)
        ])

        XCTAssertTrue(entries.isEmpty)
        XCTAssertTrue(exits == ["Paul"])
    }
    
    func testFaultyEntries() {
        let (entries, exits) = CardReader().getInvalidLogs([
            ScanRecord(employee: "Paul", scan: .EXIT),
            ScanRecord(employee: "Mary", scan: .ENTER),
            ScanRecord(employee: "Mary", scan: .EXIT),
            ScanRecord(employee: "Gregory", scan: .EXIT),
            ScanRecord(employee: "Mary", scan: .ENTER),
            ScanRecord(employee: "Mary", scan: .EXIT),
            ScanRecord(employee: "Gregory", scan: .ENTER),
            ScanRecord(employee: "Gregory", scan: .EXIT),
        ])

        XCTAssertTrue(entries.sorted() { $0 < $1 } == ["Gregory", "Paul"])
        XCTAssertTrue(exits.isEmpty)
    }
    
    func testFaultyEntriesAndExits() {
        let (entries, exits) = CardReader().getInvalidLogs([
            ScanRecord(employee: "Paul", scan: .EXIT),
            ScanRecord(employee: "Mary", scan: .ENTER),
            ScanRecord(employee: "Mary", scan: .EXIT),
            ScanRecord(employee: "Ignatius", scan: .EXIT),
            ScanRecord(employee: "Benedict", scan: .ENTER),
            ScanRecord(employee: "Benedict", scan: .ENTER),
            ScanRecord(employee: "Benedict", scan: .EXIT),
            ScanRecord(employee: "Mary", scan: .ENTER),
            ScanRecord(employee: "Mary", scan: .EXIT),
            ScanRecord(employee: "Ignatius", scan: .ENTER),
        ])

        XCTAssertTrue(entries.sorted() { $0 < $1 } == ["Ignatius", "Paul"])
        XCTAssertTrue(exits.sorted() { $0 < $1 } == ["Benedict", "Ignatius"])
    }
    
    func testOnlyOneFaultyExitPerEmployee() {
        let (entries, exits) = CardReader().getInvalidLogs([
            ScanRecord(employee: "Paul", scan: .ENTER),
            ScanRecord(employee: "Paul", scan: .ENTER),
            ScanRecord(employee: "Paul", scan: .EXIT),
            ScanRecord(employee: "Paul", scan: .ENTER),
        ])

        XCTAssertTrue(entries.isEmpty)
        XCTAssertTrue(exits.count == 1)
        XCTAssertTrue(exits == ["Paul"])
    }
    
    func testOnlyOneFaultyEntryPerEmployee() {
        let (entries, exits) = CardReader().getInvalidLogs([
            ScanRecord(employee: "Paul", scan: .EXIT),
            ScanRecord(employee: "Paul", scan: .ENTER),
            ScanRecord(employee: "Paul", scan: .EXIT),
            ScanRecord(employee: "Paul", scan: .EXIT),
            ScanRecord(employee: "Paul", scan: .ENTER),
            ScanRecord(employee: "Paul", scan: .EXIT),
        ])

        XCTAssertTrue(entries.count == 1)
        XCTAssertTrue(entries == ["Paul"])
        XCTAssertTrue(exits.isEmpty)
    }
    
    func testOnlyOneFaultyEntryAndExitPerEmployee() {
        let (entries, exits) = CardReader().getInvalidLogs([
            ScanRecord(employee: "Paul", scan: .EXIT),
            ScanRecord(employee: "Paul", scan: .ENTER),
            ScanRecord(employee: "Paul", scan: .EXIT),
            ScanRecord(employee: "Paul", scan: .EXIT),
            ScanRecord(employee: "Paul", scan: .ENTER),
            ScanRecord(employee: "Paul", scan: .EXIT),
            ScanRecord(employee: "Paul", scan: .ENTER),
            ScanRecord(employee: "Paul", scan: .ENTER),
            ScanRecord(employee: "Paul", scan: .EXIT),
            ScanRecord(employee: "Paul", scan: .ENTER),
        ])

        XCTAssertTrue(entries.count == 1)
        XCTAssertTrue(entries == ["Paul"])
        XCTAssertTrue(exits.count == 1)
        XCTAssertTrue(exits == ["Paul"])
    }
}
