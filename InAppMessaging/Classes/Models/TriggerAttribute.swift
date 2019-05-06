/**
 * Model to represent a trigger's attribute sent back by the IAM Ping service.
 */
struct TriggerAttribute: Codable {
    let name: String
    let value: String
    let type: AttributeType
    let `operator`: AttributeOperator
}
