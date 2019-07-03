import Foundation
import Vapor
import FluentPostgreSQL

final class Images: Codable {
    
    var id: Int?
    var image: Data
    var receiptID: Receipts.ID
    
    init(image: Data, receiptID: Receipts.ID) {
        self.image = image
        self.receiptID = receiptID
    }
}

extension Images: PostgreSQLModel {}
extension Images: Migration {}
extension Images: Parameter {}
extension Images: Content {}

extension Images {
    var receipt: Parent<Images, Receipts> {
        return parent(\.receiptID)
    }
}


