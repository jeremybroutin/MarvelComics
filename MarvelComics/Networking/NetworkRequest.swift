import Foundation

protocol URLSessionTaskProtocol: class {
  func resume()
  func cancel()

  /*
   Uses the "interface segmentation principle" by taking just a slice of of URLSessionTask.
   Here we only stub resume() and cancel().
   */

  /*
   Enforce protocol conformance for classes only to allow the use of the "==="
   operator between two instances.
   */
}

extension URLSessionTask: URLSessionTaskProtocol {}

class NetworkRequest {

  private(set) var currentTask: URLSessionTaskProtocol?

  func start(_ task: URLSessionTaskProtocol) {
    precondition(currentTask == nil)
    currentTask = task
    currentTask?.resume()

    /*
     precondition check for necessary condition for making progress forward.
     It will stop execution in released code (-0 builds) compared to an assertion.
     */

  }

  func cancel() {
    currentTask?.cancel()
    currentTask = nil
  }
}
