module ElmTest.Runner.Tap (runDisplay) where

{-| Run a test suite and display it in TAP13 format.

# Run
@docs runDisplay

-}

import String
import Array exposing (Array, push)
import Console exposing (..)
import ElmTest.Run as Run
import ElmTest.Test exposing (..)


indent : String -> String
indent str =
  String.join "\n"
    <| List.map (String.append " ")
    <| String.lines str


type alias Res =
  { testNumber : Int
  , suiteNumber : Int
  , output : Array String
  }


version : String
version =
  "TAP version 13"


plan : Int -> String
plan n =
  if n > 0 then
    "1.." ++ (toString n)
  else
    ""


okTest : Int -> String -> String
okTest n description =
  "ok " ++ (toString n) ++ " - " ++ description


notOkTest : Int -> String -> String -> String
notOkTest n description err =
  "not " ++ (okTest n description) ++
  "\n ---\n message:" ++ (indent ("\"" ++ err)) ++ "\"\n ..."


testLines : Run.Result -> Res -> Res
testLines result res =
  let
    newTestNumber =
      res.testNumber + 1
  in
    case result of
      Run.Pass description ->
        { res
          | testNumber = newTestNumber
          , output = push (okTest newTestNumber description) res.output
        }

      Run.Fail description err ->
        { res
          | testNumber = newTestNumber
          , output = push (notOkTest newTestNumber description err) res.output
        }

      Run.Report description {results} ->
        let
          currentSuiteNumber =
            res.suiteNumber

          i =
            String.repeat currentSuiteNumber "#"

          res' =
            { res
              | output = push (i ++ " " ++ description) res.output
              , suiteNumber = currentSuiteNumber + 1
            }

          res'' =
            List.foldl testLines res' results
        in
          { res''
            | suiteNumber = currentSuiteNumber
            , output = push (i ++ " end of " ++ description) res''.output
          }


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
      List.foldl testLines (Res 0 1 (Array.fromList [])) [result]
        |> .output
        |> Array.toList
        |> String.join "\n"

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
