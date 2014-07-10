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

    function run(a) {   var b = {
                            ctor: "Report",
                             _0: "Hello!",
                            _1: {
                                _: {},
                                failures: {ctor: "[]"},
                                passes: {ctor: "[]"},
                                results: {ctor: "[]"}
                            }
                        };
                        console.log(a);
                        console.log(ElmTest.Run.run(a));
                        console.log(b);
                        return b;
    }

    function sig(suite) {
        var ns = List.toArray(suite._1);
        var ys = [];
        var steps = Signal.constant(List.fromArray(ys));

        for (var i = 0; i < ns.length; i++) {
            result = ElmTest.Run.run(ns[i]);
            ys = ys.concat([result]);
            setTimeout(function(zs, t) { console.log(zs); setTimeout(function() { elm.notify(steps.id, List.fromArray(zs)); }, t * 1000); }(ys, i), 1000);
        };
        return steps;
    }

    return elm.Native.Runner.values = {
        run : run,
        sig : sig
    };

};
