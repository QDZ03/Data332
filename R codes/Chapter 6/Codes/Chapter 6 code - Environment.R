#Return a list of the environments that R is using
library(devtools)
#parenvs(all = TRUE) ##Parent environments but not working?

#Refer to any environment in my tree
as.environment("package:stats")

globalenv()
baseenv()
emptyenv()

#Look up parent environment's parent 
parent.env(globalenv())

parent.env(emptyenv())# Empty do not have parent environment

ls(emptyenv()) #Return object saved in an environment

ls(globalenv())

setwd('C:/Users/quang/Downloads/Documents/Data 332/R-programming')
deck <- read.csv('Data/deck.csv')
deal <- function(cards) {
  cards[1, ]
}
deal(deck)

head(globalenv()$deck, 3)

assign("new", "Hello Global", envir = globalenv()) #Assign new value of the new object and save in an env
globalenv()$new

environment() #See current active environment

new <- "Hello Active" #Use '<-' instead of assign when there global env is active
new

roll <- function() {
  die <- 1:6
  dice <- sample(die, size = 2, replace = TRUE)
  sum
}

#Explore R's runtime environment, what are their parent environments, and what objects do they contain
show_env <- function(){
  list(ran.in = environment(),
       parent = parent.env(environment()),
       objects = ls.str(environment()))
}
show_env()

environment(show_env) #look up a function’s origin environment

#environment(parenvs) ## This is not in devtools package

show_env <- function(){
  a <- 1
  b <- 2
  c <- 3
  list(ran.in = environment(),
       parent = parent.env(environment()),
       objects = ls.str(environment()))
}

show_env() #R stores a, b, c in the runtime environment

foo <- "take me to your runtime"

#Ensures that a function will be able to find and use each of its arguments
show_env <- function(x = foo){
  list(ran.in = environment(),
       parent = parent.env(environment()),
       objects = ls.str(environment()))
}

show_env()

#Even without taking arguments in function, and with the call of deck object, it can still find and return an answer if it is in the same global environment
deal <- function() {
  deck[1, ]
}
deal()

DECK <- deck
deck <- deck[-1, ]
head(deck, 3)

#It suppose to be not working but mine still work
deal <- function() {
  card <- deck[1, ]
  deck <- deck[-1, ]
  card
}
deal()

#Solution for the deal function
deal <- function() {
  card <- deck[1, ]
  assign("deck", deck[-1, ], envir = globalenv())
  card
}
deal()

shuffle <- function(cards) {
  random <- sample(1:52, size = 52)
  cards[random, ]
}

#returns a shuffled copy of the deck object instead of shuffle the deck 
head(deck, 3)

a <- shuffle(deck)
head(deck, 3)

head(a, 3)

#Update so that it replaces the copy of deck that lives in the global environment
shuffle <- function(){
  random <- sample(1:52, size = 52)
  assign("deck", DECK[random, ], envir = globalenv())
}

shuffle()

deal()

#Store a copy of deck, Deck, and shuffle
setup <- function(deck) {
  DECK <- deck
  DEAL <- function() {
    card <- deck[1, ]
    assign("deck", deck[-1, ], envir = globalenv())
    card
  }
  SHUFFLE <- function(){
    random <- sample(1:52, size = 52)
    assign("deck", DECK[random, ], envir = globalenv())
  }
  list(deal = DEAL, shuffle = SHUFFLE)
}

cards <- setup(deck)

deal <- cards$deal
shuffle <- cards$shuffle

deal
shuffle

setup <- function(deck) {
  DECK <- deck
  DEAL <- function() {
    card <- deck[1, ]
    assign("deck", deck[-1, ], envir = parent.env(environment()))
    card
  }
  SHUFFLE <- function(){
    random <- sample(1:52, size = 52)
    assign("deck", DECK[random, ], envir = parent.env(environment()))
  }
  list(deal = DEAL, shuffle = SHUFFLE)
}
cards <- setup(deck)
deal <- cards$deal
shuffle <- cards$shuffle

rm(deck)
shuffle()
deal()
deal()
