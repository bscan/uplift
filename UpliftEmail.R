
#install.packages('uplift')
library(uplift)



url = "https://raw.githubusercontent.com/bscan/uplift/master/Kevin_Hillstrom_MineThatData_E-MailAnalytics_DataMiningChallenge_2008.03.20.csv"
hc = read.csv(file=url)
hc$treat <- ifelse(as.character(hc$segment) != "No E-Mail", 1, 0)



prop.test(c(sum(hc$visit[hc$treat==1]), sum(hc$visit[hc$treat==0])), c(sum(hc$treat==1), sum(hc$treat==0)))


model <- upliftRF(visit ~ recency + mens + womens + zip_code + newbie + channel + trt(treat),
                 data = hc, 
                 mtry = 3,
                 ntree = 10, 
                 split_method = "KL",
                 minsplit = 100,
                 verbose = FALSE)
summary(model)



pred <- predict(model, hc)
perf <- performance(pred[, 1], pred[, 2], hc$visit, hc$treat, direction = 1)
Q <- qini(perf, plotit = TRUE)



