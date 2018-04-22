import Foundation

protocol URLSessionProtocol {
  func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

struct FetchCharactersMarvelService {

  private let session: URLSessionProtocol
  private let authParametersGenerator: () -> String

  init(session: URLSessionProtocol, authParametersGenerator: @escaping () -> String) {
    self.session = session
    self.authParametersGenerator = authParametersGenerator
  }

  func fetchCharacters(requestModel: FetchCharactersRequestModel, networkRequest: NetworkRequest) {
    guard let url = makeURL(requestModel: requestModel) else { return }
    let dataTask = session.dataTask(with: url) { (data, response, error) in

      print("error: \(String(describing:error))")
      print("response: \(String(describing:response))")
      print("data: \(String(describing:data))")

      // TODO: pass data to FetchCharactersResponseBuilder
      // Build FCResponseBuilder to get a CharactersSliceResponseModel
      // Which will have an array of CharacterResponseModel

      // Spike code
      let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
      let fcResponseBuilder = FetchCharactersResponseBuilder(dictionary: json)
      let fcResult = fcResponseBuilder.build()
      switch fcResult {
      case .success(let charactersSlice):
        print(charactersSlice.characters)
      case .failure(let failure):
        print(failure)
      }
    }
    networkRequest.start(dataTask)
  }

  private func makeURL(requestModel: FetchCharactersRequestModel) -> URL? {
    guard let namePrefix =
      requestModel.namePrefix.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    else {
      return nil
    }
    return URL(string: "https://gateway.marvel.com/v1/public/characters" +
      "?nameStartsWith=\(namePrefix)" +
      "&limit=\(requestModel.pageSize)" +
      "&offset=\(requestModel.offset)" +
      authParametersGenerator())
  }
}
