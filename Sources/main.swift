import Kitura
import Foundation
import HeliumLogger
import SwiftyJSON

let router = Router()
var lastRequestTime: Date?
var cachedSeason: Season?

HeliumLogger.use()

router.get("/") {
    request, response, next in
    response.send("Hello, World!")
    next()
}

router.get("/currentYear/:week") { request, response, _ in
    let startTime = Date()
    let week = request.parameters["week"] ?? ""
    guard let weekInt = Int(week) else {
        try response.status(.badRequest).send(json: JSON(["error" : "Could not parse valid week"])).end()
        return
    }
    var shouldCheckService = true
    
    if let season = cachedSeason, let cachedRequestTime = lastRequestTime {
        if let storedWeeks = season.weeks {
            let cachedTimeInterval: Double = Swift.abs(cachedRequestTime.timeIntervalSince(startTime))
            if let thisStoredWeek = storedWeeks[weekInt], cachedTimeInterval < 30 {
                let elapsed: Double = Date().timeIntervalSince(startTime)
                try response.status(.OK).send(json: ["gamesReceived" : thisStoredWeek.games.count, "timeElapsed" : elapsed, "weekBreakdown" : thisStoredWeek.json]).end()
                return
            }
        }
    }
    
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
            var savedGames = [Game]()
            for game in games {
                let awayTeam = Team(name: game["awayTeam"] as! String, score: game["awayScore"] as! Int)
                let homeTeam = Team(name: game["homeTeam"] as! String, score: game["homeScore"] as! Int)
                let savedGame = Game(awayTeam: awayTeam, homeTeam: homeTeam)
                savedGames.append(savedGame)
            }
            
            let thisWeek = Week(weekNumber: Int(week)!, games: savedGames)
            if cachedSeason == nil {
                cachedSeason = Season(yearNumber: 2016, weeks: [:])
            }
            cachedSeason?.weeks?[Int(week)!] = thisWeek
            lastRequestTime = Date()
            
            let elapsed: Double = Date().timeIntervalSince(startTime)
            try response.status(.OK).send(json: ["gamesReceived" : thisWeek.games.count, "timeElapsed" : elapsed, "weekBreakdown" : thisWeek.json]).end()
        } catch {
            print("500 - internal server error")
        }
    }
    task.resume()
}

Kitura.addHTTPServer(onPort: 8090, with: router)

Kitura.run()

