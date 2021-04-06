import Foundation

//enum DailyForecastError: Error {
//    case notFound
//}
//
//struct DailyForecast {
//    
//    // MARK: - Parameter
//    
//    // forecast on 7 days
//    var forecast: [Day]?
//
//    // MARK: - Functions
//    
//    mutating func add(_ day: Day) {
//        self.forecast?.append(day)
//    }
//    
//    mutating func getDay(_ number: Int) throws -> Day {
//        if let day = self.forecast?[number] {
//            return day
//        }
//        throw DailyForecastError.notFound
//    }
//}
//
