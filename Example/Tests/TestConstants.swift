@testable import InAppMessaging

struct TestConstants {
    struct MockResponse {
        static let twoTestCampaigns = PingResponse.init(
            nextPingMillis: 0,
            currentPingMillis: 0,
            data: [
                Campaign.init(
                    campaignData: CampaignData.init(
                        campaignId: "testCampaignId",
                        maxImpressions: 2,
                        type: 1,
                        triggers: nil,
                        isTest: true,
                        messagePayload: MessagePayload.init(
                            title: "testTitle",
                            messageBody: "testBody",
                            messageLowerBody:"testLowerBody",
                            header: "testHeader",
                            titleColor: "color",
                            headerColor: "color2",
                            messageBodyColor: "color3",
                            backgroundColor: "color4",
                            frameColor: "color5",
                            resource: Resource.init(
                                assetsUrl: nil,
                                imageUrl: nil,
                                cropType: 1),
                            messageSettings: MessageSettings.init(
                                displaySettings: DisplaySettings.init(
                                    orientation: 1,
                                    slideFrom: 1,
                                    endTimeMillis: 1,
                                    textAlign: 1),
                                controlSettings: nil)
                        )
                    )
                ),
                Campaign.init(
                    campaignData: CampaignData.init(
                        campaignId: "testCampaignId2",
                        maxImpressions: 2,
                        type: 1,
                        triggers: nil,
                        isTest: true,
                        messagePayload: MessagePayload.init(
                            title: "testTitle",
                            messageBody: "testBody",
                            messageLowerBody:"testLowerBody",
                            header: "testHeader",
                            titleColor: "color",
                            headerColor: "color2",
                            messageBodyColor: "color3",
                            backgroundColor: "color4",
                            frameColor: "color5",
                            resource: Resource.init(
                                assetsUrl: nil,
                                imageUrl: nil,
                                cropType: 1),
                            messageSettings: MessageSettings.init(
                                displaySettings: DisplaySettings.init(
                                    orientation: 1,
                                    slideFrom: 1,
                                    endTimeMillis: 1,
                                    textAlign: 1),
                                controlSettings: nil)
                        )
                    )
                ),
                Campaign.init(
                    campaignData: CampaignData.init(
                        campaignId: "testCampaignId3",
                        maxImpressions: 2,
                        type: 1,
                        triggers: nil,
                        isTest: false,
                        messagePayload: MessagePayload.init(
                            title: "testTitle",
                            messageBody: "testBody",
                            messageLowerBody:"testLowerBody",
                            header: "testHeader",
                            titleColor: "color",
                            headerColor: "color2",
                            messageBodyColor: "color3",
                            backgroundColor: "color4",
                            frameColor: "color5",
                            resource: Resource.init(
                                assetsUrl: nil,
                                imageUrl: nil,
                                cropType: 1),
                            messageSettings: MessageSettings.init(
                                displaySettings: DisplaySettings.init(
                                    orientation: 1,
                                    slideFrom: 1,
                                    endTimeMillis: 1,
                                    textAlign: 1),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let noTestCampaigns = PingResponse.init(
            nextPingMillis: 0,
            currentPingMillis: 0,
            data: [
                Campaign.init(
                    campaignData: CampaignData.init(
                        campaignId: "testCampaignId",
                        maxImpressions: 2,
                        type: 1,
                        triggers: nil,
                        isTest: false,
                        messagePayload: MessagePayload.init(
                            title: "testTitle",
                            messageBody: "testBody",
                            messageLowerBody:"testLowerBody",
                            header: "testHeader",
                            titleColor: "color",
                            headerColor: "color2",
                            messageBodyColor: "color3",
                            backgroundColor: "color4",
                            frameColor: "color5",
                            resource: Resource.init(
                                assetsUrl: nil,
                                imageUrl: nil,
                                cropType: 1),
                            messageSettings: MessageSettings.init(
                                displaySettings: DisplaySettings.init(
                                    orientation: 1,
                                    slideFrom: 1,
                                    endTimeMillis: 1,
                                    textAlign: 1),
                                controlSettings: nil)
                        )
                    )
                ),
                Campaign.init(
                    campaignData: CampaignData.init(
                        campaignId: "testCampaignId2",
                        maxImpressions: 2,
                        type: 1,
                        triggers: nil,
                        isTest: false,
                        messagePayload: MessagePayload.init(
                            title: "testTitle",
                            messageBody: "testBody",
                            messageLowerBody:"testLowerBody",
                            header: "testHeader",
                            titleColor: "color",
                            headerColor: "color2",
                            messageBodyColor: "color3",
                            backgroundColor: "color4",
                            frameColor: "color5",
                            resource: Resource.init(
                                assetsUrl: nil,
                                imageUrl: nil,
                                cropType: 1),
                            messageSettings: MessageSettings.init(
                                displaySettings: DisplaySettings.init(
                                    orientation: 1,
                                    slideFrom: 1,
                                    endTimeMillis: 1,
                                    textAlign: 1),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let oneLoginSuccessfulEvent = PingResponse.init(
            nextPingMillis: 0,
            currentPingMillis: 0,
            data: [
                Campaign.init(
                    campaignData: CampaignData.init(
                        campaignId: "testCampaignId",
                        maxImpressions: 2,
                        type: 1,
                        triggers: [
                            Trigger.init(
                                type: 1,
                                eventType: 2,
                                attributes: []
                            )
                        ],
                        isTest: false,
                        messagePayload: MessagePayload.init(
                            title: "testTitle",
                            messageBody: "testBody",
                            messageLowerBody:"testLowerBody",
                            header: "testHeader",
                            titleColor: "color",
                            headerColor: "color2",
                            messageBodyColor: "color3",
                            backgroundColor: "color4",
                            frameColor: "color5",
                            resource: Resource.init(
                                assetsUrl: nil,
                                imageUrl: nil,
                                cropType: 1),
                            messageSettings: MessageSettings.init(
                                displaySettings: DisplaySettings.init(
                                    orientation: 1,
                                    slideFrom: 1,
                                    endTimeMillis: 1,
                                    textAlign: 1),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
    }
}
