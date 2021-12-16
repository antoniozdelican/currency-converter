# Currency Converter

This is a currency converter app that communicates with the TrasferGo API. It returns currency conversions from EUR, GBP, RUB, PLN, RON, UAH, TRY based on the user input.

## Architecture and technologies

The architecture used for this project is MVVM with SwiftUI on the UI layer. RxSwift is also used for the networking and API layer and getting responses in the view model.
There are some unit tests that cover basic APIManager functionalities.
Dependecy injection with protocols of API and network managers is used for easier testability with mocks.
App supports iOS versions 13.0 and greater.

## Basic app functionalities

The app comes with a single screen where user can:
 - choose which currency to convert from
 - choose which currency to convert to
 - enter desired amount to convert

Tapping on the convert button, the inital API request is done towards backend. Upon response, the UI is updated with the converted amount together with the exchange rate. 

 After the inital conversion, the convert button is no longer shown and all the conversion requests are done dynamically as user interacts with the screen:
 - when user inputs values in either of the text fields
 - when user selects different from or to currency with the picker
 - when pressing on switch button

## How to test the app

 In order to test the app, please follow:
 - clone the repository to your local machine
 - Go in the root directory and run
 ```bash
 pod install
 ```
 to install RxSwift and RxCocoa pods. If you don't have CocoaPods get them here: https://cocoapods.org/
- open Xcode and run the app

## Improvements

Stuff missing or could be improved due to time restrictions:
 - some loading state when the convert button would be disabled before the first conversion
 - more unit tests specially for viewModel
 - cleaned the ContentView with more general views instead of everything in one struct (like it was done the with PickerView)
 - improve FocusedTextFieldType logic - it's kinda messy now and it should be cleaner


