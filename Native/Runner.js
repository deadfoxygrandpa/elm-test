Elm.Native.Runner = {};
Elm.Native.Runner.make = function(elm) {
    elm.Native = elm.Native || {};
    elm.Native.Runner = elm.Native.Runner || {};
    if (elm.Native.Runner.values) return elm.Native.Runner.values;

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

    return elm.Native.Runner.values = {
        run : run,
    };

};
