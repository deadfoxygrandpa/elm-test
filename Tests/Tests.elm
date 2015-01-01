module Main where

import List

import ElmTest.Assertion as A
import ElmTest.Run as R
import ElmTest.Runner.Console (runDisplay)
import ElmTest.Test (..)

import IO.IO (..)
import IO.Runner (Request, Response)
import IO.Runner as Run

tests : List Test
tests = [ (\_ -> R.run ((\_ -> 0) `equals` (\_ -> 0))) `equals` (\_ -> R.Pass "0 == 0")
        , test "pass" <| A.assert (\_ -> R.pass <| R.Pass "")
        , test "fail" <| A.assertNotEqual (\_ -> (R.fail <| R.Pass "")) (\_ -> True)
        ] ++ (List.map defaultTest <| A.assertionList (List.map (\n -> \_ -> n) [1..10]) (List.map (\n -> \_ -> n) [1..10]))

console = runDisplay <| Suite "All Tests" tests

port requests : Signal Request
port requests = Run.run responses console

port responses : Signal Response
