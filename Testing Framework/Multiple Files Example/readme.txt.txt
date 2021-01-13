The contents of this folder are as follows:

Submission folders

	These folders represent a submission of an assignment of varying qualities. At the very least, these folders must contain Tester.io (found in libs) and a test file. They must also contain a copy of whatever Io files they are testing. For a concrete example of what must be contained in a submission, reference the Single File Example folder.  

	The example tests implementations of LinkedList. Linked lists utilize a basic node, hence, the necessary files to run such a test are:
		- An Io file that implements a LinkedList (LinkedList.io).
		- An Io file that implements a LinkedList node (Node.io).
		- A test file (see file for specifics regarding test file structure) (TestLinkedList.io).
		- A copy of the test framework runner (Test.io).

TestingMultiple.io

	Found in libs, this file contains all the relevant code to access, execute, calculate, and display the test results for each submission, in one fell swoop. Testing all submissions requires one command, in the form of:
		io TestingMultiple.io <name of test file> <name of implementation file one> <name of implementation file two> ... <name of implementation file n>

	<name of test file> - The file containing the tests for this assignment.
	<name of implementation file n> The file containing the implementation details for this assignment.

	Thus, for the example assignment, the command is:
		io TestingMultiple.io TestLinkedList.io LinkedList Node