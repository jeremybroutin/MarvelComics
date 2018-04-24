import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let service = FetchCharactersMarvelService(session: URLSession.shared) { () -> String in
      return MarvelAuthentication().urlParameters()
    }
    let requestModel = FetchCharactersRequestModel(namePrefix: "Spider", limit: 10, offset: 0)
    service.fetchCharacters(requestModel: requestModel, networkRequest: NetworkRequest()) {
      responseModel in
      switch responseModel {
      case let .success(charactersSlice):
        print("success: \(charactersSlice)")
      case let .failure(error):
        print("error: \(error)")
      }
    }
  }
}

