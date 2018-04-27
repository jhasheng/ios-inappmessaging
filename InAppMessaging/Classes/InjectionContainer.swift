import Swinject

/**
 * Class to hold all the registered services in a container using Swinject
 */
class InjectionContainer {
    
    // Container to register all the services using Swinject library.
    static let container = Container() { container in
        
        container.register(CommonUtility.self) { _ in CommonUtility() }
        
        container.register(ConfigurationClient.self) { _ in
            ConfigurationClient(commonUtility: container.resolve(CommonUtility.self)!)
        }
        
        //(TODO: Daniel Tam) get secondsBetweenInterval from config server response when response body is finalized.
        container.register(MessageMixerClient.self) { _ in
            MessageMixerClient(secondsBetweenInterval: 1, commonUtility: container.resolve(CommonUtility.self)!)
        }
    }
}
