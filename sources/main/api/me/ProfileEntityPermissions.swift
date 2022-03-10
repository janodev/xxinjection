import Foundation

public struct ProfileEntityPermissions: Codable, Equatable {
    
    public var canManagePeople: Bool?
    public var hasAccessToNewProjects: Bool?
    public var canAddProjects: Bool?
    public var canManagePortfolio: Bool?
    public var administrator: Bool?
    public var canAccessTemplates: Bool?
    public var canAccessPortfolio: Bool?
    public var canAccessCalendar: Bool?

    enum CodingKeys: String, CodingKey {
        
        case canManagePeople = "can-manage-people",
        hasAccessToNewProjects = "has-access-to-new-projects",
        canAddProjects = "can-add-projects",
        canManagePortfolio,
        administrator,
        canAccessTemplates = "can-access-templates",
        canAccessPortfolio,
        canAccessCalendar
    }
}
