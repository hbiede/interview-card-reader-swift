# Interview - Card Reader

DMSi has a secure access room with a card reader on each side. You must scan to enter and scan to exit. However, we've been having some issues with access logs lately. It seems that while the card reader is permitting entry, it is dropping some logs. We need to determine if it is the fault of the reader or the fault of the individuals' proxy cards. In order to do so, we must identify which employees have a dropped log entry.

Our logs are formatted as an Array of scan record objects. Each log contains the employee name and the type of scan that was recorded, `enter` or `exit`.

```swift
[
  ScanRecord(employee: "Paul", scan: .ENTER),
  ScanRecord(employee: "Mary", scan: .ENTER),
  ScanRecord(employee: "Mary", scan: .EXIT),
  ScanRecord(employee: "Paul", scan: .ENTER),
  ScanRecord(employee: "Paul", scan: .EXIT)
];
```

We want to get a tuple where the first item is an Array of employee names whose entrances failed to log, and the second item is an Array of employee names whose exits failed to log.

```swift
public func getInvalidLogs(_ records: [ScanRecord]) -> ([String], [String]) {
    let missingEntries: [String] = []
    let missingExits: [String] = []
    return (missingEntries, missingExits)
}
```

An example would be the case of Paul this morning. He scanned into the room, presumably spent some time in there, and then left. However, his exit did not log.

```swift
[
  ScanRecord(employee: "Paul", scan: .ENTER),
  ScanRecord(employee: "Mary", scan: .ENTER),
  ScanRecord(employee: "Benedict", scan: .ENTER),
  ScanRecord(employee: "Mary", scan: .EXIT),
  ScanRecord(employee: "Benedict", scan: .EXIT)
];
```

Given this log, we would want to return a tuple that looks like this:

```swift
([], ["Paul"])
```

Importantly, the room is physically empty at the start and end of the day. So we can be certain that if a person's first entry is an `exit` or last entry is an `enter` that they are missing a log.

Since we are really just trying to debug a hardware problem, we don't need an exhaustive list of every missing log. Rather, we want a list of missing exits and missing entries where an employee **appears only once** in each list. If Paul has multiple missing entry logs, he should only appear once in the `missingEntries` Array. However, if he had a missing entry **and** a missing exit, he should appear once in both Arrays.