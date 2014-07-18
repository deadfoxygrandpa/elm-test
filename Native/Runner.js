Elm.Native.Runner = {};
Elm.Native.Runner.make = function(elm) {
    elm.Native = elm.Native || {};
    elm.Native.Runner = elm.Native.Runner || {};
    if (elm.Native.Runner.values) return elm.Native.Runner.values;

    var Signal   = Elm.Signal.make(elm);
    var List     = Elm.Native.List.make(elm);
    var ElmTest  = ElmTest || {};
    ElmTest.Run  = Elm.ElmTest.Run.make(elm);
    ElmTest.Test = Elm.ElmTest.Test.make(elm);

    function run(suite) {
        if (suite.ctor == "TestCase") {
            suite = ElmTest.Test.suite(suite._0)(List.fromArray([suite]));
        }
        var ns = List.toArray(suite._1);
        var ys = [];
        var report = ElmTest.Run.emptyReport(suite._0);
        var results = Signal.constant(report);

        function send(ys, i) {
            // console.log(i);
            setTimeout(function(zs, t)
                { setTimeout(function()
                    { elm.notify(results.id,
                        ElmTest.Run.foldReport(report)(List.fromArray(zs)));
                }, t * 1000);
            }(ys, i), 1000);
        }

        function runTests(ns, ys) {
            var j = 0;
            for (var i = 0; i < ns.length; i++) {
                // console.log(i);
                // var result = ElmTest.Run.run(ns[i]);
                var ran = ElmTest.Run.runOne(ns[i]);
                var result = ran._0;
                ys = ys.concat([result]);
                send(ys, i + j);

                var theRest = ran._1;
                while (theRest.ctor == "Just") {
                    j += 1;
                    // console.log(theRest._0);
                    var suite = theRest._0;
                    var tests = List.toArray(suite._1);
                    var ran = ElmTest.Run.runOne(tests[0]);
                    ys = ys.concat([ran._0])
                    send(ys, i + j);
                    theRest = ran._1;
                    // console.log(theRest);
                }
            };
        }

        runTests(ns, ys);

        return results;
    }

    return elm.Native.Runner.values = {
        run : run
    };

};
