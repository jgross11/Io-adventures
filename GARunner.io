
GARunner := Object clone

# runs the experiment
GARunner start := method(

    # list of specimen representing the population
    self population := List clone

    # the percent chance that a mutation occurs when breeding
    self mutationRate := 0.2

    # using truncation breeding
    # the percentage of the population (most fit) to choose from when 
    # selecting parents for breeding purposes
    self truncationThreshold := 0.2

    # minimum fitness value that must be reached in order for experiment to stop
    self bestMinimumFitness := 0.95

    # number generations experiment has produced 
    self generationCount := 1

    # number of specimen to populate 
    self populationSize := 30

    # populate 
    for(i, 1, populationSize,

        # create new specimen 
        new := Specimen clone

        # calculate fitness of new specimen
        new fitness := evaluate(new)

        # add new specimen to population
        population append(new)
    )

    # index 0 = least fit, index populationSize - 1 = most fit
    sortByFitness

    # while fittest specimen's fitness is below minimum fitness threshold
    while(population at(population size - 1) fitness < bestMinimumFitness,

        # breed fittest parents to populate next generation
        generateNextGeneration

        # sort again 
        sortByFitness

        # increment generation count
        generationCount = generationCount + 1
    )

    # minimum fitness threshold has been reached, print population information
    "Final population\n" println
    printPopulation

    # print fittest specimen information
    "\nFittest specimen\n" println 
    population at(population size - 1) println

    # print number of generations
    "\nTook #{generationCount} generations" interpolate println

)

# prints each specimen in population's information
GARunner printPopulation := method(
    population foreach(specimen, 
        specimen println
    )
)

# uses an implementation of top-down merge sort
# creates list of sorted population and updates population to that list
GARunner sortByFitness := method(
    
    # top down merge implementation
    # given two halves of a list, left and right, 
    # create sorted list comprising all members of each list
    merge := method(left, right,

        # create result list
        result := List clone

        # current element index in left and right lists
        leftIndex := 0
        rightIndex := 0

        # while both left and right have elements that still need placed in result list
        while(leftIndex < left size and rightIndex < right size,

            # compare current element in left to current element in right
            comparison := left at(leftIndex) compare (right at (rightIndex))

            # if left element < right element
            if(comparison < 0) then(

                # add left element to result
                result append (left at (leftIndex))

                # increment index in left list
                leftIndex = leftIndex + 1
            ) else(
                
                # add right element to result
                result append (right at (rightIndex))

                # increment index in right list
                rightIndex = rightIndex + 1
            )
        )

        # while only left list has elements remaining,
        # add all elements
        while(leftIndex < left size, 
            result append (left at (leftIndex))
            leftIndex = leftIndex + 1
        )

        # while only right list has elements remaining,
        # add all elements
        while(rightIndex < right size, 
            result append (right at (rightIndex))
            rightIndex = rightIndex + 1
        )

        # return constructed sorted list
        return result
    )

    # top down merge sort
    # given a list, sorts and returns a copy of the list
    mergeSort := method(list, 
        
        # base case when list contains 0 or 1 elements (trivially sorted)
        if (list size <= 1, return list)

        # create left and right sublists
        left := List clone
        right := List clone

        # iterate through list
        for(i, 0, list size - 1,

            # if index lies on left half of list 
            if (i < list size / 2) then(

                # add element to left list
                left append(list at(i))
            ) else(

                # add element to right list
                right append(list at(i))
            )
        )

        # recursively sort left and right sublists
        left = mergeSort(left)
        right = mergeSort(right)

        # return sorted constructed list of left and right sublists
        return merge(left, right)
    )

    # call merge sort on population
    self population = mergeSort(self population)
)

# generates the next generation of the population
# hardcoded to use truncation breeding
GARunner generateNextGeneration := method(

    # create new population list
    newPop := List clone

    # iterate through population
    for(i, 0, population size,

        # create new specimen by 
        newSpec := population at(
                
                # selecting a specimen in population from truncation threshold index range, and
                population size - Random value(1, population size * truncationThreshold) round
            
            # breed that parent with 
            ) breed (

                # another selected specimen in truncation threshold index range
                population at(
                    population size - Random value(1, population size * truncationThreshold) round
                ), 
                
                # using this experiment's mutation rate
                mutationRate
            )

        # calculate new specimen's fitness 
        newSpec fitness := evaluate(newSpec)

        # add new specimen to next generation list
        newPop append (newSpec)
    )

    # set population to next generation
    population = newPop
)

# fitness function for the runner, hardcoded
# given a specimen, returns fitness value from 0 to 1
# where 0 indicates that specimen's a val + b val is nowhere close to 7
# and where 1 indicates that specimen's a + b is exactly 7
GARunner evaluate := method(specimen, 
    return  1 / ((specimen aTrait + specimen bTrait - 7) abs + 1)
)

# create specimen
Specimen := Object clone

# on init, generate random values in defined range for A value and B value traits
Specimen init := method(
    self aTrait := Random value(0, 4)
    self bTrait := Random value(3, 6)
)

# compares self with other specimen
Specimen compare := method(other, 
    if(self fitness < other fitness) then(
        return -1
    ) else(
        if(self fitness > other fitness) then(
            return 1
        ) else(
            return 0
        )
    )
)

# creates a new specimen utilizing the other specimen as parent B
# with a chance to generate new traits instead of inheriting from parents
# equal to the given mutation rate
Specimen breed := method(other, mutationRate,
    
    # create child specimen
    child := Specimen clone

    # if mutation should occur
    if(Random value < mutationRate) then(

        # do nothing, as random values were already generated upon creation of child
        nil
    ) else(

        # child's A, B value traits are inherited from parents,
        # with each parent having equal probability of giving trait
        if(Random value < 0.5, child aTrait = self aTrait, child aTrait = other aTrait)
        if(Random value < 0.5, child bTrait = self bTrait, child bTrait = other bTrait)
    )

    # return child
    return child
)

# override asString to print specimen information 
Specimen asString := method(
    "a = #{aTrait} | b = #{bTrait} | fitness = #{fitness}" interpolate
)

# method call to run experiment
GARunner start