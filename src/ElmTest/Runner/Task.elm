module ElmTest.Runner.Task (run) where

import List exposing ((::))
import String
import ElmTest.Run as Run
import ElmTest.Test exposing (..)
import ElmTest.Runner.String exposing (resultToString)
import Task exposing (andThen)


run =
  Run.taskRun
