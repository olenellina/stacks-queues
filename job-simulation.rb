require './Stack.rb'
require './Queue.rb'

waitingQueue = Queue.new
employeeStack = Stack.new

# Method to print out the waiting queue
def printQueue(waitingQueue)
  waitingQueue.size.times do |x|
    puts "Waiting Queue ID: #{waitingQueue.front}"
    waitingQueue.enqueue(waitingQueue.dequeue)
  end
end

# Method to print out the employee stack
# This one was more complex, as I had to create a new stack within the method to transfer employees to
# I then have to transfer them back to the employee stack to ensure the program runs according to the requirements of first in last out
# It's during this step, that I print them out (ensures they print out in the correct order)
def printStack(employeeStack)
  transferStack = Stack.new
  employeeStack.size.times do |x|
      transferStack.push(employeeStack.pop)
  end
  transferStack.size.times do |x|
    employeeStack.push(transferStack.pop)
    puts "Employee ID: #{employeeStack.top}"
  end
end

# Method to move candidates from the waiting queue to the employee stack
def genEmployeeList(waitingQueue, employeeStack, num)
  num.times do
      employeeStack.push(waitingQueue.dequeue)
  end
end

# The simulation will run while play is true, this ensures it runs at least once
play = true
# The idArray will hold the ID numbers, so that I can check for duplicate values
idArray = []
# The program flow is different depending on whether this is the first run or subsequent runs
firstRun = true
puts "Welcome to the Hire/Fire program!"

while play
  puts "\nHow many people need jobs? "
  jobSeekers = gets.chomp.to_i
  # Here I'm trying to ensure we have a reasonably sized waiting queue, which relates to the size of the random number pool
  # While this isn't strictly necessary, it helps ensure we can have a few runs before we hit potential duplicate IDs
  while jobSeekers < 6 || jobSeekers > 100
    puts "Please enter a number greater than 6 and less than  100: "
    jobSeekers = gets.chomp.to_i
  end

  # Generating random IDs for candidates entering the waiting queue
  jobSeekers.times do
    ranID = rand(100..999)
    if idArray.length < 900
      # This loop will run until ranID is not a value already contained in the idArray
      while idArray.include?(ranID)
        ranID = rand(100..999)
      end
    else
        # I could instead end the program here, instead of allowing potential duplication
        # The random number range could also be increased, depending on user needs
        puts "You've hit the limit of unique employee IDs. Duplicates are now possible."
        ranID = rand(100..999)
    end
    idArray.push(ranID)
    waitingQueue.enqueue(ranID)
  end

  # Program flow that is unique to the first run
  if firstRun == true
    puts "\nInitial Waiting List: "
    printQueue(waitingQueue)

    genEmployeeList(waitingQueue, employeeStack, 6)

    puts "\nWe were able to hire 6 people!\n\nHired List: "
    printStack(employeeStack)
    firstRun = false

    puts "\nRemaining Waiting List: "
    printQueue(waitingQueue)

  # Program flow that repeats for each run
  else
    puts "\nUpdated Waiting List: "
    printQueue(waitingQueue)

    puts "\nStarting Employee List: "
    printStack(employeeStack)
  end

  # Rolling the die
  die = rand(1..6)
  puts "\nAfter Three Months -------- The Manager Rolls the Die = #{die}\n\n"

  # Generating the fire list, based on the die roll
  die.times do
      puts "Employee ID: #{employeeStack.top} is fired."
      waitingQueue.enqueue(employeeStack.pop)
  end

  # Hiring based on how many available positions were freed up as a result of the die roll
  genEmployeeList(waitingQueue, employeeStack, die)

  puts "\nWe were able to hire #{die} people!\n\nUpdated Employee List: "
  printStack(employeeStack)

  puts "\nRemaining Waiting List: "
  printQueue(waitingQueue)

  # Seeing whether the use wants to run the simulation again
  puts "\nDo you need another round of Hire/Fire? "
  userChoice = gets.chomp.downcase
  if userChoice == "yes" || userChoice == "y"
    play = true
  else
    play = false
  end
end
