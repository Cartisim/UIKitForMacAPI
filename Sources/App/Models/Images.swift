import Vapor
import FluentPostgreSQL

final class Images: Codable {
    
    var id: Int?
    var image: Data
    
    init(image: Data) {
        self.image = image
    }
}

extension Images: PostgreSQLModel {}
extension Images: Migration {}

extension Images: Parameter {}
extension Images: Content {}
