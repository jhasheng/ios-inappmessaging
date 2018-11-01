/**
 * Protocol that is conformed to when impression tracking is needed.
 */
protocol ImpressionTrackable {
    typealias Property = Attribute
    
    var impressions: [Impression] { get set }
    var properties: [Property] { get set }
    
    /**
     *
     */
    func logImpression(withImpressionType type: ImpressionType, withProperties properties: [Property])
    
    func sendImpression()
    
}

extension ImpressionTrackable {
    func sendImpression() {
        ImpressionClient.pingImpression(self.impressions)
    }
}

//extension ImpressionTrackable where Self: Modal {
//
//     func logImpression(withImpressionType type: ImpressionType, withProperties properties: [Property]) {
//
//        // Log the impression.
//        impressions.append(
//            Impression(
//                type: type,
//                ts: Date().millisecondsSince1970
//            )
//        )
//
//        // Log the properties.
////        self.properties = properties
//    }
//}
