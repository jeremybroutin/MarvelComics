import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let service = FetchCharactersMarvelService(session: URLSession.shared) { () -> String in
      return MarvelAuthentication().urlParameters()
    }
    let requestModel = FetchCharactersRequestModel(namePrefix: "Spider", pageSize: 1, offset: 0)
    service.fetchCharacters(requestModel: requestModel, networkRequest: NetworkRequest())
  }
}

