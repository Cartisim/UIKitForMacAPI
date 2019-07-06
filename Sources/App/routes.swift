import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    router.get { req in
        return "UIKitForMacAPI"
    }
    let receiptsController = ReceiptsController()
    try router.register(collection: receiptsController)
//    
//    let imagesController = ImagesController()
//    try router.register(collection: imagesController)
}
