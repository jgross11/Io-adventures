// bad
// Importer addSearchPath("/mnt/c/Users/J/git/Io-adventures/TestingFramework/")

// better
// Importer paths at(1) is path to this file
// Importer addSearchPath(Importer paths at(1) .. "/TestingFramework/")

// best?
// add each path in the current directory 
/*
Directory directories foreach(dir, 
    Importer addSearchPath(dir path)
)*/

// if launched from the command line (an individual is testing), use user Tester settings
// otherwise keep Tester defaults
if(isLaunchScript)then(
    
    // determines which statements to print
    Tester setPrintSuccesses(false)
    Tester setPrintFailures(true)

    // determines if test should stop running upon encountering a failure
    Tester setStopOnFail(false)

    // determines if each method's test results should print
    Tester setPrintIndividualTestResults(false)

// otherwise, running test collection, use convenience settings
) else(
        // determines which statements to print
    Tester setPrintSuccesses(false)
    Tester setPrintFailures(false)

    // determines if test should stop running upon encountering a failure
    Tester setStopOnFail(false)

    // determines if each method's test results should print
    Tester setPrintIndividualTestResults(false)
)
// formats header print statement
Tester setTestName("Linked List")

// any work that should be done before each test must be contained in here
// all vars must be self to bypass method scope 
before := method(

    # must create empty list before each test
    self testList := LinkedList clone
)

# all tests to be grouped together must be called in the following form

/*
Tester testName(
    prep1
    prep2
    prep3
    assertX(...),   <--- notice that parameters are separated by a test, not each line of code
    assertY(...),   <----|
    prep4
    prep5
    assertZ(...)    <--- each parameter should end with a test, otherwise prep work will be counted as a test
)
*/
Tester testInit(
    assertTrue(testList size == 0),
    assertTrue(testList firstNode == nil),
    assertFalse(testList size != 0),
    assertFalse(testList firstNode != nil),
    assertEquals(testList size, 0),
    assertEquals(testList firstNode, nil)
)

Tester testAdd(
    testList add(1)
    testList add("a link in the testList")
    testList add(true)
    testList add(nil)
    assertTrue(testList size == 4),
    assertTrue(testList firstNode != nil),
    assertFalse(testList size != 4),
    assertFalse(testList firstNode == nil),
    assertEquals(testList size, 4)
)

Tester testRemoveAtIndex(
    testList add(1)
    testList add(1)
    testList add(1)
    testList add(1)
    assertTrue(testList size == 4),
    testList removeAtIndex(0)
    assertTrue(testList size == 3),
    testList removeAtIndex(2)
    assertTrue(testList size == 2),
    testList removeAtIndex(0)
    testList removeAtIndex(0)
    assertTrue(testList size == 0),
    assertTrue(testList firstNode == nil)
)

Tester testGet(
    testList add(1)
    testList add("a link in the testList")
    testList add(true)
    testList add(nil)
    assertEquals(1, testList get(0)),
    assertEquals("a link in the testList", testList get(1)),
    assertEquals(true, testList get(2)),
    assertEquals(nil, testList get(3))
)

Tester testAddAtIndex(
    testList addAtIndex(0, 1)
    assertTrue(testList get(0) == 1),
    testList addAtIndex(0, 2)
    testList addAtIndex(2, 4)
    assertTrue(testList get(0) == 2),
    assertTrue(testList get(1) == 1),
    assertTrue(testList get(2) == 4)
)


# notice that the following test does not create its own suite, 
# but instead adds its tests to the existing suite above, and will run after
# those in the above suite
Tester testGet(
    assertEquals(1, testList get(0))
)

Tester testIndexOf(
    testList add(0)
    testList add(1)
    testList add(2)
    assertTrue(testList indexOf(0) == 0),
    assertTrue(testList indexOf(2) == 2),
    assertTrue(testList indexOf(1) == 1),
    assertTrue(testList indexOf(3) == -1)
)

# creating tests in the above simply adds each test to a map, which is iterated through
# and every test is executed via this method call (actually runs tests)
Tester executeTests()

