import Kitura
import Foundation
import SwiftyJSON

// Create a new router
let router = Router()

// Handle HTTP GET requests to /
router.get("/") { request, response, next in
    response.send(json:["message" : "Hello, World!"])
    next()
}

// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8090, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
