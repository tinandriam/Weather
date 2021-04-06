import Foundation
import CoreLocation

protocol AddLocationViewModelProtocol {
    func addLocation(addressString: String, coordinates: CLLocationCoordinate2D) throws -> Location
}

struct AddLocationViewModel: AddLocationViewModelProtocol {

    // MARK: - Parameters

    var cityName: String?
    let weatherClient = WeatherClient()
    let addLocationUseCase: AddLocationUseCaseProtocol = AddLocationUseCase()
    let countLocationsUseCase: CountLocationsUseCaseProtocol = CountLocationsUseCase()

    // MARK: - Initializer

    init(cityName: String?) {
        self.cityName = cityName
    }

    // MARK: - Function

    func countLocationNumber() throws -> Int {
        return try countLocationsUseCase.fetchLocationNumber()
    }

    func addLocation(addressString: String, coordinates: CLLocationCoordinate2D) throws -> Location {
        var location = try addLocationUseCase.addLocation(cityName: addressString, coordinates: coordinates)
        getWeatherData(location: location, weatherCompletionHandler: { result in
            switch result {
            case .failure:
                break
            case .success(let weather):
                location.forecast = storeWeather(location: location, weather: weather)
            }
        })
        return location
    }

    func fetchLocationBy(cityName: String) throws -> Location {
        let useCase: FetchLocationByNameUseCaseProtocol = FetchLocationByNameUseCase()
        return try useCase.fetchLocationBy(cityName: cityName)
    }

    func getCoordinate(
        addressString: String,
        coordinatesCompletionHandler: @escaping (
            Result<CLLocationCoordinate2D, GeolocationError>) -> Void
    ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            guard error == nil else {
                coordinatesCompletionHandler(.failure(.geocoderFailed))
                return
            }
            guard let location = placemarks?[0].location else {
                coordinatesCompletionHandler(.failure(.noResult))
                return
            }
            coordinatesCompletionHandler(.success(location.coordinate))
        }
    }

    func getWeatherData(
        location: Location,
        weatherCompletionHandler: @escaping (Result<WeatherRepresentation, WeatherClientError>) -> Void
    ) {
        weatherClient.getWeatherData(location: location, weatherCompletionHandler: { result in
            switch result {
            case .failure(let error):
                if error == WeatherClientError.tooManyRequests {
                    weatherCompletionHandler(.failure(WeatherClientError.tooManyRequests))
                } else {
                    weatherCompletionHandler(.failure(WeatherClientError.apiError))
                }
            case .success(let weather):
                weatherCompletionHandler(.success(weather))
            }
        })
    }

    func storeWeather(location: Location, weather: WeatherRepresentation) -> [Day] {
        let dayRepository = DayRepository()
        var forecast: [Day] = []

        for day in weather.daily {
            if let tmp = try? dayRepository.createDay(forecast: day, location: location) {
                forecast.append(tmp)
            }
        }
        return forecast
    }
}
