import Vapor

struct ReceiptsController: RouteCollection {
    func boot(router: Router) throws {
        print("booted")
        
        let receiptRoute = router.grouped("api", "receipt")
        receiptRoute.get(use: getAllHandler)
        receiptRoute.get(Receipts.parameter,  use: getHandler)
        receiptRoute.post(Receipts.self, use: createHandler)
        receiptRoute.delete(Receipts.parameter, use: deleteReceiptsHandler)
    }
    
    func createHandler(_ request: Request, receipt: Receipts) throws -> Future<Receipts> {
        let receipt = Receipts(details: receipt.details, timestamp: receipt.timestamp)
        return receipt.save(on: request)
    }
    
    func getAllHandler(_ request: Request) throws -> Future <[Receipts]> {
        return Receipts.query(on: request).sort(\.timestamp).all()
    }

    func getHandler(_ request: Request) throws -> Future<Receipts> {
        return try request.parameters.next(Receipts.self)
    }
    
    func deleteReceiptsHandler(_ request: Request) throws -> Future<HTTPStatus> {
        return try request.parameters.next(Receipts.self).delete(on: request).transform(to: HTTPStatus.noContent)
    }
    
}

