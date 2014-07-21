module ElmTest.Run where

{-| Basic utilities for running tests and customizing the output. If you don't care about customizing
the output, instead look at the ```runDisplay``` series in ElmTest.Runner

# Run
@docs run, pass, fail

-}

import Maybe

import ElmTest.Assertion (..)
import ElmTest.Test (..)

data Result = Pass String
            | Fail String String
            | Report String { results  : [Result]
                            , passes   : [Result]
                            , failures : [Result]
                            }


emptyReport : String -> Result
emptyReport name = Report name {results = [], passes = [], failures = []}

{-| Run a test and get a Result -}
run : Test -> Result
run test =
    case test of
        TestCase name assertion -> let runAssertion t m = if t ()
                                                          then Pass name
                                                          else Fail name m
                                in case assertion of
                                     AssertEqual t a b    -> runAssertion t <| "Expected: " ++ a ++ "; got: " ++ b
                                     AssertNotEqual t a b -> runAssertion t <| a ++ " equals " ++ b
                                     AssertTrue  t        -> runAssertion t <| "not True"
                                     AssertFalse t        -> runAssertion t <| "not False"
        Suite name tests -> let results = map run tests
                                (passes, fails) = partition pass results
                            in Report name { results  = results
                                           , passes   = passes
                                           , failures = fails
                                           }

runOne : Test -> (Result, Maybe Test)
runOne test =
    case test of
        TestCase _ _     -> (run test, Nothing)
        Suite name tests -> case tests of
                                []      -> (run test, Nothing) -- Returns an empty Report
                                [t]     -> let (result, test') = runOne t
                                           in  ( Report name { results  = [result]
                                                             , passes   = if pass result then [result] else []
                                                             , failures = if fail result then [result] else []
                                                             }
                                               , test')
                                (t::ts) -> let (result, test') = runOne t
                                               fromJust m = head . Maybe.justs <| [m]
                                           in ( Report name { results  = [result]
                                                             , passes   = if pass result then [result] else []
                                                             , failures = if fail result then [result] else []
                                                             }
                                               , if test' == Nothing then Just (Suite name ts) else Just . Suite name <| (fromJust test') :: ts)

addToReport : Result -> Result -> Result
addToReport result (Report name r) =
    case result of
        Pass _      -> Report name {r| passes <- r.passes ++ [result], results <- r.results ++ [result]}
        Fail _ _    -> Report name {r| failures <- r.failures ++ [result], results <- r.results ++ [result]}
        Report _ r' -> if pass result
                          then Report name {r| passes <- r.passes ++ [result], results <- r.results ++ [result]}
                          else Report name {r| failures <- r.failures ++ [result], results <- r.results ++ [result]}

foldReport : Result -> [Result] -> Result
foldReport baseReport results = foldl addToReport baseReport results

{-| Transform a Result into a Bool. True if the result represents a pass, otherwise False -}
pass : Result -> Bool
pass m = case m of
           Pass _     -> True
           Fail _ _   -> False
           Report _ r -> if (length (.failures r) > 0) then False else True

{-| Transform a Result into a Bool. True if the result represents a fail, otherwise False -}
fail : Result -> Bool
fail = not . pass

passedTests : Result -> Int
passedTests result = case result of
                        Pass _     -> 1
                        Fail _ _   -> 0
                        Report n r -> sum . map passedTests <| r.results

failedTests : Result -> Int
failedTests result = case result of
                        Pass _     -> 0
                        Fail _ _   -> 1
                        Report n r -> sum . map failedTests <| r.results

numberOfTests : Result -> Int
numberOfTests result = case result of
                        Report _ r -> sum . map numberOfTests <| r.results
                        _          -> 1

passedSuites : Result -> Int
passedSuites result = case result of
                        Report n r -> let passed = if length r.failures == 0
                                                   then 1
                                                   else 0
                                      in  passed + (sum . map passedSuites <| r.results)
                        _ -> 0

failedSuites : Result -> Int
failedSuites result = case result of
                        Report n r -> let failed = if length r.failures > 0
                                                   then 1
                                                   else 0
                                      in  failed + (sum . map failedSuites <| r.results)
                        _ -> 0

numberOfSuites : Result -> Int
numberOfSuites result = case result of
                        Report _ r -> 1 + (sum . map numberOfSuites <| r.results)
                        _          -> 0
