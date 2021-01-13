# represents a node found in common data structures
Node := Object clone

# on init, make value 0 and next node reference null
Node init := method(
    self value := 0
    self nextNode := nil
)

# set this node's value to the given value (any type)
Node setValue := method(newValue,
    self value = newValue
)

# set this node's next node reference
Node setNextNode := method(newNode, 
    self nextNode = newNode
)