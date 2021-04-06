import UIKit

class EditLocationViewController: UIViewController {

    // MARK: - UI Paramteres

    @IBOutlet var cityNameTextField: UITextField!

    // MARK: - Parameters

    let viewModel: EditLocationViewModel
    let locationSelected: (Location) -> Void

    // MARK: - Initializers

    init(viewModel: EditLocationViewModel, locationSelected: @escaping (Location) -> Void) {
        self.viewModel = viewModel
        self.locationSelected = locationSelected
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    @IBAction func sendCityName() {
        let cityName = cityNameTextField.text?.capitalized ?? ""
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
                            handler: {(_) -> Void in
                                print("ok")
                            })
                        errorMessageAlert.addAction(acknowledge)
                        self.present(errorMessageAlert, animated: true, completion: nil)
                    }
                case .success(let coordinates):
                    do {
                        let location = try self.viewModel.createLocation(
                            addressString: cityName,
                            coordinates: coordinates
                        )
                        self.locationSelected(location)
                    } catch {
                        print(error)
                    }
                }
            }
        )
    }
}
