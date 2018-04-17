/**
 * Class that contains the public methods for host application to call.
 */

import Swinject

class Animal { }
class Cat: Animal { }

class PetOwner {
    let pet: Animal
    init(pet: Animal) {
        self.pet = pet
    }
}


public class InAppMessaging {
    
    /**
     * Function to called by host application to configure Rakuten InAppMessaging SDK.
     */
    public class func configure() {
        let configurationClient = ConfigurationClient(commonUtility: CommonUtility())
        let container = Container()
        
        container.register(ConfigurationClient.self) { (resolver) in
            ConfigurationClient(commonUtility: CommonUtility())
        }
        
        let dis = container.resolve(ConfigurationClient.self)!
        
        print(dis.checkConfigurationServer())
        
//        container.register(Animal.self) { _ in
//            Cat()
//            }.inObjectScope(.container)
//
        
//        // Anywhere later
//        let anya = container.resolve(PetOwner.self)!
//        let yoichi = container.resolve(PetOwner.self)!
//
//        print(anya !== yoichi)
//        print(anya.pet === yoichi.pet)
        
        // (TODO: Daniel Tam) remove if statement later.
        if configurationClient.checkConfigurationServer() {
            print("Enable SDK.")
        } else {
            print("Disable SDK.")
        }
        //semaphore.signal()
        
    }
    
//    @objc class func initializeSdk(semaphore: DispatchSemaphore) {
//        let configurationClient = ConfigurationClient(commonUtility: CommonUtility())
//        print(Thread.current)
//
//        // (TODO: Daniel Tam) remove if statement later.
//        if configurationClient.checkConfigurationServer() {
//            print("Enable SDK.")
//        } else {
//            print("Disable SDK.")
//        }
//        //semaphore.signal()
//    }
}

