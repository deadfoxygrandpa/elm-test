module ElmTest.Runner.Task (run) where

import List exposing ((::))
import String
import ElmTest.Run as Run
import ElmTest.Test exposing (..)
import ElmTest.Runner.String exposing (resultToString)
import Task exposing (andThen)


run : Test -> { tasks : Task.Task x (), results : Signal String }
run test =
    let
        results = Signal.mailbox ""

        run' : Test -> Task.Task x ()
        run' test =
            let
                ( result, tests ) = Run.runOne test
            in
                case tests of
                    Nothing ->
                        Signal.send results.address (resultToString result)

                    Just tests ->
                        Signal.send results.address (resultToString result) `andThen` \_ -> run' tests
    in
        { tasks = run' test, results = results.signal }
