module Main where

import Test
import ElmTest.Run as Run
import ElmTest.Runner.Element as Element
import ElmTest.Runner.String  as String
import ElmTest.Test (..)

prettyOut : Signal Element
prettyOut = let x = Element.runDisplay Test.suite3
            in  (\y n -> flow down [asText n, y]) <~ x ~ (count x)

uglyOut : String
uglyOut = String.runDisplay Test.suite2

uglyOut' : String
uglyOut' = String.runDisplay Test.suite3

--main : Signal Element
--main = prettyOut

main = let one = Test.suite3
           two = runna one
           three = runna two
           four = runna three
           five = runna four
           six = runna five
       in  flow right <| map (\x -> showTest x `above` spacer 50 50) [one, two, three, four, five, six]

runna : Test -> Test
runna = fromJust . snd . Run.runOne

showTest : Test -> Element
showTest t =
    case t of
        TestCase name _ -> asText name
        Suite name ts   -> flow down <| asText name :: map (\x -> flow right [spacer 10 10, showTest x]) ts

fromJust : Maybe a -> a
fromJust (Just x) = x
