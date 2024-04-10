#Slot machine
get_symbols <- function() {
  wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
  sample(wheel, size = 3, replace = TRUE,
         prob = c(0.03, 0.03, 0.06, 0.1, 0.25, 0.01, 0.52))
}

get_symbols()
score(c("DD", "DD", "DD"))

play <- function() {
  # step 1: generate symbols
  symbols <- get_symbols()
  # step 2: display the symbols
  print(symbols)
  # step 3: score the symbols
  score(symbols)
}

#If Statements
num <- -2 # True
if (num < 0) {
  num <- num * -1
}
num

num <- 4 # False 
if (num < 0) {
  num <- num * -1
}
num

num <- -1
if (num < 0) {
  print("num is negative.")
  print("Don't worry, I'll fix it.")
  num <- num * -1
  print("Now num is positive.")
}
num

#Quiz A: x returns 2
x <- 1
if (3 == 3) {
  x <- 2
}
x

#Quiz B: x returns 2
x <- 1
if (TRUE) {
  x <- 2
}
x

#Quiz C: x returns 2
x <- 1
if (x == 1) {
  x <- 2
  if (x == 1) {
    x <- 3
  }
}
x

#Else statement
#Isolate the decimal component
a <- 3.14 
dec <- a - trunc(a)
dec

if (dec >= 0.5) {
  a <- trunc(a) + 1
} else {
  a <- trunc(a)
}
a

a <- 1
b <- 1
if (a > b) {
  print("A wins!")
} else if (a < b) {
  print("B wins!")
} else {
  print("Tie.")
}

#Test
symbols <- c("7", "7", "7")

#Check
symbols[1] == symbols[2] & symbols[2] == symbols[3]
all(symbols == symbols[1])

length(unique(symbols) == 1)

#Cont. Slot machine
same <- symbols[1] == symbols[2] && symbols[2] == symbols[3] # Check if it is three of a kind

bars <- symbols %in% c("B", "BB", "BBB") #Check if it is bar prize

if (same) {
  symbol <- symbols[1]
  if (symbol == "DD") {
    prize <- 800
  } else if (symbol == "7") {
    prize <- 80
  } else if (symbol == "BBB") {
    prize <- 40
  } else if (symbol == "BB") {
    prize <- 5
  } else if (symbol == "B") {
    prize <- 10
  } else if (symbol == "C") {
    prize <- 10
  } else if (symbol == "0") {
    prize <- 0
  }
}

#Prize pool for three of a kind
payouts <- c("DD" = 100, "7" = 80, "BBB" = 40, "BB" = 25,
             "B" = 10, "C" = 10, "0" = 0)
payouts

payouts["DD"]
unname(payouts["DD"]) #Not return the name

#Test
symbols <- c("C", "DD", "C")
symbols == "C"
sum(symbols == "C")
sum(symbols == "DD")

#Full slot machine codes
get_symbols <- function() {
  wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
  sample(wheel, size = 3, replace = TRUE,
         prob = c(0.03, 0.03, 0.06, 0.1, 0.25, 0.01, 0.52))
}

get_symbols()

score <- function (symbols) {
  # identify case
  same <- symbols[1] == symbols[2] && symbols[2] == symbols[3]
  bars <- symbols %in% c("B", "BB", "BBB")
  # get prize
  if (same) {
    payouts <- c("DD" = 100, "7" = 80, "BBB" = 40, "BB" = 25,
                 "B" = 10, "C" = 10, "0" = 0)
    prize <- unname(payouts[symbols[1]])
  } else if (all(bars)) {
    prize <- 5
  } else {
    cherries <- sum(symbols == "C")
    prize <- c(0, 2, 5)[cherries + 1] # 1C = 0, 2C = 2, 3c = 5
  }
  # adjust for diamonds
  diamonds <- sum(symbols == "DD")
  prize * 2 ^ diamonds
}
play <- function() {
  symbols <- get_symbols()
  print(symbols)
  score(symbols)
}

play()
