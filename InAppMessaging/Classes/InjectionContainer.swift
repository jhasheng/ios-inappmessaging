import Swinject

/**
 * Class to hold all the registered services in a container using Swinject
 */
struct InjectionContainer {
    
    // Container to register all the services using Swinject library.
    static var container = Container() { container in
        
        container.register(CommonUtility.self) { _ in CommonUtility() }
        
        container.register(ConfigurationClient.self) { _ in ConfigurationClient() }
        
        container.register(MessageMixerClient.self) { _ in MessageMixerClient() }
        
        container.register(CampaignHelper.self) { _ in CampaignHelper() }
    }
}
