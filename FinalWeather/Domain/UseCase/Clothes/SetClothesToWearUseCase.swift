import Foundation

protocol SetClothesToWearUseCaseProtocol {
    func setClothesToWear(day: Day) -> [Clothes]
    func computeWindSpeed(_ windSpeed: Double) -> Double
}

class SetClothesToWearUseCase: SetClothesToWearUseCaseProtocol {

    // MARK: - Function

    func computeWindSpeed(_ windSpeed: Double) -> Double {
        return (windSpeed * 18) / 5
    }

    func setClothesToWear(day: Day) -> [Clothes] {
        var clothesToWear: [Clothes] = []

        if day.mainWeather == "Clear" {
            clothesToWear.append(Clothes.sunglasses)
        }
        if day.mainWeather == "Rain" {
            clothesToWear.append(Clothes.raincoat)
        }
        if day.temperature < 5.0 {
            clothesToWear.append(Clothes.winterJacket)
        }
        if day.temperature < 20.0 && day.temperature > 5.0 {
            clothesToWear.append(Clothes.sweater)
        }
        if (day.temperature > 5.0 && day.temperature < 25.0) && self.computeWindSpeed(day.windSpeed) > 20.0 {
            clothesToWear.append(Clothes.windBreaker)
        }
        return clothesToWear
    }
}
