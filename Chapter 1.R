# Chapter 1 Exercises

# Simple Arithmetic Function
1 + 1

2 * 3

4 - 1

6 / (4 - 1)

#Sequence of Integer from 100 to 130
100:130

#Incomplete Command
5-

1

#Excercise 1
28 + 2

30 * 3

90 - 6

84 / 3

#Dice
1:6

#Objects
a <- 1
a
a + 2

die <- 1:6
die

#Case sensitive (Different variables)
Name <- 1
name <- 0

#Overwrite
my_number <- 1
my_number <- 999

#Used objects (Know what variables have been used)
ls()

#Die's math
die + 1

die / 2

die * die

#Vector recycling
die + 1:2

die + 1:4

#Matrix Multiplication
#Inner Multiplication
die %*% die

#Outer Multiplication
die %o% die

#Functions
round(3.1415) #Rounds to 3

factorial(3)  #Factorializations to 6 

mean(1:6) #Mean from 1 to 6 = 3.5

mean(die) #Same as mean(1:6)

round(mean(die)) #Round the mean of die to 4

#Roll a die 
sample(x = die, size = 2) #Randomize a pair of die

sample(x = die, size = 1) #Randomize 1 result of die 

#Args of functions
args(round)

round(3.1415, digits = 2)

#Replacement
dice <- sample(die, size = 2, replace = TRUE) #create independent random samples (each die is independent)

#Sum
sum(dice) #Total of the two dice

#Create dice with Function
roll <- function() { #store the dice code into roll
die <- 1:6
dice <- sample(die, size = 2, replace = TRUE)
sum(dice)
}

roll()

#Create dice with arguments
roll2 <- function(bones <- 1:6) { 
die <- 1:6
dice <- sample(bones, size = 2, replace = TRUE)
sum(dice)
}

roll2()



