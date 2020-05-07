![logo-normal.png](VGdatabase/app/assets/images/logo-normal.png)
**VGDatabase (VGDB)** is a platform designed and built for gamers by gamers.

The site is based on a videogames database, where you can view many information about any games such as genre, developer, date of release, score and the reviews written by other players, with an additional external link for the purchase. The platform also provides a selling platform. In addition, the site is updated periodically, always showing in the homepage the most popular games at the moment. Each user has his own library of games, a friends list and the possibility to group games and friends in Favorites lists. Enjoy!


## Authors

*   **Giovanni Roma** - roma.1808340@studenti.uniroma1.it - [GitHub](https://github.com/JoGist) - [LinkedIn](https://www.linkedin.com/in/giovanni-roma-a95a32127/)
*   **Marco Musciaglia** - musciaglia.1816864@studenti.uniroma1.it - [GitHub](https://github.com/loldlink)
*   **Gianmarco Montillo** - montillo.1801402@studenti.uniroma1.it - [GitHub](https://github.com/ZioSaba)

## Requirementa

*   Il servizio REST implementato deve offrire delle API documentate (e.g. GET /sanlorenzo fornisce tutti i cinema di sanlorenzo)
*   SERV si deve interfacciare con almeno due servizi REST “esterni”, cioè non su localhost
*   Almeno uno dei servizi REST esterni deve essere “commerciale” (es: twitter, google, facebook, parse, firbase etc)
*   Almeno uno dei servizi REST esterni deve richiedere oauth
*   Si devono usare Websocket e/o AMQP (o simili es MQTT)
*   Il progetto deve essere su GIT e documentato don un README
*   Le API  REST implementate devono essere documentate su GIT e devono essere validate con un caso di test 


## Dependencies
In order to build and run the Rails server in your machine, you must have installed:
*   _Bundler 2.0_
*   _Ruby 2.7.0p0_
*   _Rails 6.0.2.2_
*   _JavaScript (any version)_


## Code usage
To build and run the Rails server, go into the /VGDatabase folder and run:
```sh
Bundle install
```
To intall all required Gems, then run:
```sh
rails server
```
Then simply go on this page with your browser of choice and you're done!
```sh
localhost:3000/login
```

### Other useful command
Run the integrated Rails console
```sh
rails console
```

View all the routes created in the project
```sh
rails route
```

Execute database table migrations that have not run yet
```sh
rake:db migrate
```
