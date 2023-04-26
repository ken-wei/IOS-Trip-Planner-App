//
//  HomeViewController.swift
//  Trip Planner
//
//  Created by Ken Wei Ooi on 20/08/2020.
//  Copyright © 2020 RMIT. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation


class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, Refresh {
    
    // Location Manager for Core Location
    var locationManager:CLLocationManager!
    @IBOutlet weak var userCurrentLocation: UILabel!
    @IBOutlet weak var currencySelection: UITextField!
    
    // Textfields on the homepage
    @IBOutlet weak var departureCity: UITextField!
    @IBOutlet weak var arrivalCity: UITextField!
    
    // Picker View for the Cities (Departure and Arrival)
    var pickerViewCurrency = UIPickerView()
    
    // Textfields for the date (Departure and Return)
    @IBOutlet weak var departureDate: UITextField!
    @IBOutlet weak var returnDate: UITextField!
    
    // DatePicker View for Return Date and Departure Date
    var departureDatePicker = UIDatePicker()
    var returnDatePicker = UIDatePicker()
    @IBOutlet weak var searchButton: UIButton!
    
    // Model Controller that contains the ViewModel state of the APP (Dependency Injection Pattern)
    var modelController: ModelController!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var currencyView: UIView!
    
    // Currencies for the picker
    var currencyAvailable:[String]  = ["AUD", "USD"]
    // Currency View Model
    var currencyViewModel = CurrencyViewModel()
    
    // Boolean to check which textfield for cities has been tapped
    var departureCityPressed = false
    var arrivalCityPressed = false
    
    // A list of cities that the users can select
    var departureCountrySN:String = ""
    var departureCountryFN:String = ""
    var arrivalCountryFN:String = ""
    var arrivalCountrySN:String = ""
    
    var fullName:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
            Core Location framework to get user's location
        */
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
        // Currency view Model
        currencyViewModel.delegate = self
        currencyViewModel.getAllCurrencies()
        
        // Picker view setup for currency
        pickerViewCurrency.dataSource = self
        pickerViewCurrency.delegate = self
        createCurrencyPicker()
        
        // Picker View setup for departure city
        departureCity.textAlignment = .center
        departureCity.placeholder = ""
        
        // PickerView setup for Arrival City
        arrivalCity.textAlignment = .center
        arrivalCity.placeholder = ""
        
        // Setup the date picker for departure date
        createDepartureDatePicker()
        createReturnDatePicker()
        
        // Setup placeholder for return and departure date
        returnDate.placeholder = ""
        departureDate.placeholder = ""
        
        // Corner radius for buttons and background
        searchButton.layer.cornerRadius = 2.5
        
        // Styling the views (DateView, CityView)
        dateView?.backgroundColor = UIColor(white: 1, alpha: 0.8)
        cityView?.backgroundColor = UIColor(white: 1, alpha: 0.8)
        currencyView?.backgroundColor = UIColor(white: 1, alpha: 0.8)
        cityView.layer.cornerRadius = 2;
        cityView.layer.masksToBounds = true;
        dateView.layer.cornerRadius = 2;
        dateView.layer.masksToBounds = true;
        currencyView.layer.cornerRadius = 2;
        currencyView.layer.masksToBounds = true;
        // Do any additional setup after loading the view.
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        returnDate.text = ""
    }
    
    /*
     * Functions to check if user tapped departure city and arrival city text field
     */
    
    // Function for departure City "Edit did begin"
    @IBAction func dpCityTextFieldTapped(_ sender: Any) {
        departureCityPressed = true
        departureCity.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .city //suitable filter type
        acController.autocompleteFilter = filter
        present(acController, animated: true, completion: nil)
    }
    
    // Function for arrival City "Edit did begin"
    @IBAction func returnCityTextFieldTapped(_ sender: Any) {
        arrivalCityPressed = true
        arrivalCity.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .city //suitable filter type
        acController.autocompleteFilter = filter
        present(acController, animated: true, completion: nil)
    }
    
    // Setup the departure date, cities for FlightInfoViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let flightInfoViewController = segue.destination as? FlightInfoViewController {
            flightInfoViewController.modelController = modelController
            let des = segue.destination as! FlightInfoViewController
            des.departureDate = departureDate.text!
            des.departureCity = departureCity.text!
            des.arrivalCity = arrivalCity.text!
            des.returnDate = returnDate.text!
            des.arrivalCountryFN = arrivalCountryFN
            des.arrivalCountrySN = arrivalCountrySN
            des.departureCountryFN = departureCountryFN
            des.departureCountrySN = departureCountrySN
            des.currency = currencySelection.text!
          
            flightInfoViewController.homeView = self
           
        }
    }
    
    // Refresh Protocol
    func updateUI() {

        self.currencyAvailable = currencyViewModel.currencies
        self.currencyAvailable.sort()

        pickerViewCurrency.reloadAllComponents()
        
    }
    
    /*
        Picker View for the Currency
     */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyAvailable.count
    }
    
    // returns the currency based on the row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyAvailable[row]
    }
    
    // Picker view setup for currency
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencySelection.text = currencyAvailable[row]
        self.currencySelection.font = UIFont.boldSystemFont(ofSize: 16.0)
    }
    
    // Setup for Picker View for Currency
    func createCurrencyPicker() {
        let currencyToolbar = UIToolbar()
        currencyToolbar.sizeToFit()
        
        let buttonReturnDone = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(pressedCurrencyDone))
        
        // Set the toolbar for DatePicker View
        currencyToolbar.setItems([buttonReturnDone], animated: true)
        
        currencySelection.inputAccessoryView = currencyToolbar
        currencySelection.inputView = pickerViewCurrency
        currencySelection.textAlignment = .center
        currencySelection.placeholder = "Currency"
    }
    
    // Update the textfield after "Done" Button in Picker View for Currency Selection being pressed
    @objc func pressedCurrencyDone() {
        currencySelection.text = currencyAvailable[pickerViewCurrency.selectedRow(inComponent: 0)]
        self.currencySelection.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.view.endEditing(true)
    }
    
    // Setup for DatePicker View
    func createDepartureDatePicker() {
        // Create toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let buttonDepartureDone = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(pressedDepartureDone))
        
        toolbar.setItems([buttonDepartureDone], animated: true)
        
        // Assign toolbar
        departureDate.inputAccessoryView = toolbar
        
        // Assign date picker to the departure date text field
        departureDate.inputView = departureDatePicker
        
        // Initialise the Date Picker Mode, min as the current date
        departureDatePicker.datePickerMode = .date
        departureDate.textAlignment = .center
        let currentDate = Date()
        departureDatePicker.minimumDate = currentDate
    }
    
    // Update the textfield after "Done" Button in Picker View for Departure Date being pressed
    @objc func pressedDepartureDone() {
        
        let departureDateFormatter = DateFormatter()
        departureDateFormatter.dateStyle = .short
        departureDateFormatter.timeStyle = .none
        departureDateFormatter.dateFormat = "yyyy-MM-dd"
        
        departureDate.text = departureDateFormatter.string(from: departureDatePicker.date)
        
        // Setup the minimum date for return date
        // Reactivate the user interaction for departureDatePicker
        if returnDate.text!.count > 0 || returnDate.text!.count == 0 {
            returnDate.text = ""
            returnDate.isUserInteractionEnabled = true
            returnDatePicker.minimumDate = departureDatePicker.date
            returnDate.backgroundColor = UIColor.white
        }
        self.view.endEditing(true)
    }
    
    // Setup for DatePicker Return Date View
    func createReturnDatePicker() {
        let returnDateToolbar = UIToolbar()
        returnDateToolbar.sizeToFit()
        
        let buttonReturnDone = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(pressedReturnDone))
        
        // Set the toolbar for DatePicker View
        returnDateToolbar.setItems([buttonReturnDone], animated: true)
        
        returnDate.inputAccessoryView = returnDateToolbar
        returnDate.inputView = returnDatePicker
        returnDatePicker.datePickerMode = .date
        returnDate.textAlignment = .center
        
        // Disabling the button first (Have to enter departure date first)
        returnDate.isUserInteractionEnabled = false
        returnDate.backgroundColor = UIColor.lightGray
        
    }
    
    // Update the textfield after "Done" Button in Picker View for Return Date being pressed
    @objc func pressedReturnDone() {
        let returnDateFormatter = DateFormatter()
        returnDateFormatter.dateStyle = .short
        returnDateFormatter.timeStyle = .none
        returnDateFormatter.dateFormat = "yyyy-MM-dd"
        returnDate.text = returnDateFormatter.string(from: returnDatePicker.date)
        self.view.endEditing(true)
    }
    
    // Alert function for creating an alert
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Validation of data before performing segue
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // Data validation for departure date, city, arrival city, arrival date
        if departureCity.text!.count > 0 && arrivalCity.text!.count > 0 && departureDate.text!.count > 0{
            if currencySelection.text!.count > 0 {
                if departureDate.text!.count > 0 {
                    if dateFormatter.date(from: departureDate.text!) != nil {
                        if returnDate.text!.count != 0 && dateFormatter.date(from: returnDate.text!) == nil {
                            return false
                        }
                        return true
                    }
                }
            }
        }
        createAlert(title: "Invalid Input", message: "Please fill in all the required fields!")
        return false
    }
    
    //MARK: - location delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        _ = String(userLocation.coordinate.latitude) + ", " + String(userLocation.coordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                var country = ""
                var locality = ""
                var administrativeArea = ""
                if let placeCountry = placemark.country {
                    country = ", " + placeCountry
                }
                if let placeLocality = placemark.locality {
                    locality = locality + placeLocality
                }
                if let placeAdministrativeArea = placemark.administrativeArea {
                    administrativeArea = ", " + placeAdministrativeArea
                }
                self.userCurrentLocation.text = "\(locality)\(administrativeArea)\(country)"
                // Goes to the other line if doesn't fit
                self.userCurrentLocation.lineBreakMode = .byWordWrapping
                self.userCurrentLocation.numberOfLines = 0
                self.userCurrentLocation.font = UIFont.boldSystemFont(ofSize: 16.0)
                if let currency = self.currencyViewModel.getCurrencyFromCountryCode(country_code: placemark.country!) {
                    self.currencySelection.text = currency
                    
                    self.currencySelection.font = UIFont.boldSystemFont(ofSize: 16.0)
                } else {
                    //
                }

            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Error
    }

}

// EXTENSION FOR GOOGLE PLACES VIEW CONTROLLER //

extension HomeViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        var countryShortName = ""
        var countryFullName = ""
        for addressComponent in (place.addressComponents)! {
            for type in (addressComponent.types){
                if type == "country" {
                    let country = addressComponent.name
                    let countryShort = addressComponent.shortName
                    countryShortName = countryShort!
                    countryFullName = country

                }
            }
        }
        
        // If user tapped on departure city text field
        if departureCityPressed {
            departureCity.text = place.name
            departureCity.font = UIFont.boldSystemFont(ofSize: 16.0)
            departureCityPressed = false
            departureCountryFN = countryFullName
            departureCountrySN = countryShortName
        } else if arrivalCityPressed {
            arrivalCity.text = place.name
            arrivalCity.font = UIFont.boldSystemFont(ofSize: 16.0)
            arrivalCityPressed = false
            arrivalCountryFN = countryFullName
            arrivalCountrySN = countryShortName
        }
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}

