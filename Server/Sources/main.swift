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

enum AnimalAPIError: Error {
    case NoData
    case CouldNotParse
    case NoResponse
    case OtherError(String)
}

typealias RequestFetchClosure = (_ animals: [Animal]?, _ error: Error?) -> Void

func fetch(_ url: URL, completion: @escaping RequestFetchClosure) {
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(nil, AnimalAPIError.OtherError(error.localizedDescription))
        }
        do {
            guard let data = data else {
                completion(nil, AnimalAPIError.NoData)
                return
            }
            guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: AnyObject]] else {
                completion(nil, AnimalAPIError.CouldNotParse)
                return
            }
            var animals = [Animal]()
            for animalJson in json {
                if let animal = Animal.init(json: animalJson) {
                    animals.append(animal)
                }
            }
            completion(animals, nil)
        } catch {
            completion(nil, AnimalAPIError.OtherError("Unhandled Error"))
        }
    }
    task.resume()
}

func filter(_ animals: [Animal], _ request: RouterRequest) -> [Animal] {
    var filteredAnimals = animals
    let animalChoice = request.parameters["animals"]
    let friendlyChoice = request.parameters["friendly"]
    let pluralChoice = request.parameters["plural"]
    
    if animalChoice != "all" {
        filteredAnimals = filteredAnimals.filter {
            $0.type.rawValue == animalChoice
        }
    }
    if friendlyChoice != "all" {
        filteredAnimals = filteredAnimals.filter {
            $0.looksFriendly == friendlyChoice?.toBool()
        }
    }
    if pluralChoice != "all" {
        filteredAnimals = filteredAnimals.filter {
            $0.plural == pluralChoice?.toBool()
        }
    }
    return filteredAnimals
}

router.get("/animals/:animals/friendly/:friendly/plural/:plural") { request, response, next in
    let animalGroup = DispatchGroup()
    var animals = [Animal]()
    for address in ["http://0.0.0.0:3030/api/Cats", "http://0.0.0.0:3001/api/Bears"] {
        guard let url = URL(string: address) else {
            return
        }
        animalGroup.enter()
        fetch(url, completion: { fetchedAnimals, error in
            if let fetchedAnimals = fetchedAnimals {
                animals.append(contentsOf: fetchedAnimals)
            }
            animalGroup.leave()
        })
    }

    animalGroup.notify(queue: DispatchQueue.global(qos: .default)) {
        animals = filter(animals, request)
        var results = [[String: AnyObject]]()
        for animal in animals {
            results.append(animal.json)
        }
        response.send(json: JSON(results))
        next()
    }
}

// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8090, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
