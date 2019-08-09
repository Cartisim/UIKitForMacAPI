import Vapor

struct ReceiptsController: RouteCollection {
    func boot(router: Router) throws {
        print("booted")
        
        let receiptRoute = router.grouped("api", "receipt")
        receiptRoute.post(Receipts.self, use: createHandler)
        receiptRoute.get(use: getAllHandler)
        receiptRoute.get(Receipts.parameter,  use: getHandler)
        receiptRoute.put(Receipts.self, at: Receipts.parameter, use: updateHandler)
        receiptRoute.delete(Receipts.parameter, use: deleteReceiptsHandler)
        receiptRoute.post("users", Receipts.parameter, "profilePicture", use: addProfilePicturePostHandler)
        receiptRoute.get("users", Receipts.parameter, "profilePicture", use: getUsersProfilePictureHandler)
    }
    
    func createHandler(_ request: Request, receipt: Receipts) throws -> Future<Receipts> {
        let receipt = Receipts(details: receipt.details, timestamp: receipt.timestamp, imageString: receipt.imageString)
        return receipt.save(on: request)
    }
    
    func getAllHandler(_ request: Request) throws -> Future <[Receipts]> {
        return Receipts.query(on: request).sort(\.timestamp).all()
    }

    func getHandler(_ request: Request) throws -> Future<Receipts> {
        return try request.parameters.next(Receipts.self)
    }
    
    func updateHandler(_ request: Request, updateReceipt: Receipts) throws -> Future<Receipts> {
        return try request.parameters.next(Receipts.self).flatMap({ (receipt) -> EventLoopFuture<Receipts> in
            receipt.details = updateReceipt.details
            return receipt.save(on: request)
        })
    }
    func deleteReceiptsHandler(_ request: Request) throws -> Future<HTTPStatus> {
        return try request.parameters.next(Receipts.self).delete(on: request).transform(to: HTTPStatus.noContent)
    }
    
    let imageFolder = "ProfilePictures"
    func addProfilePicturePostHandler(_ request: Request) throws -> Future<Response> {
        // 1
        return try flatMap( to: Response.self, request.parameters.next(Receipts.self), request.content.decode(Images.self)) {
            receipt, imageData in
            // 2
            let workPath = try request.make(DirectoryConfig.self).workDir
            // 3
            let name = try "\(receipt.requireID())-\(UUID().uuidString).jpg"
            // 4
            let path = workPath + self.imageFolder + name
            // 5
            FileManager().createFile( atPath: path, contents: imageData.image, attributes: nil)
            // 6
            receipt.imageString = name
            // 7
            let redirect = request.redirect(to: "")
            return receipt.save(on: request).transform(to: redirect)
        }
    }
    
    func getUsersProfilePictureHandler(_ request: Request)
        throws -> Future<Response> {
            // 1
            return try request.parameters.next(Receipts.self)
                .flatMap(to: Response.self) { receipt in
                    // 2
                    guard let filename = receipt.imageString else {
                        throw Abort(.notFound)
                    }
                    // 3
                    let path = try request.make(DirectoryConfig.self)
                        .workDir + self.imageFolder + filename
                    // 4
                    return try request.streamFile(at: path)
            }
    }
}


