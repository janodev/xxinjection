import os
import UIKit

public final class Signpost
{
    private let category: String
    private var log: OSLog
    private var poi: OSLog
    private var id: OSSignpostID! // swiftlint:disable:this implicitly_unwrapped_optional
    private let name: StaticString
    private let subsystem: String

    private let logger: Logger

    /**
     - Parameters:
       - subsystem: Major area of the system.
       - category: Software component inside a layer. e.g. Home, TaskUseCase, WebService.
       - name: The action this signpost is going to measure. e.g. 'open task'
       - id: An object whose pointer will be used to match begin/end pairs. If null, it uses `OSSignPostID(log)`.
    */
    public init(subsystem: String, category: String, name: StaticString, id: AnyObject? = nil) {
        self.subsystem = subsystem
        self.category = category
        self.name = name
        self.log = OSLog(subsystem: subsystem, category: category)
        self.poi = OSLog(subsystem: subsystem, category: .pointsOfInterest)
        logger = Logger(subsystem: subsystem, category: category)
        self.id = id.flatMap { OSSignpostID(log: log, object: $0) } ?? OSSignpostID(log: log)
    }

    public func begin(_ message: String) {
        os_signpost(.begin, log: log, name: name, signpostID: id, "%{public}@", message)
        logger.debug("begin \(message)")
    }

    public func end(_ message: String) {
        os_signpost(.end, log: log, name: name, signpostID: id, "%{public}@", message)
        logger.debug("end \(message)")
    }

    public func poi(_ message: String) {
        os_signpost(.event, log: poi, name: name, "%{public}@", "\(category): \(name): \(message)")
        logger.debug("poi \(message)")
    }
}

public extension Signpost {
    static func post<Cell: UIView & Identifiable>(cell: Cell) -> Signpost {
        Signpost(subsystem: "dev.jano", category: "#\(cell.id.hashValue.description.prefix(3))", name: "cell rendering", id: cell)
    }
}
