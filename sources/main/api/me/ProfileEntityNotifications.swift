import Foundation

public struct ProfileEntityNotifications: Codable, Equatable {
    
    public var receiveMyNotificationsOnly: Bool?
    public var receiveDailyReportsAtWeekend: Bool?
    public var receiveDailyReportsAtTime: String?
    public var soundAlertsEnabled: Bool?
    public var notifyOnAddedAsAFollower: Bool?
    public var notifyOnStatusUpdate: Bool?
    public var dailyReportSortBy: String?
    public var notifyOnTaskComplete: Bool?
    public var dailyReportDaysFilter: String?
    public var receiveNotifyWarnings: Bool?
    public var receiveDailyReports: Bool?
    public var receiveDailyReportsIfEmpty: Bool?

    enum CodingKeys: String, CodingKey {
        
        case receiveMyNotificationsOnly = "receive-my-notifications-only",
        receiveDailyReportsAtWeekend = "receive-daily-reports-at-weekend",
        receiveDailyReportsAtTime = "receive-daily-reports-at-time",
        soundAlertsEnabled = "sound-alerts-enabled",
        notifyOnAddedAsAFollower = "notify-on-added-as-follower",
        notifyOnStatusUpdate = "notify-on-status-update",
        dailyReportSortBy = "daily-report-sort-by",
        notifyOnTaskComplete = "notify-on-task-complete",
        dailyReportDaysFilter = "daily-report-days-filter",
        receiveNotifyWarnings = "receive-notify-warnings",
        receiveDailyReports = "receive-daily-reports",
        receiveDailyReportsIfEmpty = "receive-daily-reports-if-empty"
    }
}
