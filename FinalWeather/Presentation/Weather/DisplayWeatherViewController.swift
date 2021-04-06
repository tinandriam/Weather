import UIKit
import Combine

class DisplayWeatherViewController: UITableViewController {

    // MARK: - UI Parameters

    lazy var headerView = DisplayWeatherHeaderView.loadFromNib()
    lazy var footerView = CurrentWeatherInfosView.loadFromNib()

    // MARK: - Parameters

    let viewModel: DisplayWeatherViewModel
    var bag: Set<AnyCancellable> = []

    // MARK: - Initilizers

    init(viewModel: DisplayWeatherViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        viewModel.location.receive(on: DispatchQueue.main).sink { [weak self] (location) in
            if let location = location {
                self?.setWeatherData(location: location)
                self?.tableView.reloadData()
            }
        }.store(in: &bag)

        self.footerView.tapButton = self.changeLocationButtonTapped
        self.tableView.tableHeaderView = self.headerView
        self.tableView.tableFooterView = self.footerView
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.registerForecastCell()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let location = viewModel.location.value {
            self.setWeatherData(location: location)
        } else {
            self.openAddLocationViewController()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.updateHeaderHeight()
        self.updateFooterHeight()
    }
    // MARK: - Functions

    // Automatically update tableViewHeader's height using autolayout
    func updateHeaderHeight() {
        guard let header = tableView.tableHeaderView else { return }
        // Automatically compute height using auto-layout
        let width = tableView.bounds.size.width
        let size = header.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        )
        if header.frame.size.height != size.height {
            header.frame.size.height = size.height
            tableView.tableHeaderView = header
        }
    }

    func updateFooterHeight() {
        guard let footer = tableView.tableFooterView else { return }
        // Automatically compute height using auto-layout
        let width = tableView.bounds.size.width
        let size = footer.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        )
        if footer.frame.size.height != size.height {
            footer.frame.size.height = size.height
            tableView.tableFooterView = footer
        }
    }

    func setLocationData(location: Location) {
        viewModel.location.value = location
    }

    func setWeatherData(location: Location) {
        let clothesUseCase: SetClothesToWearUseCaseProtocol = SetClothesToWearUseCase()

        self.headerView.cityNameLabel.text = location.cityName

        guard let today = viewModel.today else { return }

        self.headerView.temperatureLabel.text = String(Int(today.temperature)) + "°"
        self.headerView.weatherImageView.image = UIImage(named: today.mainWeather)

        let clothes = self.makeClothesToWearArray(clothesType: clothesUseCase.setClothesToWear(day: today))
        for view in self.headerView.clothesStackView.arrangedSubviews {
            self.headerView.clothesStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        for cloth in clothes {
            let clothImageView = UIImageView(image: UIImage(named: cloth))
            clothImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            clothImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
            self.headerView.clothesStackView.addArrangedSubview(clothImageView)
        }

        self.footerView.maxTemperatureLabel.text = String(Int(today.maxTemp)) + "°c"
        self.footerView.minTemperatureLabel.text = String(Int(today.minTemp)) + "°c"
        self.footerView.windSpeedLabel.text = String(Int(clothesUseCase.computeWindSpeed(today.windSpeed))) + "km/h"
    }

    func makeClothesToWearArray(clothesType: [Clothes]) -> [String] {
        var clothesName: [String] = []
        for clothe in clothesType {
            clothesName.append(clothe.rawValue)
        }
        return(clothesName)
    }

    func openAddLocationViewController() {
        let setLocationViewModel = AddLocationViewModel(cityName: nil)
        let setLocationViewController = AddLocationViewController(
            viewModel: setLocationViewModel,
            locationAdded: { [weak self] location in
                self?.dismiss(animated: true)
                self?.setLocationData(location: location)
                self?.setWeatherData(location: location)
        })
        present(setLocationViewController, animated: true)
    }

    func changeLocationButtonTapped() {
        self.openAddLocationViewController()
    }

    // MARK: - Table View functions

    func registerForecastCell() {
        let forecastCell = UINib(nibName: "DisplayForecastWeatherCell",
                                 bundle: nil)
        self.tableView.register(forecastCell,
                                forCellReuseIdentifier: "DisplayForecastWeatherCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.viewModel.location.value?.forecast.count ?? 1) - 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let forecast = self.viewModel.forecast?[indexPath.row] else {
            return UITableViewCell()
        }

        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "DisplayForecastWeatherCell",
            for: indexPath
        ) as? DisplayForecastWeatherCell {

            cell.forecastWeatherIconImageView.image = UIImage(named: forecast.mainWeather)
            cell.forecastedDayLabel.text = self.viewModel.weekdayFromDate(date: forecast.date)
            cell.forecastedTemperatureLabel.text = String(Int(forecast.temperature)) + "°"
            return cell
        }
        return UITableViewCell()
    }
}
