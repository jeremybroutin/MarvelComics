import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    /* Spike solution: to be replaced with TDD! */

    // Concatenate keys per https://developer.marvel.com/documentation/authorization
    let timeStamp = "1"
    let keys = timeStamp + MarvelKeys.privateKey.rawValue + MarvelKeys.publicKey.rawValue

    // Confirm manually
    print(keys)

    // Create MD5 hash
    let hash = keys.MD5Digest()

    // Manually confirm that it's 32 hex digits:
    print(hash)

    // Manually confirm URL string:
    let urlString = "https://gateway.marvel.com/v1/public/characters" + "?nameStartsWith=Spider" +
        "&ts=\(timeStamp)&apikey=\(MarvelKeys.publicKey.rawValue)&hash=\(hash)"
    print(urlString)

    // Create data task
    let session = URLSession.shared
    let url = URL(string: urlString)!
    let dataTask = session.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print("error: \(error)")
      } else {
        if let response = response {
          print("response: \(response)")
        }
        if let data = data, let str = String(data: data, encoding: .utf8) {
          print("data: \(str)")
        }
      }
    }
//    dataTask.resume()
  }
}

