# implementation of a linked list
LinkedList := Object clone

# on init, size is 0 and firstNode reference is empty
LinkedList init := method(
    self size := 0
    self firstNode := nil
)

# create a new node whose value is the parameter and place node at end of list
LinkedList add := method(value, 
    
    # create new node
    nodeToAdd := Node clone
    nodeToAdd setValue(value)

    # if this is to be the first node in the list
    if(firstNode isNil) then(
        firstNode = nodeToAdd
    ) else(
        # otherwise, iterate to end of list
        currentNode := firstNode
        for(i, 0, size - 2, 
            currentNode = currentNode nextNode
        )

        # set the last node's next node reference to the newly created node
        currentNode setNextNode(nodeToAdd)
    )

    # increment size of list
    size = size + 1
)

# remove the node at the given index, squeezing the two bordering nodes together
LinkedList removeAtIndex := method(index, 
    # if the index is invalid, throw error indicating invalid index, and valid index range
    if(index < 0 or index >= size) then(
        errorString := nil
        if(size > 0)then(errorString = "Valid indices: [0, #{size}]" interpolate)else(errorString = "List is empty!")
        Exception raise("LinkedList: Invalid index when attempting to remove from index #{index}: #{errorString}" interpolate)
        return 
    )

    # if the first node is being removed
    if(index == 0) then(

        # set first node reference to the node after the current first
        firstNode = firstNode nextNode
        // delete OG node if necessary?
    ) else(
        # otherwise, iterate to node before node to delete
        currentNode := firstNode
        for(i, 0, index - 2, 
            currentNode = currentNode nextNode
        )

        # set node before (node to delete)'s next node to the node after the (node to delete) 
        currentNode setNextNode(currentNode nextNode nextNode)
        // delete next node if necessary?
    )
    // decrement list size
    size = size - 1
)

# add a node with the given value at the given index, which increase the index of all nodes 'to the right' of the inserted one
LinkedList addAtIndex := method(index, value,

    # if the index is invalid, throw error indicating invalid index, and valid index range 
    if(index < 0 or index > size) then(
        errorString := nil
        if(size > 0)then(errorString = "Valid indices: [0, #{size}]" interpolate)else(errorString = "List is empty!")
        Exception raise("LinkedList: Invalid index when attempting to add item at index #{index}: #{errorString}" interpolate)
    )

    # create node to add
    nodeToAdd := Node clone
    nodeToAdd setValue(value)

    # if this is to be the new first node
    if(index == 0) then(

        # if a valid node already exists
        if(firstNode != nil) then(

            # set new node's next node reference to the current first node
            nodeToAdd setNextNode(firstNode)
        )

        # update first node reference
        firstNode = nodeToAdd
    ) else(

        # otherwise, iterate to node at index to insert at
        currentNode := firstNode
        for(i, 0, index - 2, 
            currentNode = currentNode nextNode
        )

        # set new node's next node reference
        nodeToAdd setNextNode(currentNode nextNode)

        # set node currently at index's next node reference to new node
        currentNode setNextNode(nodeToAdd)
    )

    # increment list size
    size = size + 1
)

# iterates through list, checking each node to see if the parameter value is in the list
# returns the index of the value if it is in list, -1 otherwise
LinkedList indexOf := method(value, 

    currentNode := firstNode

    # for every node in list
    for(i, 0, size-1, 

        # if the current node's value is the value we desire
        if(currentNode value == value)then(

            # return index of this node
            return i

        # otherwise, move to next node
        ) else(
            currentNode = currentNode nextNode
        )
    )

    # reached end of list without finding value, return -1
    return -1
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

LinkedList get := method(index, 
    
    # if the index is invalid, throw error indicating invalid index, and valid index range 
    if(index < 0 or index >= size) then(
        errorString := nil
        if(size > 0)then(errorString = "Valid indices: [0, #{size}]" interpolate)else(errorString = "List is empty!")
        Exception raise("LinkedList: Invalid index when attempting to get item at index #{index}: #{errorString}" interpolate)
    ) else(
        
        # otherwise, travel to node at the specified index
        currentNode := firstNode
        for(i, 0, index - 1, 
            currentNode = currentNode nextNode
        )

        # and return its value
        return currentNode value
    )
)