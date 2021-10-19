public struct ScanRecord {
    public enum ScanDirection {
        case ENTER
        case EXIT
    }
    public let employee: String
    public let scan: ScanDirection
}

public struct CardReader {
    /**
     * Takes an array of card scan logs, where each log contains the name of the employee
     * and the type of log (enter or exit).
     * The log begins at the beginning of the day and ends at the end of the day.
     * The room is physically clear at the start and end of each day.
     * Any missing logs are a result of a faulty card or card reader, however each entry is true.
     * Therefore, in the case of an exit with no preceding entry, the employee should
     * be returned in the missingEntries array, to note that their card did not read upon
     * entry of the room.
     * @param log Array<{employee: string, scan: ScanDirection}>
     * @returns {([missingEntryLogEmployees: String], [missingExitLogEmployees: String])}
     */
    public func getInvalidLogs(_ records: [ScanRecord]) -> ([String], [String]) {
        var entries = Set<String>()
        var exits = Set<String>()
        var peopleInRoom = Set<String>()
        for r in records {
            switch (r.scan) {
            case .ENTER:
                if (peopleInRoom.contains(r.employee)) {
                    exits.insert(r.employee)
                } else {
                    peopleInRoom.insert(r.employee)
                }
                break
            case .EXIT:
                if (peopleInRoom.contains(r.employee)) {
                    peopleInRoom.remove(r.employee)
                } else {
                    entries.insert(r.employee)
                }
            }
        }
        if (!peopleInRoom.isEmpty) {
            for p in peopleInRoom {
                exits.insert(p)
            }
        }
        return (Array(entries), Array(exits))
    }
}
