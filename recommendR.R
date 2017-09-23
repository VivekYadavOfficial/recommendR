#Install required libraries
#install.packages("recommenderlab")

#Load required packages
library(data.table)
library(recommenderlab)

#Load Movielens 100k data (ua.base)
train <- fread("C:/users/Vivek/Desktop/100k/ml-100k/ua.base", header=FALSE, sep='\t', col.names = c("userid","movieid","rating","timestamp"))

#Summary statistics of data
summary(train)

#Convert the the loaded train data into a "realRatingMatrix" object
train.data <- as(train[,-4],"realRatingMatrix")

#Visualize data
image(train.data)

#I will use the loaded base data for using both training and testing purposes
#Normalizing the data. You can ignore this depending on your choice
train.nm <- normalize(train.data)

#Visualize data after normalization
image(train.nm)

#Now training a recommender
#Recommender based on popularity
r <- Recommender(train.nm, method="POPULAR")

#Defining evaluation scheme (criteria for evaluating recommender) 
eval <- evaluationScheme(train.data, method="split", train=0.9, given=10, goodRating=3)

#Now we can compare or evaluate different recommenders. Here I'm doing both with the UBCF and IBCF types
#Training UBCF(user-based collaborative filtering) recommender
r.ubcf <- Recommender(getData(eval,"train"),"UBCF")

#Training IBCF(item-based collaborative filtering) recommender
r.ibcf <- Recommender(getData(eval,"train"),"IBCF")

#Prediction by UBCF recommender with the type "ratings"
p.ubcf <- predict(r.ubcf, getData(eval,"known"), type="ratings")

#Prediction by IBCF recommender with the type "ratings"
p.ibcf <- predict(r.ibcf, getData(eval,"known"), type="ratings")

#error calculation for both types of recommenders and combining them in single data.frame
error <- rbind(UBCF=calcPredictionAccuracy(p.ubcf, getData(eval,"unknown")), IBCF=calcPredictionAccuracy(p.ibcf, getData(eval,"unknown")))

#print error to compare prediction accuracy of both the recommenders
error