module ElmTest.Runner.Tap (runDisplay) where

{-| Run a test suite and display it in TAP13 format.

# Run
@docs runDisplay

-}

import String
import Console exposing (..)
import ElmTest.Run as Run
import ElmTest.Test exposing (..)


version : String
version =
  "TAP version 13"


plan : Int -> String
plan n =
  if n > 0 then
    "1.." ++ (toString n)
  else
    ""


indent : String -> String
indent str =
  String.join "\n"
    <| List.map (String.append " ")
    <| String.lines str


testLine : Int -> Run.Result -> String
testLine n result =
  let
    testNumber =
      toString (n + 1)
  in
    case result of
      Run.Pass description ->
        "ok " ++ testNumber ++ " - " ++ description

      Run.Fail description err ->
        "not ok " ++ testNumber ++ " - " ++ description ++
        "\n ---\n message:" ++ (indent ("\"" ++ err)) ++ "\"\n ..."

      _ ->
        testLines result


testLines : Run.Result -> String
testLines result =
  case result of
    Run.Report description {results} ->
      String.append ("#\n# " ++ description ++ "\n#\n")
        <| String.join "\n"
        <| List.indexedMap testLine results

    _ ->
      Debug.crash "should never happen"


{-| Run a list of tests in the IO type from [Max New's Elm IO library](https://github.com/maxsnew/IO/).
Requires this library to work. Results are printed to console once all tests have completed. Exits with
exit code 0 if all tests pass, or with code 1 if any tests fail.
-}
runDisplay : Test -> IO ()
runDisplay t =
  let
    n =
      numberOfTests t

    plan' =
      plan n

    result =
      Run.run t

    testLines' =
      testLines result

    strs =
      [ version
      , plan'
      , testLines'
      ]

    failed =
      (Run.failedTests result) /= 0
  in
    putStrLn (String.join "\n" strs)
      >>> if failed then
            exit 1
          else
            exit 0
