/**
 * Class to hold all the registered services in a container using Swinject
 */

import Swinject

class InjectionContainer {
    
    // Container to register all the services using Swinject library.
    static let container = Container() { container in
        
        container.register(CommonUtility.self) { _ in CommonUtility() }
        
        container.register(ConfigurationClient.self) { _ in
            ConfigurationClient(commonUtility: container.resolve(CommonUtility.self)!)
        }
    }
}
