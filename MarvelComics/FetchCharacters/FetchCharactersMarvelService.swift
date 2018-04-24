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

  func fetchCharacters(requestModel: FetchCharactersRequestModel, networkRequest: NetworkRequest,
                       completion: @escaping (FetchCharactersResponseModel) -> Void) {
    guard let url = makeURL(requestModel: requestModel) else { return }
    let dataTask = session.dataTask(with: url) { (data, response, error) in
      if let error = error {
        completion(.failure("FetchCharacters dataTask error: \(error.localizedDescription)"))
      } else if let data = data {
        let result = FetchCharactersParser.parse(jsonData: data)
        completion(result)
      } else {
        completion(.failure("FetchCharacters unknown error."))
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
      "&limit=\(requestModel.limit)" +
      "&offset=\(requestModel.offset)" +
      authParametersGenerator())
  }
}
