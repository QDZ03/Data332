setwd('C:/Users/quang/Downloads/Documents/Data 332/R-programming/Chapter 4')

deck <- read.csv('Data/deck.csv')

deal(deck)

head(deck)
deck[1, 1]
deck[1, c(1, 2, 3)]

deck[c(1,1), c(1,2,3)]

vec <- c(6,1,3,6,10,5)
vec[1:3]

deck[1:2, 1:2]
deck[1:2, 1, drop = FALSE]
# Negative Integers
deck[-(2:52), 1:3]

# Zero
deck[0, 0]

# Blank Spaces (Returns all values)
deck[1, ]

# Logical Values
deck[1, c(TRUE, TRUE, FALSE)]

rows <- c(TRUE, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F,
          F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F,
          F, F, F, F, F, F, F, F, F, F, F, F, F, F)
deck[rows, ]

# Names
deck[1, c("face", "suit", "value")]

deck[ , "value"]

# Deal a card
deal <- function(cards) {
  cards[1, ]
}

deal(deck)
deal(deck)
deal(deck)

# Shuffle Cards

deck2 <- deck[1:52, ]
head(deck2)

deck3 <- deck[c(2, 1, 3:52), ]
head(deck3)

## Randomizes the values
random <- sample(1:52, size = 52)
random

deck4 <- deck[random, ]
head(deck4)

shuffle <- function(cards) {
  random <- sample(1:52, size = 52)
  cards[random, ]
}

deal(deck)
deck2 <- shuffle(deck)
deal(deck2)

# Dollar signs and Double Brackets
deck$value # Returns all values as a vector
mean(deck$value)
median(deck$value)

lst <- list(numbers = c(1, 2), logical = T, strings = c("a", "b", "c"))
lst

lst[1] 
lst$numbers 

sum(lst$numbers)

lst[[1]] 

lst["numbers"] 
lst[["numbers"]] 
