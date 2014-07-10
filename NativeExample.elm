module Main where

import Test
import ElmTest.Run as Run
import ElmTest.Runner.Element as Element
import ElmTest.Runner.String  as String

import Native.Runner

--prettyOut : a -> Run.Result
--prettyOut = Native.Runner.run <| Test.suite

uglyOut : String
uglyOut = String.runDisplay Test.suite2

uglyOut' : String
uglyOut' = String.runDisplay Test.suite3

--main : Element
--main = flow down [ plainText "All tests in this suite will pass:\n\n"
--                 , plainText uglyOut
--                 , plainText "\nThis suite has a failing test:\n\n"
--                 , plainText uglyOut'
--                 , plainText "\nThe Element runner:\n\n"
--                 , asText prettyOut
--                 ]

run : Signal Run.Result
run = (Native.Runner.run Test.suite3)

main = (\x y -> flow down [asText x, asText y]) <~ run ~ (count run)
