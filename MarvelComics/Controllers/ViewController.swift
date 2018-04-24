import UIKit

class ViewController: UIViewController {

  var tableView: UITableView!
  var service: FetchCharactersMarvelService!
  var results: [CharacterResponseModel]!

  let cellID = "ResultCell"

  override func viewDidLoad() {
    super.viewDidLoad()

    service = FetchCharactersMarvelService(session: URLSession.shared) {
      return MarvelAuthentication().urlParameters()
    }

    setupUI()

    // Test
    fetchCharacters(for: "Spider")
  }

  private func setupUI() {
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    let viewWidth = self.view.frame.width
    let viewHeight = self.view.frame.height
    let frame = CGRect(x: 0, y: statusBarHeight,
                       width: viewWidth, height: viewHeight - statusBarHeight)
    setupTableView(frame: frame)
  }

  private func setupTableView(frame: CGRect) {
    tableView = UITableView(frame: frame, style: .plain)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    tableView.delegate = self
    tableView.dataSource = self
    self.view.addSubview(tableView)
  }


  func fetchCharacters(for prefix: String) {
    let requestModel = FetchCharactersRequestModel(namePrefix: prefix, limit: 10, offset: 0)
    service.fetchCharacters(requestModel: requestModel, networkRequest: NetworkRequest()) {
      responseModel in
      switch responseModel {
      case let .success(charactersSlice):
        self.results = charactersSlice.characters
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      case let .failure(error):
        print("error: \(error)")
      }
    }
  }

}

extension ViewController: UITableViewDelegate {

}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return results?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
    cell.textLabel?.text = results?[indexPath.row].name
    return cell
  }
}

