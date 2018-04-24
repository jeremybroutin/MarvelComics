//struct FetchCharactersResponseModel {
//  let code: Int
//  let status: String
//}

enum Result<T> {
  case success(T)
  case failure(String)
}

typealias FetchCharactersResponseModel = Result<CharactersSliceResponseModel>

/*
 This implementation replaces the standard struct with code and status properties.
 Instead we simply build an enum with associated values to understand the success
 or failure of the fetch request, and attach data to the success or error details
 to the failure.

 It allows reusability by the use of generics.
 */

