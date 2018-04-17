import Foundation

let defaultPrecondition = { Swift.precondition($0, $1, file:$2, line:$3) }
var evaluatePrecondition: (Bool, String, StaticString, UInt) -> Void = defaultPrecondition

func precondition(_ condition: @autoclosure () -> Bool,
                  _ message: @autoclosure () -> String = "",
                  file: StaticString = #file,
                  line: UInt = #line) {
  evaluatePrecondition(condition(), message(), file, line)
}

/*
 We are defining our own precondition function by promoting it from the Swift namespace to our own.
 We still preserve the default behavior through defaultPrecondition, which calls Swift.precondition.
 This gives us control on evaluatePrecondition for unit testing.
 */

/*
 @autoclosure is an automatically created closure to wrap an expression passed as a function arg.
 It lets us delay the closure evaluation until it is actually called.
 */
