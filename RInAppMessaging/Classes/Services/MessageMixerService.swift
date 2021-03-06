internal protocol MessageMixerServiceType {
    func ping() -> Result<PingResponse, MessageMixerServiceError>
}

internal enum MessageMixerServiceError: Error {
    case requestError(RequestError)
    case jsonDecodingError(Error)
    case invalidConfiguration
}

internal class MessageMixerService: MessageMixerServiceType, HttpRequestable {

    private let preferenceRepository: IAMPreferenceRepository
    private let configurationRepository: ConfigurationRepositoryType

    weak var errorDelegate: ErrorDelegate?
    private(set) var httpSession: URLSession
    var bundleInfo = BundleInfo.self

    init(preferenceRepository: IAMPreferenceRepository,
         configurationRepository: ConfigurationRepositoryType) {

        self.preferenceRepository = preferenceRepository
        self.configurationRepository = configurationRepository
        httpSession = URLSession(configuration: configurationRepository.defaultHttpSessionConfiguration)
    }

    func ping() -> Result<PingResponse, MessageMixerServiceError> {

        guard let mixerServerUrl = configurationRepository.getEndpoints()?.ping else {
            let error = "Error retrieving InAppMessaging Mixer Server URL"
            CommonUtility.debugPrint(error)
            return .failure(.invalidConfiguration)
        }

        let response = requestFromServerSync(
            url: mixerServerUrl,
            httpMethod: .post,
            addtionalHeaders: buildRequestHeader()
        )

        switch response {
        case .success((let data, _)):
            return parseResponse(data).mapError {
                return MessageMixerServiceError.jsonDecodingError($0)
            }
        case .failure(let requestError):
            return .failure(.requestError(requestError))
        }
    }

    private func parseResponse(_ response: Data) -> Result<PingResponse, Error> {
        do {
            let response = try JSONDecoder().decode(PingResponse.self, from: response)
            return .success(response)
        } catch {
            let description = "Failed to parse json"
            CommonUtility.debugPrint("\(description): \(error)")
            return .failure(error)
        }
    }
}

// MARK: - HttpRequestable implementation
extension MessageMixerService {

    func buildHttpBody(with parameters: [String: Any]?) -> Result<Data, Error> {

        guard let appVersion = bundleInfo.appVersion else {
            CommonUtility.debugPrint("failed creating a request body")
            assertionFailure()
            return .failure(RequestError.unknown)
        }

        let pingRequest = PingRequest(
            userIdentifiers: preferenceRepository.getUserIdentifiers(),
            appVersion: appVersion)

        do {
            let body = try JSONEncoder().encode(pingRequest)
            return .success(body)
        } catch let error {
            CommonUtility.debugPrint("failed creating a request body - \(error)")
            return .failure(error)
        }
    }

    private func buildRequestHeader() -> [HeaderAttribute] {
        let Keys = Constants.Request.Header.self
        var additionalHeaders: [HeaderAttribute] = []

        if let subId = bundleInfo.inAppSubscriptionId {
            additionalHeaders.append(HeaderAttribute(key: Keys.subscriptionID, value: subId))
        }

        if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
            additionalHeaders.append(HeaderAttribute(key: Keys.deviceID, value: deviceId))
        }

        if let accessToken = preferenceRepository.getAccessToken() {
            additionalHeaders.append(HeaderAttribute(key: Keys.authorization, value: "OAuth2 \(accessToken)"))
        }

        return additionalHeaders
    }
}
