import Vapor
import FluentPostgreSQL

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
    ) throws {
    
    //Configure DB
    let database: String
    let port: Int
    let hostname: String
    let username: String
    //    let password: String
    
    if env == .testing {
        database = Secrets.localDatabase
        port = Secrets.localPort
        hostname = Secrets.hostname
        username = Secrets.username
//        password = Secrets.password
    } else {
        database = Secrets.database
        port = Secrets.port
        hostname = Secrets.hostname
        username = Secrets.username
//        password = Secrets.password
    }
    
    //Register the Provider
    try services.register(FluentPostgreSQLProvider())
    
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Configure the rest of your application here
    var middleware = MiddlewareConfig()
    middleware.use(ErrorMiddleware.self)
    services.register(middleware)
    
    //Add password parameter to the databaseConfig if you require a password
    let databaseConfig = PostgreSQLDatabaseConfig(hostname: hostname, port: port, username: username, database: database)
    let psql = PostgreSQLDatabase(config: databaseConfig)
    
    //Register DB
    var databases = DatabasesConfig()
    databases.add(database: psql, as: .psql)
    services.register(databases)
    
    //Configure Migrations
    var migrations = MigrationConfig()
    migrations.add(model: Receipts.self, database: .psql)
    migrations.add(model: Images.self, database: .psql)
    services.register(migrations)
    
    //Configure Vapors commands
    var commandConfig = CommandConfig.default()
    commandConfig.useFluentCommands()
    services.register(commandConfig)
    
    //We need to expand the byte size for sending requests
    services.register(NIOServerConfig.default(maxBodySize: 20_000_000))
    
    //Detect the directory
    let directoryConfig = DirectoryConfig.detect()
    services.register(directoryConfig)
}
