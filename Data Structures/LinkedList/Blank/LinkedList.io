# implementation of a linked list
LinkedList := Object clone

# on init, size is 0 and firstNode reference is empty
LinkedList init := method(
    Exception raise("LinkedList: #{call message name} not yet implemented!" interpolate)
)

# create a new node whose value is the parameter and place node at end of list
LinkedList add := method(value, 
    Exception raise("LinkedList: #{call message name} not yet implemented!" interpolate)
)

# remove the node at the given index, squeezing the two bordering nodes together
LinkedList removeAtIndex := method(index, 
    Exception raise("LinkedList: #{call message name} not yet implemented!" interpolate)
)

# add a node with the given value at the given index, which increase the index of all nodes 'to the right' of the inserted one
LinkedList addAtIndex := method(index, value,
    Exception raise("LinkedList: #{call message name} not yet implemented!" interpolate)
)

# iterates through list, checking each node to see if the parameter value is in the list
# returns the index of the value if it is in list, -1 otherwise
LinkedList indexOf := method(value, 
    Exception raise("LinkedList: #{call message name} not yet implemented!" interpolate)
)

LinkedList get := method(index, 
    Exception raise("LinkedList: #{call message name} not yet implemented!" interpolate)
)

# iterate through list, printing each element's index and value
# also prints current size of list
LinkedList printContents := method(
    if(firstNode isNil) then("Empty List" println) else(
        currentNode := firstNode
        "\nSize of list: #{size}" interpolate println
        for(i, 0, size-1, 
            "index=#{i} | value = #{currentNode value asString}" interpolate println
            currentNode = currentNode nextNode
        )
        "" println
    )
)