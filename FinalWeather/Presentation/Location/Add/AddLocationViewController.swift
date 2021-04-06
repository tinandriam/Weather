import UIKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {

    // MARK: - UI Paramteres

    @IBOutlet var cityNameTextField: UITextField!
    @IBOutlet weak var welcomeText: UILabel!
    
    // MARK: - Parameters

    let viewModel: AddLocationViewModel
    var locationAdded: (Location) -> Void

    // MARK: - Initializers

    init(viewModel: AddLocationViewModel, locationAdded: @escaping (Location) -> Void) {
        self.viewModel = viewModel
        self.locationAdded = locationAdded
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupWelcomeText()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cityNameTextField.delegate = self
    }

    // MARK: - Functions

    func setupWelcomeText() {
        var locationNumber: Int

        do {
            locationNumber = try viewModel.countLocationNumber()
        } catch {
            locationNumber = 0
        }

        if locationNumber == 0 {
            welcomeText.text = "Welcome to FinalWeather. Please first enter your city name."
        } else {
            welcomeText.text = "Please enter a city name."
        }
    }

    @IBAction func confirmCityName(_ sender: UIButton) {
        self.sendCityName()
    }

    func sendCityName() {
        let cityName = cityNameTextField.text?.capitalized ?? ""

        do {
            self.locationAdded(try viewModel.fetchLocationBy(cityName: cityName))
        } catch DataStoreError.notFound {
            viewModel.getCoordinate(addressString: cityName, coordinatesCompletionHandler: { [weak self] result in
                guard let self = self else { return }
                    switch result {
                    case .failure(let error):
                        if error == .geocoderFailed {
                            let errorMessageAlert = UIAlertController(
                                title: "Error",
                                message: "We couldn't find your city.",
                                preferredStyle: .alert
                            )
                            let acknowledge = UIAlertAction(
                                title: "Undertsood",
                                style: .default,
                                handler: {(_) -> Void in }
                            )
                            errorMessageAlert.addAction(acknowledge)
                            self.present(errorMessageAlert, animated: true, completion: nil)
                        }
                    case .success(let coordinates):
                        do {
                            let location = try self.viewModel.addLocation(addressString: cityName, coordinates: coordinates)
                            self.locationAdded(location)
                        } catch {
                            print(error)
                        }
                    }
                }
            )
        } catch {
            print(error)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn called")
        textField.resignFirstResponder()
        self.sendCityName()
        return true
    }
}
