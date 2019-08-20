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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
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
                                eventType: .loginSuccessful,
                                eventName: "test",
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let stringTypeWithEqualsOperator = PingResponse.init(
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
                                eventType: .custom,
                                eventName: "testevent",
                                attributes: [
                                    TriggerAttribute(name: "attributeone", value: "attributeOneValue", type: .STRING, operator: .EQUALS)
                                ]
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let stringTypeWithNotEqualsOperator = PingResponse.init(
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
                                eventType: .custom,
                                eventName: "testevent",
                                attributes: [
                                    TriggerAttribute(name: "attributeone", value: "attributeOneValue", type: .STRING, operator: .IS_NOT_EQUAL)
                                ]
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let intTypeWithEqualsOperator = PingResponse.init(
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
                                eventType: .custom,
                                eventName: "testevent",
                                attributes: [
                                    TriggerAttribute(name: "attributeone", value: "123", type: .INTEGER, operator: .EQUALS)
                                ]
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let intTypeWithNotEqualsOperator = PingResponse.init(
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
                                eventType: .custom,
                                eventName: "testevent",
                                attributes: [
                                    TriggerAttribute(name: "attributeone", value: "123", type: .INTEGER, operator: .IS_NOT_EQUAL)
                                ]
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let intTypeWithGreaterThanOperator = PingResponse.init(
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
                                eventType: .custom,
                                eventName: "testevent",
                                attributes: [
                                    TriggerAttribute(name: "attributeone", value: "123", type: .INTEGER, operator: .GREATER_THAN)
                                ]
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let intTypeWithLessThanOperator = PingResponse.init(
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
                                eventType: .custom,
                                eventName: "testevent",
                                attributes: [
                                    TriggerAttribute(name: "attributeone", value: "123", type: .INTEGER, operator: .LESS_THAN)
                                ]
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let doubleTypeWithEqualsOperator = PingResponse.init(
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
                                eventType: .custom,
                                eventName: "testevent",
                                attributes: [
                                    TriggerAttribute(name: "attributeone", value: "123.0", type: .DOUBLE, operator: .EQUALS)
                                ]
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let doubleTypeWithNotEqualsOperator = PingResponse.init(
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
                                eventType: .custom,
                                eventName: "testevent",
                                attributes: [
                                    TriggerAttribute(name: "attributeone", value: "123.0", type: .DOUBLE, operator: .IS_NOT_EQUAL)
                                ]
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let doubleTypeWithGreaterThanOperator = PingResponse.init(
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
                                eventType: .custom,
                                eventName: "testevent",
                                attributes: [
                                    TriggerAttribute(name: "attributeone", value: "123.0", type: .DOUBLE, operator: .GREATER_THAN)
                                ]
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let doubleTypeWithLessThanOperator = PingResponse.init(
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
                                eventType: .custom,
                                eventName: "testevent",
                                attributes: [
                                    TriggerAttribute(name: "attributeone", value: "123.0", type: .DOUBLE, operator: .LESS_THAN)
                                ]
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let boolTypeWithEqualsOperator = PingResponse.init(
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
                                eventType: .custom,
                                eventName: "testevent",
                                attributes: [
                                    TriggerAttribute(name: "attributeone", value: "true", type: .BOOLEAN, operator: .EQUALS)
                                ]
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let boolTypeWithNotEqualOperator = PingResponse.init(
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
                                eventType: .custom,
                                eventName: "testevent",
                                attributes: [
                                    TriggerAttribute(name: "attributeone", value: "true", type: .BOOLEAN, operator: .IS_NOT_EQUAL)
                                ]
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let timeTypeWithEqualsOperator = PingResponse.init(
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
                                eventType: .custom,
                                eventName: "testevent",
                                attributes: [
                                    TriggerAttribute(name: "attributeone", value: "1100", type: .TIME_IN_MILLI, operator: .EQUALS)
                                ]
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let timeTypeWithNotEqualsOperator = PingResponse.init(
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
                                eventType: .custom,
                                eventName: "testevent",
                                attributes: [
                                    TriggerAttribute(name: "attributeone", value: "1100", type: .TIME_IN_MILLI, operator: .IS_NOT_EQUAL)
                                ]
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let timeTypeWithGreaterThanOperator = PingResponse.init(
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
                                eventType: .custom,
                                eventName: "testevent",
                                attributes: [
                                    TriggerAttribute(name: "attributeone", value: "1100", type: .TIME_IN_MILLI, operator: .GREATER_THAN)
                                ]
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let timeTypeWithLessThanOperator = PingResponse.init(
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
                                eventType: .custom,
                                eventName: "testevent",
                                attributes: [
                                    TriggerAttribute(name: "attributeone", value: "1100", type: .TIME_IN_MILLI, operator: .LESS_THAN)
                                ]
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let caseInsensitiveEventName = PingResponse.init(
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
                                eventType: .custom,
                                eventName: "testevent",
                                attributes: [
                                ]
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let caseInsensitiveAttributeName = PingResponse.init(
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
                                eventType: .custom,
                                eventName: "testevent",
                                attributes: [
                                    TriggerAttribute(name: "attributeone", value: "hi", type: .STRING, operator: .EQUALS)
                                ]
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
        
        static let caseSensitiveAttributeValue = PingResponse.init(
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
                                eventType: .custom,
                                eventName: "testevent",
                                attributes: [
                                    TriggerAttribute(name: "attributeone", value: "Hi", type: .STRING, operator: .EQUALS)
                                ]
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
                                    slideFrom: .BOTTOM,
                                    endTimeMillis: 1,
                                    textAlign: 1,
                                    optOut: false),
                                controlSettings: nil)
                        )
                    )
                )
            ]
        )
    }
}
