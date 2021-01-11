// bad
// Importer addSearchPath("/mnt/c/Users/J/git/Io-adventures/TestingFramework/")

// better
// Importer paths at(1) is path to this file
// Importer addSearchPath(Importer paths at(1) .. "/TestingFramework/")

// best?
// add each path in the current directory 
Directory directories foreach(dir, 
    Importer addSearchPath(dir path)
)

Tester setPrintSuccesses(false)
Tester setPrintFailures(true)
Tester setStopOnFail(false)
Tester setPrintIndividualTestResults(false)
Tester setTestName("Linked List")

before := method(
    self testList := LinkedList clone
)

Tester testInit(
    assertTrue(testList size == 0),
    assertTrue(testList firstNode == nil),
    assertFalse(testList size != 0),
    assertFalse(testList firstNode != nil),
    assertEquals(testList size, 0),
    assertEquals(testList firstNode, nil)
)

Tester testInitButEverythingFails(
    assertTrue(testList size != 0),
    assertTrue(testList firstNode != nil),
    assertFalse(testList size == 0),
    assertFalse(testList firstNode == nil),
    assertEquals(testList size, 1),
    assertEquals(testList firstNode, 1)
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
    testList removeAtIndex(30)
    testList add(1)
    testList add(1)
    testList add(1)
    testList add(1)
    assertTrue(testList size == 4),
    // testList removeAtIndex(30)
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
    //testList addAtIndex(100, 100)
)

Tester executeTests()

