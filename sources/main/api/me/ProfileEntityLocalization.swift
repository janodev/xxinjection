import Foundation

public struct ProfileEntityLocalization: Codable, Equatable {
    
    public var timeFormat: String?
    public var languageCode: String?
    public var language: String?
    public var timezoneUTCOffsetMins: String?
    public var timezoneId: String?
    public var timezoneString: String?
    public var dateFormatId: String?
    public var startOnSunday: Bool?
    public var dateFormat: String?
    public var timezoneJavaRefCode: String?
    public var timeFormatId: String?
 
    enum CodingKeys: String, CodingKey {
        
        case timeFormat,
        languageCode,
        language,
        timezoneUTCOffsetMins,
        timezoneId,
        timezoneString = "timezone",
        dateFormatId,
        startOnSunday = "start-on-sunday",
        dateFormat,
        timezoneJavaRefCode,
        timeFormatId
    }
}
