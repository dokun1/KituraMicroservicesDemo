# Kitura Microservices Demo

## About 

This is a demo that shows RESTful interaction amongst the following:

* an iOS Mobile Application
* a [Kitura](http://kitura.io) server 
* two [Loopback](http://loopback.io) servers posing as microservices

In order to run the entire application, you will need to have the following installed on your local machine:

* Node.js
* npm
* Xcode
* Swift Package Manager

First, navigate to `BearsAPI/` and `CatsAPI/` in separate instances of your command line. At the root of each of those directories, type `node .` to run each api. You should see the following messages:

```
Sample Cats added
Web server listening at: http://0.0.0.0:3030
Browse your REST API at http://0.0.0.0:3030/explorer
```

AND

```
Sample bears added
Web server listening at: http://0.0.0.0:3001
Browse your REST API at http://0.0.0.0:3001/explorer
```

Once these are both running, you can go back up to the main root directory. After that, navigate to `Server/` and type the following command in a separate terminal window:

```
swift package init --type executable
```

Swift Package Manager will install all the necessary dependencies you need to run Kitura. After this is complete, go back to the root directory and open `Workspace.xcworkspace`. You should be able to run both the client (simulator) and the server simultaneously in the workspace. Try the app, try debugging on both client and server, and observe it's behavior.

Also, notice that both the Kitura server and the mobile client share the model class `Animal.swift`.

A tutorial will soon be made of this, but enjoy the completed product for now :-)
