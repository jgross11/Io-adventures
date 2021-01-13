TestingMultiple := Object clone

submissionResults := List clone

resetTester := method(
    Tester successfulTests = 0
    Tester successfulTestsInSuite = 0
    Tester numberOfTests = 0
    Tester numberOfTestsInSuite = 0
    Tester tests = Map clone
)

Directory directories foreach(dir, 
    Importer addSearchPath(dir name)
    "######################################################################################################" println
    "######################################################################################################" println
    "\t\tTesting submission: #{dir name}" interpolate println
    "######################################################################################################" println
    "######################################################################################################" println
    if(System args size > 1)then(
        doFile(dir name .. "/" .. System args at(1))
    ) else(
        Exception raise("First argument must be name of test file!")
    )
    submissionResults append("#{dir name}: #{Tester successfulTests} / #{Tester numberOfTests} = #{((Tester successfulTests / Tester numberOfTests)*100) asString exSlice(0, 5)}%" interpolate)
    resetTester()
    "Done testing submission: #{dir name}\n" interpolate println
    Importer removeSearchPath(dir name)
    
    // my hour for a line!!
    // testing objects placed in Lobby as slots upon creation (makes sense, this is Io)
    // thus, must remove after running each test to ensure 
    // that the object being tested is the appropriate one 
    // i.e. submission A is perfect, submission B is not, but 
    // without this line, B (and all other tests after A) will receive A's score
    // as submission A's code is ran

    // the structure(s) being tested must be specified on the command line as arguments 
    // after the file name - here they are removed to reset the lobby to the state before testing
    // to ensure every submission's structure is tested independently
    for(i, 2, System args size - 1, 
        Lobby removeSlot(System args at(i))
    )
)
".\n.\n.\n.\n.\n\tAll submissions results:\n" println
submissionResults foreach(println)
"" println