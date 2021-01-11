# object that sets up testing environment
# upon initial creation (NOT initialization)
# do all this stuff
Tester := Object clone do(
    # init number of total / successful tests ran
    numberOfTests := 0
    successfulTests := 0
    numberOfTestsInSuite := 0
    successfulTestsInSuite := 0

    # by default, print all test information
    printSuccesses ::= true
    printFailures ::= true
    printIndividualTestResults ::= true

    # by default, stop running test upon test fail
    stopOnFail ::= true

    tests := Map clone
    testName ::= "Unnamed Test"
)

# TODO allll of these methods need to be moved to be usable without the tester object (their own file)
# TODO don't be lazy. 

# used when running tests to determine if a successful test's information should be printed
Tester shouldPrintSuccesses := method(
    return printSuccesses
)

# used when running tests to determine if a failed test's information should be printed
Tester shouldPrintFailures := method(
    return printFailures
)

# used when running tests to print a summary of the tests that have been ran
Tester printTestSummary := method(
    # print suite results
    "\n##########################################################################" println
    "############################ Test Summary ################################" println
    "##########################################################################" println

    # print total results (so far)
    "Overall, #{successfulTests} tests passed out of #{numberOfTests} total = #{(successfulTests/numberOfTests*100) asString exSlice(0, 5)}% of tests passed\n\n" interpolate println
)

# given an expression, conditionally prints validity of statement, 
# returns 1 if expression is true, 0 if false
Object assertTrue := method(expression, 
    if(expression) then(
        if(Tester printSuccesses) then(
            "#{call message arguments at(0)} true, as expected" interpolate println
        )
        return 1
    ) else(
        if(Tester printFailures) then(
            (("#{call message arguments at(0)} expected true but evaluated as: " interpolate) .. ("#{call evalArgAt(0)}" interpolate)) println
        )
        return 0
    )
)

# given an expression, conditionally prints validity of statement, 
# returns 1 if expression is false, 0 if true
Object assertFalse := method(expression, 
    if(expression not) then(
        if(Tester printSuccesses) then(
            "#{call message arguments at(0)} false, as expected" interpolate println
        )
        return 1
    ) else(
        if(Tester printFailures) then(
            (("#{call message arguments at(0)} expected false but evaluated as: " interpolate) .. ("#{call evalArgAt(0)}" interpolate)) println
        )
        return 0
    )
)

# given two objects, conditionally prints validity of equality, 
# returns 1 if objects are equal, 0 if they aren't
Object assertEquals := method(obj1, obj2,
    if(call evalArgAt(0) == call evalArgAt(1)) then(
        if(Tester printSuccesses) then(
            "#{call message arguments at(0)} == #{call message arguments at(1)}, as expected" interpolate println
        )
        return 1
    ) else(
        if(Tester printFailures) then(
            (("#{call message arguments at(0)} != #{call message arguments at(1)}, expected equality but evaluated as: " interpolate) .. ("#{call evalArgAt(0)} != #{call evalArgAt(1)}") interpolate) println
        )
        return 0
    )
)

Tester setInitialParameters := method(suc, fail, stop, 
    Tester printSuccesses = suc
    Tester printFailures = fail
    Tester stopOnFail = stop
)

# custom forward definition that allows for tidy testing format of form

/*
    testSuiteName(
        setup1
        test1,
        setup2
        setup2cont
        setup2cont 
        test2, 
        test3,
        ...
        testn
    )
    
    that will print something like 
    ### running test testSuiteName ###
    test1 passed
    test2 passed
    test3 failed
    ....
    testn failed
    altogether, x / y tests passed for a pass rate of x/y%
*/

Tester forward := method(

    // TODO make forward add tests to Tester tests map
    // TODO Tester executeTests will actually run the tests.

    testName := call message name
    testList := nil
    if(tests hasKey(testName))then(
        testList = tests at(testName)
    )else(
        tests atPut(testName, List clone)
        testList = tests at(testName)
    )
    call message arguments foreach(index, arg, 
        testList append(arg)
        numberOfTests = numberOfTests + 1
    )

    ##### TODO currently in the process of transferring old forward method to new one wherein map is created where test name is key, tests to run are contained in list that is map value #####

    /*

    # if a before method is defined, call it 
    if(Object getSlot("before") != nil) then(Object before) else("No before method found! If stuff needs to happen before each test, must include: \nObject before := method(/*stuff to do before running test here*/)" println)

    "\n#####################################################\n\tRunning test #{call message name}\n#####################################################\n" interpolate println
    
    # number of tests in this suite, disguised as # of params in function call
    numberOfTestsInSuite := call message arguments size

    # number of successful tests in this suite
    successfulTestsInSuite := 0

    # for each parameter
    call message arguments foreach(index, arg, 

        # run the test - if it passes, one will be returned by evalArgAt, otherwise, 0 is returned
        successfulTestsInSuite = successfulTestsInSuite + call evalArgAt(index)
    )

    # add number of tests in this suite to total amount
    numberOfTests = numberOfTests + numberOfTestsInSuite

    # add number of successful tests in this suite to total amount
    successfulTests = successfulTests + successfulTestsInSuite

    # print suite results
    "\nResults: #{successfulTestsInSuite} tests passed out of #{numberOfTestsInSuite} total = #{(successfulTestsInSuite/numberOfTestsInSuite*100) asString exSlice(0, 5)}% of tests passed" interpolate println

    */
)

Tester executeTests := method(
    
    "\n##########################################################################\n\t\tRunning tests for #{testName}\n##########################################################################\n" interpolate println
    tests keys foreach(key,
        if(Object getSlot("before") != nil) then(
            Object before
        ) else(
            "No before method found! If stuff needs to happen before each test, must include: \nObject before := method(/*stuff to do before running test here*/)" println
        )
        
        "\n#####################################################\n\tRunning test #{key}\n#####################################################\n" interpolate println
        
        # number of tests in this suite, disguised as # of elements in tests map value list size
        numberOfTestsInSuite := tests at (key) size
        
        # number of successful tests in this suite
        successfulTestsInSuite := 0

        # for each parameter
        tests at(key) foreach(index, arg, 

            # run the test - if it passes, one will be returned by doMessage, otherwise, 0 is returned
            e := try(successfulTestsInSuite = successfulTestsInSuite + doMessage(arg))
            e catch(
                "\nCaught exception from test: " println
                e showStack
                
                # TODO determine if error messaging can all be lumped here, as opposed to in assertX methods...
                if(stopOnFail)then(
                    Tester printTestSummary
                    Exception raise("### Stopping due to test failure - use Tester setStopOnFail(false) to continue running tests when a test fails ###")
                )
            )
        )

        # add number of successful tests in this suite to total amount
        successfulTests = successfulTests + successfulTestsInSuite

        # print suite results
        if(printIndividualTestResults)then(
            "\nResults: #{successfulTestsInSuite} tests passed out of #{numberOfTestsInSuite} total = #{(successfulTestsInSuite/numberOfTestsInSuite*100) asString exSlice(0, 5)}% of tests passed" interpolate println
        )
    )

    Tester printTestSummary
)