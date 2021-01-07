# object that sets up testing environment
# upon initial creation (NOT initialization)
# do all this stuff
Tester := Object clone do(

    # TODO allll of these methods need to be moved to be usable without the tester object (their own file)
    # TODO don't be lazy. 

    # used when running tests to determine if a successful test's information should be printed
    Object shouldPrintSuccesses := method(

        # if a tester is being used, return its setting
        if (Tester getSlot("printSuccesses") != nil)then(
            return Tester printSuccesses
        ) else(

            # otherwise, print information by default
            return true
        )
    )

    # used when running tests to determine if a failed test's information should be printed
    Object shouldPrintFailures := method(

        # if a tester is being used, return its setting
        if (Tester getSlot("printFailures") != nil)then(
            return Tester printFailures
        ) else(

            # otherwise, print information by default
            return true
        )
    )

    # given an expression, conditionally prints validity of statement, 
    # returns 1 if expression is true, 0 if false
    Object assertTrue := method(expression, 
        if(expression) then(
            if(shouldPrintSuccesses) then(
                "#{call message arguments at(0)} true, as expected" interpolate println
            )
            return 1
        ) else(
            if(shouldPrintFailures) then(
                "#{call message arguments at(0)} false, expected true" interpolate println
            )
            return 0
        )
    )

    # given an expression, conditionally prints validity of statement, 
    # returns 1 if expression is false, 0 if true
    Object assertFalse := method(expression, 
        if(expression not) then(
            if(shouldPrintSuccesses) then(
                "#{call message arguments at(0)} false, as expected" interpolate println
            )
            return 1
        ) else(
            if(shouldPrintFailures) then(
                "#{call message arguments at(0)} true, expected false" interpolate println
            )
            return 0
        )
    )

    # given two objects, conditionally prints validity of equality, 
    # returns 1 if objects are equal, 0 if they aren't
    Object assertEquals := method(obj1, obj2,
        if(obj1 == obj2) then(
            if(shouldPrintSuccesses) then(
                "#{call message arguments at(0)} == #{call message arguments at(1)}, as expected" interpolate println
            )
            return 1
        ) else(
            if(shouldPrintFailures) then(
                "#{call message arguments at(0)} != #{call message arguments at(1)}, expected equality" interpolate println
            )
            return 0
        )
    )

    # init number of total / successful tests ran
    numberOfTests := 0
    successfulTests := 0

    # by default, print all test information
    printSuccesses := true
    printFailures := true
)

# custom forward definition that allows for tidy testing format of form

/*
    testSuiteName(
        test1, 
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
    "Results: #{successfulTestsInSuite} tests passed out of #{numberOfTestsInSuite} total = #{(successfulTestsInSuite/numberOfTestsInSuite*100) asString exSlice(0, 5)}% of tests passed" interpolate println
    
    # print total results (so far)
    "Overall, #{successfulTests} tests passed out of #{numberOfTests} total = #{(successfulTests/numberOfTests*100) asString exSlice(0, 5)}% of tests passed" interpolate println
    "\n#####################################################\n\tFinished running test #{call message name}\n#####################################################\n" interpolate println
)

/*
# instance of tester
tester := Tester clone

# testAdd test suite
tester testAdd(
    assertTrue(1 == 2),
    assertFalse(1 == 2),
    assertEquals(1, 1)
)

# testSubtract test suite
tester testSubtract(
    assertTrue(1 == 2),
    assertTrue(1 == 2),
    assertEquals(1, 1)
)
*/