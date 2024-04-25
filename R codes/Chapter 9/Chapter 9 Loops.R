#Expected Values
die <- c(1, 2, 3, 4, 5, 6)

rolls <- expand.grid(die, die) #Way to pair the dies

rolls$value <- rolls$Var1 + rolls$Var2
head(rolls, 3)

prob <- c("1" = 1/8, "2" = 1/8, "3" = 1/8, "4" = 1/8, "5" = 1/8, "6" = 3/8)
prob

rolls$Var1

prob[rolls$Var1]

rolls$prob1 <- prob[rolls$Var1] #Prob of rolling var 1
head(rolls, 3)

rolls$prob2 <- prob[rolls$Var2] #Prob of rolling var 2
head(rolls, 3)

rolls$prob <- rolls$prob1 * rolls$prob2 #Prob of rolling both at the same time
head(rolls, 3)

sum(rolls$value * rolls$prob) #Expected Value

#Slot Machine
wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
combos <- expand.grid(wheel, wheel, wheel, stringsAsFactors = FALSE)
combos

get_symbols <- function() {
  wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
  sample(wheel, size = 3, replace = TRUE,
         prob = c(0.03, 0.03, 0.06, 0.1, 0.25, 0.01, 0.52))
}

prob <- c("DD" = 0.03, "7" = 0.03, "BBB" = 0.06,
          "BB" = 0.1, "B" = 0.25, "C" = 0.01, "0" = 0.52) #Isolate the prob

combos$prob1 <- prob[combos$Var1] #Combo for each var
combos$prob2 <- prob[combos$Var2]
combos$prob3 <- prob[combos$Var3]

head(combos, 3)

combos$prob <- combos$prob1 * combos$prob2 * combos$prob3 #Total prob when combine all 3 vars
head(combos, 3)

sum(combos$prob) #Total prob

symbols <- c(combos[1, 1], combos[1, 2], combos[1, 3])

score(symbols)

#for loops
for (value in c("My", "first", "for", "loop")) {
  print("one run") #Print "one run" in each column
}

for (value in c("My", "second", "for", "loop")) {
  print(value) #Print the column value
}

value #Return final value

#save output from a for loop
for (value in c("My", "third", "for", "loop")) {
  value
}

chars <- vector(length = 4)

words <- c("My", "fourth", "for", "loop")
for (i in 1:4) {
  chars[i] <- words[i]
}
chars

combos$prize <- NA
head(combos, 3)

#Score for the 1st 3 rows
for (i in 1:nrow(combos)) { 
  symbols <- c(combos[i, 1], combos[i, 2], combos[i, 3])
  combos$prize[i] <- score(symbols)
}
head(combos, 3)

#Expected value of the prize
sum(combos$prize * combos$prob)

#New score function
score <- function(symbols) {
  diamonds <- sum(symbols == "DD")
  cherries <- sum(symbols == "C")
  # identify case
  # since diamonds are wild, only nondiamonds
  # matter for three of a kind and all bars
  slots <- symbols[symbols != "DD"]
  same <- length(unique(slots)) == 1
  bars <- slots %in% c("B", "BB", "BBB")
  # assign prize
  if (diamonds == 3) {
    prize <- 100
  } else if (same) {
    payouts <- c("7" = 80, "BBB" = 40, "BB" = 25,
                 "B" = 10, "C" = 10, "0" = 0)
    prize <- unname(payouts[slots[1]])
  } else if (all(bars)) {
    prize <- 5
  } else if (cherries > 0) {
    # diamonds count as cherries
    # so long as there is one real cherry
    prize <- c(0, 2, 5)[cherries + diamonds + 1]
  } else {
    prize <- 0
  }
  # double for each diamond
  prize * 2^diamonds
}

#Update expected value
for (i in 1:nrow(combos)) {
  symbols <- c(combos[i, 1], combos[i, 2], combos[i, 3])
  combos$prize[i] <- score(symbols)
}

sum(combos$prize * combos$prob)

#While loops
plays_till_broke <- function(start_with) {
  cash <- start_with
  n <- 0
  while (cash > 0) {
    cash <- cash - 1 + play()
    n <- n + 1
  }
  n #Return number of play when have $100
}
plays_till_broke(100)

#Repeat loops
plays_till_broke <- function(start_with) {
  cash <- start_with
  n <- 0
  repeat {
    cash <- cash - 1 + play()
    n <- n + 1
    if (cash <= 0) {
      break
    }
  }
  n
}
plays_till_broke(100)

