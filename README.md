## Kitura Microservices Demo

[![Twitter](https://img.shields.io/badge/contact-@dokun24-blue.svg?style=flat)](https://twitter.com/dokun24)
[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/dokun1/firstRuleFireplace/blob/master/LICENSE)

### About

This is a demonstration of how to use Kitura to make a request to the web, parse information from that request, and redistribute it to an iOS client. In this case, we are analyzing historical NFL game scores.

This particular use case allows you to specify a request to Kitura from any client (in this case, an iOS app), with the week you want to view, and that request will be passed to a Node.js microservice that scrapes NFL.com. Kitura will parse the output, and send it back in a response to the client.

The purpose of this set up is to demonstrate how simple it is to work with object models in a context iOS developers are familiar with. This could be expanded upon by persisting data to a database using a Kitura connector, or anything else.

For more information, visit http://www.kitura.io.

### Setup
You will need to visit here: https://github.com/dokun1/nfl-score-scraper and run this on your machine in order to get this to work.

Packages pulled from Swift Package Manager are not included in this repository - once you pull this repository, run `swift build` in the root directory on the command line, and Swift Package Manager will pull down the necessary dependencies.