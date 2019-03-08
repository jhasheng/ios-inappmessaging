import Quick
import Nimble
@testable import InAppMessaging

/**
 * Tests for behavior when registering IDs to the SDK.
 */
class IdRegistrationTests: QuickSpec {

    override func spec() {

        beforeEach {
            IAMPreferenceRepository.setPreference(with: nil)
        }

        context("ID Registration") {

            it("should not have any matching id type or id value") {
                let expected = [UserIdentifier]()
                
                expect(expected).toEventually(equal(IAMPreferenceRepository.getUserIdentifiers()))
            }

            /**
             * The two tests below calls directly from IndentificationManager.registerId() rather than
             * InAppMessaging.registerId() because the asynchronous nature in the public method causes
             * inconsistency when running the tests -- it sometimes fail. Running the non-async
             * function will resolve this issue.
             */
            it("should have one matching id type and id value") {

                InAppMessaging.registerPreference(
                    IAMPreferenceBuilder()
                        .setUserId("whales and dolphins")
                        .build()
                )
                
                // Build the expected object.
                var expected = [UserIdentifier]()
                expected.append(UserIdentifier(type: 3, id: "whales and dolphins"))
                Thread.sleep(forTimeInterval: 0.5)

                expect(expected).toEventually(equal(IAMPreferenceRepository.getUserIdentifiers()), timeout: 3.0, pollInterval: 0.1, description: nil)
            }

            it("should have two matching id type and id value") {

                InAppMessaging.registerPreference(
                    IAMPreferenceBuilder()
                        .setUserId("tigers and zebras")
                        .setRakutenId("whales and dolphins")
                        .build()
                )

                // Build the expected object.
                var expected = [UserIdentifier]()
                expected.append(UserIdentifier(type: 1, id: "whales and dolphins"))
                expected.append(UserIdentifier(type: 3, id: "tigers and zebras"))
                Thread.sleep(forTimeInterval: 0.5)

                expect(expected).toEventually(equal(IAMPreferenceRepository.getUserIdentifiers()), timeout: 3.0, pollInterval: 0.1, description: nil)
            }
        }
    }
}
