# object that sets up testing environment
# upon initial creation (NOT initialization)

Tester := Object clone do(

    # init number of total / successful tests ran
    numberOfTests := 0
    successfulTests := 0

    # init number of total / successful tests in a method's suite
    numberOfTestsInSuite := 0
    successfulTestsInSuite := 0

    # by default, print all test information
    printSuccesses ::= true
    printFailures ::= true
    printIndividualTestResults ::= true

    # by default, stop running test upon test fail
    stopOnFail ::= true

    # init map of tests 
    tests := Map clone

    # default test name
    testName ::= "Unnamed Test"
)

# used when running tests to print a summary of the tests that have been ran
Tester printTestSummary := method(
    # print header
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

    # test name is missing method's name
    testName := call message name

    # reference to this specific method's test list
    testList := nil

    # if method's test list already exists
    # get a reference to it
    if(tests hasKey(testName))then(
        testList = tests at(testName)

    # otherwise, put the new method's name in the map
    )else(

        # with the name as key, a new list as value
        tests atPut(testName, List clone)

        # and get a reference to the newly created list
        testList = tests at(testName)
    )

    # for each test for this method
    call message arguments foreach(index, arg, 
        
        # add each test to execute to this list
        testList append(arg)

        # increment number of tests in this Test
        numberOfTests = numberOfTests + 1
    )
)

# actually executes every test in the tests map
Tester executeTests := method(
    
    # print big header
    "\n##########################################################################\n\t\tRunning tests for #{testName}\n##########################################################################\n" interpolate println
    
    # for every method that has tests to run
    tests keys foreach(key,

        # if before work needs to be done
        if(Object getSlot("before") != nil) then(
            
            # try to execute before method
            e := try(Object before)
            e catch(
                # if test failures are to be printed
                if(printFailures)then(

                    # print the exception that arose from test
                    "\nCaught exception from before work: " println
                    e showStack
                )
            )
        ) else(

            # otherwise, notify user that they can do so if need be
            "No before method found! If stuff needs to happen before each test, must include: \nObject before := method(/*stuff to do before running test here*/) in Test[Thing] file" println
        )
        
        # print test header
        "\n#####################################################\n\tRunning test #{key}\n#####################################################\n" interpolate println
        
        # number of tests in this suite, disguised as # of elements in tests map value list size
        numberOfTestsInSuite := tests at (key) size
        
        # number of successful tests in this suite
        successfulTestsInSuite := 0

        # for each parameter
        tests at(key) foreach(index, arg, 

            # run the test - if it passes, one will be returned by doMessage, otherwise, 0 is returned
            e := try(successfulTestsInSuite = successfulTestsInSuite + doMessage(arg))
            
            # if an exception is caught, then a test created it
            e catch(

                # if test failures are to be printed
                if(printFailures)then(

                    # print the exception that arose from test
                    "\nCaught exception from test: " println
                    e showStack
                )
                
                # if a test failure should result in the stopping of running tests
                if(stopOnFail)then(

                    # add number of successful tests in this suite to total amount
                    # still need to do this as a successful test may have happened before failure in this suite
                    successfulTests = successfulTests + successfulTestsInSuite

                    # print test summary in the current state
                    Tester printTestSummary

                    # raise exception to stop testing
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

    # after all tests have ran, print the final summary
    Tester printTestSummary
)