import Vapor
import FluentPostgreSQL

final class Receipts: Codable {
    
    var id: Int?
    var details: String
    var timestamp: String
    var imageString: String?
    
    init(details: String, timestamp: String, imageString: String? = nil) {
        self.details = details
        self.timestamp = timestamp
        self.imageString = imageString
    }
}

extension Receipts: PostgreSQLModel {}
extension Receipts: Migration {}
extension Receipts: Parameter {}
extension Receipts: Content {}
