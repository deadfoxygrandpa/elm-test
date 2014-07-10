Elm.Native.Runner = {};
Elm.Native.Runner.make = function(elm) {
    elm.Native = elm.Native || {};
    elm.Native.Runner = elm.Native.Runner || {};
    if (elm.Native.Runner.values) return elm.Native.Runner.values;

    var Signal  = Elm.Signal.make(elm);
    var ElmTest = ElmTest || {};
    ElmTest.Run = Elm.ElmTest.Run.make(elm);

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
                        console.log(ElmTest.Run.run(a));
                        console.log(b);
                        return b;
    }

    function sig(n) {
        var steps = Signal.constant(0);
        setInterval(function() {
            elm.notify(steps.id, Math.random());
        }, 1000);
        return steps;
    }

    return elm.Native.Runner.values = {
        run : run,
        sig : sig
    };

};
