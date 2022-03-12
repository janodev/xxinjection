import Foundation

public struct ProfileEntity: Codable, Equatable {
    
    public var social: ProfileEntitySocial?
    public var siteOwner: Bool?
    public var twitter: String?
    public var numActiveProjects: String?
    public var lastName: String?
    public var useShorthandDurations: Bool?
    public var profile: String?
    public var userUUID: String?
    public var userName: String?
    public var id: String?
    public var phoneNumberOffice: String?
    public var featureUpdatesCount: String?
    public var phoneNumberMobile: String?
    public var currentFeatureAnnouncement: ProfileEntityCurrentFeatureAnnouncement?
    public var userType: UserTypeEntity
    public var firstName: String?
    public var imService: String?
    public var imHandle: String?
    public var openId: String?
    public var privateNotesText: String?
    public var phoneNumberOfficeExt: String?
    public var twoFactorAuthEnabled: Bool?
    public var companyId: String?
    public var documentEditorInstalled: Bool?
    public var hasAccessToNewProjects: Bool?
    public var phoneNumberFax: String?
    public var lastLogin: String?
    public var APIEnabled: Bool?
    public var hasFeatureUpdates: Bool?
    public var administrator: Bool?
    public var pid: String?
    public var profileText: String?
    public var phoneNumberHome: String?
    public var emailAddress: String?
    public var lengthOfDay: String?
    public var privateNotes: String?
    public var companyName: String?
    public var lastChangedOn: String?
    public var deleted: Bool?
    public var notes: String?
    public var phoneNumberMobileParts: ProfileEntityMobileParts?
    public var localization: ProfileEntityLocalization?
    public var permissions: ProfileEntityPermissions?
    public var userInvitedStatus: String?
    public var address: AddressEntity?
    public var hasDeskAccount: Bool?
    public var notifications: ProfileEntityNotifications?
    public var createdAt: String?
    public var textFormat: String?
    public var userInvitedDate: String?
    public var avatarUrl: String?
    public var inOwnerCompany: String?
    public var userInvited: String?
    public var emailAlt1: String?
    public var emailAlt2: String?
    public var emailAlt3: String?
    public var title: String?
    public var defaultViews: DefaultViewsEntity?
    public var isClientUser: Bool?
    public var preferences: ProfileEntityPreferences?
    
    enum CodingKeys: String, CodingKey {
        
        case social,
        siteOwner = "site-owner",
        twitter,
        numActiveProjects,
        lastName = "last-name",
        useShorthandDurations, profile,
        userUUID, userName = "user-name",
        id,
        phoneNumberOffice = "phone-number-office",
        featureUpdatesCount = "feature-updates-count",
        phoneNumberMobile = "phone-number-mobile",
        currentFeatureAnnouncement,
        userType = "user-type",
        firstName = "first-name",
        imService = "im-service",
        imHandle = "im-handle",
        openId,
        privateNotesText = "private-notes-text",
        phoneNumberOfficeExt = "phone-number-office-ext",
        twoFactorAuthEnabled, companyId = "company-id",
        documentEditorInstalled,
        hasAccessToNewProjects = "has-access-to-new-projects",
        phoneNumberFax = "phone-number-fax",
        lastLogin = "last-login",
        APIEnabled,
        hasFeatureUpdates = "has-feature-updates",
        administrator,
        pid,
        profileText = "profile-text",
        phoneNumberHome = "phone-number-home",
        emailAddress = "email-address",
        lengthOfDay,
        privateNotes = "private-notes",
        companyName = "company-name",
        lastChangedOn = "last-changed-on",
        deleted,
        notes,
        phoneNumberMobileParts = "phone-number-mobile-parts",
        localization,
        permissions,
        userInvitedStatus = "user-invited-status",
        address,
        hasDeskAccount = "has-desk-account",
        notifications,
        createdAt = "created-at",
        textFormat,
        userInvitedDate = "user-invited-date",
        avatarUrl = "avatar-url",
        inOwnerCompany = "in-owner-company",
        userInvited = "user-invited",
        emailAlt1 = "email-alt-1",
        emailAlt2 = "email-alt-2",
        emailAlt3 = "email-alt-3",
        title,
        defaultViews,
        isClientUser,
        preferences
    }
}
