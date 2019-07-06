//import Vapor
//
//struct ImagesController: RouteCollection {
//    func boot(router: Router) throws {
//        print("the boots")
//        let imageRouter = router.grouped("api", "images")
//        imageRouter.get(use: getAllHandler)
//        imageRouter.get(Images.parameter, use: getHandler)
//        imageRouter.post(Images.self, use: createHandler)
//        imageRouter.delete(Images.parameter, use: deleteHandler)
//        imageRouter.put(Images.self, at: Images.parameter, use: updateHandler)
//        
//        
//    }
//
//    func getAllHandler(_ request: Request) throws -> Future<[Images]> {
//        return Images.query(on: request).all()
//    }
//    
//    func getHandler(_ request: Request) throws -> Future<Images> {
//        return try request.parameters.next(Images.self)
//    }
//    
//    func createHandler(_ request: Request, images: Images) throws -> Future<Images> {
//        return images.save(on: request)
//    }
//    
//    func updateHandler(_ request: Request, updateImage: Images) throws -> Future <Images> {
//        return try request.parameters.next(Images.self).flatMap({ (images) -> EventLoopFuture<Images> in
//            images.image = updateImage.image
//            return images.save(on: request)
//        })
//    }
//    
//    func deleteHandler(_ request: Request) throws -> Future<HTTPStatus> {
//        return try request.parameters.next(Images.self).delete(on: request).transform(to: HTTPStatus.noContent)
//    }
//}
