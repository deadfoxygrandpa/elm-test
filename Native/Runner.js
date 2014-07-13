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

        for (var i = 0; i < ns.length; i++) {
            result = ElmTest.Run.run(ns[i]);
            ys = ys.concat([result]);
            setTimeout(function(zs, t) { console.log(zs); setTimeout(function() { elm.notify(results.id, ElmTest.Run.foldReport(report)(List.fromArray(zs))) }, t * 1000); }(ys, i), 1000);
        };
        return results;
    }

    return elm.Native.Runner.values = {
        run : run
    };

};
