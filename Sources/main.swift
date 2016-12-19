import Kitura
import Foundation
import HeliumLogger
import SwiftyJSON

let router = Router()

HeliumLogger.use()

router.get("/") {
    request, response, next in
    response.send("Hello, World!")
    next()
}

router.get("/currentYear/:week") { request, response, _ in
    let startTime = Date()
    let week = request.parameters["week"] ?? ""
    let scoreEndpoint: String = "http://localhost:8081/schedule/2016/\(week)"
    guard let scoreURL = URL(string: scoreEndpoint) else {
        try response.status(.badRequest).send(json: JSON(["error" : "Could not create URL"])).end()
        return
    }
    
    let task = URLSession.shared.dataTask(with: URLRequest(url: scoreURL)) { (data, scoreResponse, error) in
        do {
            guard let scoreData = data else {
                try response.status(.failedDependency).send(json: JSON(["error" : "No score data received"])).end()
                return
            }
            guard let scores = try JSONSerialization.jsonObject(with: scoreData, options: .allowFragments) as? [String: Any] else {
                try response.status(.failedDependency).send(json: JSON(["error" : "Could not parse scores"])).end()
                return
            }
            guard let games = scores["games"] as! [[String: AnyObject]]? else {
                try response.status(.failedDependency).send(json: JSON(["error" : "Could not count number of games"])).end()
                return
            }
            let elapsed: Double = Date().timeIntervalSince(startTime)
            try response.status(.OK).send(json: ["gamesReceived" : games.count, "timeElapsed" : elapsed]).end()
        } catch {
            print("500 - internal server error")
        }
    }
    task.resume()
}

Kitura.addHTTPServer(onPort: 8090, with: router)

Kitura.run()
