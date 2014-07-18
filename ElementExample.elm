module Main where

import Test
import ElmTest.Run as Run
import ElmTest.Runner.Element as Element
import ElmTest.Runner.String  as String

prettyOut : Signal Element
prettyOut = let x = Element.runDisplay Test.suite3
            in  (\y n -> flow down [asText n, y]) <~ x ~ (count x)

uglyOut : String
uglyOut = String.runDisplay Test.suite2

uglyOut' : String
uglyOut' = String.runDisplay Test.suite3

main : Signal Element
main = prettyOut
