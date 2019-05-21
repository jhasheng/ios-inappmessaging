/**
 * Struct to handle permission checking before displaying a campaign.
 */
struct PermissionClient: HttpRequestable {

    /**
     * Function that will handle communicating with the display_permission endpoint and handling the response.
     * By default, if anything goes wrong with the communication, return true and show the campaign.
     * @param { campaign: CampaignData } campaign that is about to be shown.
     * @returns { Bool } boolean to signal the SDK to either show or don't show the campaign.
     */
    func checkPermission(withCampaign campaign: CampaignData) -> Bool {

        let requestParams = [
            Constants.Request.CampaignID: campaign.campaignId
        ]

        // Call display-permission endpoint.
        guard let displayPermissionUrl = ConfigurationClient.endpoints?.displayPermission,
            let responseFromDisplayPermission =
                self.requestFromServer(
                    withUrl: displayPermissionUrl,
                    withHttpMethod: .post,
                    withOptionalParams: requestParams,
                    withAdditionalHeaders: buildRequestHeader(),
                    withSemaphoreWait: true).data
        else {
            return true
        }

        // Parse and handle the response.
        do {
            let decodedResponse = try JSONDecoder().decode(DisplayPermissionResponse.self, from: responseFromDisplayPermission)
            
            if decodedResponse.performPing {
                // Perform a re-ping.
                MessageMixerClient().ping()
            }
            
            // Return the response from the display_permission endpoint.
            return decodedResponse.display

        } catch {
            #if DEBUG
                print("InAppMessaging: error getting a response from display permission.")
            #endif
        }

        return true
    }

    /**
     * Request body for display permission check.
     * @param { optionalParams: [String: Any]? } additional params to be added to the request body.
     * @returns { Data? } optional serialized data for the request body.
     */
    internal func buildHttpBody(withOptionalParams optionalParams: [String: Any]?) -> Data? {

        guard let subscriptionId = Bundle.inAppSubscriptionId,
            let campaignId = optionalParams![Constants.Request.CampaignID],
            let appVersion = Bundle.appVersion,
            let sdkVersion = Bundle.inAppSdkVersion,
            let locale = Locale.formattedCode
        else {
            #if DEBUG
                print("InAppMessaging: error while building request body for display_permssion.")
            #endif
            return nil
        }

        let permissionRequest = DisplayPermissionRequest.init(
            subscriptionId: subscriptionId,
            campaignId: campaignId as! String,
            userIdentifiers: IAMPreferenceRepository.getUserIdentifiers(),
            platform: PlatformEnum.ios.rawValue,
            appVersion: appVersion,
            sdkVersion: sdkVersion,
            locale: locale,
            lastPingInMillis: PingResponseRepository.currentPingMillis ?? 0
        )

        do {
            return try JSONEncoder().encode(permissionRequest)
        } catch {
            #if DEBUG
                print("InAppMessaging: failed creating a request body.")
            #endif
        }

        return nil
    }
    
    fileprivate func buildRequestHeader() -> [Attribute] {
        var additionalHeaders: [Attribute] = []

        // Retrieve sub ID and return in header of the request.
        if let subId = Bundle.inAppSubscriptionId {
            additionalHeaders.append(Attribute(withKeyName: Constants.Request.subscriptionHeader, withValue: subId))
        }
        
        // Retrieve access token and return in the header of the request.
        if let accessToken = IAMPreferenceRepository.getAccessToken() {
            additionalHeaders.append(Attribute(withKeyName: Constants.Request.authorization, withValue: "OAuth2 \(accessToken)"))
        }
        
        return additionalHeaders
    }
}
