import Foundation

protocol URLSessionProtocol {
  func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

struct FetchCharactersMarvelService {

  private let session: URLSessionProtocol

  init(session: URLSessionProtocol) {
    self.session = session
  }

  func fetchCharacters(requestModel: FetchCharactersRequestModel) {
    
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
      "&offset=\(requestModel.offset)")
  }
}
