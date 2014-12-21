Elm.Native.ElmTestRunner = {};
Elm.Native.ElmTestRunner.make = function(elm) {
    elm.Native = elm.Native || {};
    elm.Native.ElmTestRunner = elm.Native.ElmTestRunner || {};
    if (elm.Native.ElmTestRunner.values) {
        return elm.Native.ElmTestRunner.values;
    }

    var Utils = Elm.Native.Utils.make(elm);

    function runAssertEqual(assertion, a, b) {
        try {
            var result = assertion(Utils.Tuple0);
            var msg = "Expected: " + name(a) + "; got: " + name(b);
        } catch (e) {
            var result = false;
            var msg = e.toString();
        }
        return Utils.Tuple2(result, msg);
    }

    function runAssertNotEqual(assertion, a, b) {
        try {
            var result = assertion(Utils.Tuple0);
            var msg = name(a) + " equals " + name(b);
        } catch (e) {
            var result = false;
            var msg = e.toString();
        }
        return Utils.Tuple2(result, msg);
    }

    function name(a) {
        try {
            var aString = a(Utils.Tuple0);
        } catch (e) {
            var aString = "error";
        }
        return aString;
    }

    return elm.Native.ElmTestRunner.values = {
        runAssertEqual : F3(runAssertEqual),
        runAssertNotEqual : F3(runAssertNotEqual),
        name : name
    };

};
