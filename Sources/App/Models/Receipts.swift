import Foundation
import Vapor
import FluentPostgreSQL

final class Receipts: Codable {
    
    var id: UUID?
    var details: String
    var timestamp: String
    
    init(details: String, timestamp: String) {
        self.details = details
        self.timestamp = timestamp
    }
}

extension Receipts: PostgreSQLUUIDModel {}
extension Receipts: Migration {}
extension Receipts: Parameter {}
extension Receipts: Content {}

extension Receipts {
    var image: Children<Receipts, Images> {
        return children(\.receiptID)
    } 
}

