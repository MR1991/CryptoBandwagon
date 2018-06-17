
# Load libraries -------------------------------------------------------------------
library(rpart)
library(dplyr)
library(ggplot2)
library(modelr)

# Load Data ------------------------------------------------------------------------
# Variable	Definition	Key
# Survival: Survival	0 = No, 1 = Yes
# Pclass:   Ticket class	1 = 1st, 2 = 2nd, 3 = 3rd
# Sex:    	Sex	
# Age:	    Age in years	
# SibSp:    # of siblings / spouses aboard the Titanic	
# Parch:    # of parents / children aboard the Titanic	
# Ticket:   Ticket number	
# Fare:     Passenger fare	
# Cabin:    Cabin number	
# Embarked: Port of Embarkation	C = Cherbourg, Q = Queenstown, S = Southampton

train <- read.csv("train.csv", stringsAsFactors = FALSE)
test <- read.csv("test.csv", stringsAsFactors = FALSE)

# Train model -----------------------------------------------------------------------

model  <- train %>% filter(!is.na(Age)) %>% rpart(Survived ~Age + Embarked + Fare, .)
model2 <- train %>% filter(!is.na(Age)) %>% rpart(Survived ~Age + Embarked + Fare + Sex, .)
model  <- train %>% select(-Name, -Ticket, -Cabin, -Prediction) %>% filter(!is.na(Age)) %>% rpart(Survived ~. , .)

# Visualize results -----------------------------------------------------------------
par(mfrow = c(1,2), xpd = NA)
plot(model)
text(model, use.n = TRUE)

# Statistics ------------------------------------------------------------------------
summary(model)
train$Prediction <- predict(model, train, type = "vector") >= 0.5

# Comparison table ---------------------------------------------------------------------
paste(format(rmse(model, train), digits = 2), format(rmse(model2, train), digits = 2))
paste(format(rsquare(model, train), digits = 2), format(rsquare(model2, train), digits = 2))
paste(format(mae(model, train), digits = 2), format(mae(model2, train), digits = 2))





