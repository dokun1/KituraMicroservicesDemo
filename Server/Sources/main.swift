import Kitura
import Foundation
import SwiftyJSON
import Dispatch

// Create a new router
let router = Router()

// Handle HTTP GET requests to /
router.get("/") { request, response, next in
    response.send(json:["message" : "Hello, World!"])
    next()
}

router.get("/animals/:animals/friendly/:friendly/plural/:plural") { request, response, next in
    let animalChoice = request.parameters["animals"]
    let friendlyChoice = request.parameters["friendly"]
    let pluralChoice = request.parameters["plural"]
    
    let catSemaphore = DispatchSemaphore(value: 0)
    let bearSemaphore = DispatchSemaphore(value: 0)
    var animals = [Animal]()
    guard let catsURL = URL(string: "http://0.0.0.0:3030/api/Cats") else {
        next()
        return
    }
    guard let bearsURL = URL(string: "http://0.0.0.0:3001/api/Bears") else {
        next()
        return
    }
    URLSession.shared.dataTask(with: catsURL, completionHandler: { catsData, catsResponse, catsError in
        do {
            guard let data = catsData else {
                next()
                return
            }
            guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: AnyObject]] else {
                next()
                return
            }
            for catJson in json {
                if let cat = Animal.init(json: catJson) {
                    animals.append(cat)
                }
            }
        } catch {
            next()
            return
        }
        catSemaphore.signal()
    }).resume()
    URLSession.shared.dataTask(with: bearsURL, completionHandler: { bearsData, bearsResponse, bearsError in
        do {
            guard let data = bearsData else {
                next()
                return
            }
            guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: AnyObject]] else {
                next()
                return
            }
            for bearJson in json {
                if let bear = Animal.init(json: bearJson) {
                    animals.append(bear)
                }
            }
        } catch {
            next()
            return
        }
        bearSemaphore.signal()
    }).resume()
    catSemaphore.wait()
    bearSemaphore.wait()
    if animalChoice != "all" {
        animals = animals.filter {
            $0.type.rawValue == animalChoice
        }
    }
    if friendlyChoice != "all" {
        animals = animals.filter {
            $0.looksFriendly == friendlyChoice?.toBool()
        }
    }
    if pluralChoice != "all" {
        animals = animals.filter {
            $0.plural == pluralChoice?.toBool()
        }
    }
    var results = [[String: AnyObject]]()
    for animal in animals {
        results.append(animal.json)
    }
    response.send(json: JSON(results))
    next()
}

// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8090, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
