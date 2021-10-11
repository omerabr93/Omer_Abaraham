library(readxl)
AvodatGmar <- read_excel("C:/Users/Omer/Desktop/AvodatGmar.xlsx", 
                         col_types = c("text", "numeric", "text", 
                                       "text", "text", "text", "numeric", 
                                       "text", "numeric", "text", "text", 
                                       "text", "numeric", "numeric", "numeric"))
View(AvodatGmar)
library(gmodels)
library(corrplot)
library(pROC)
summary(AvodatGmar)
AvodatGmar$Gender <- factor(AvodatGmar$Gender,order=T ,labels = c("Male","Female"))
AvodatGmar$`Family Status` <- factor(AvodatGmar$`Family Status`,order=T,labels = c("Divorce","Married","Single"))
AvodatGmar$`watch football` <- factor(AvodatGmar$`watch football`,order=T,labels = c("Yes","No"))
AvodatGmar$`Salary up/under 12k` <- factor(AvodatGmar$`Salary up/under 12k`,order=T,labels = c("Above","Under"))
AvodatGmar$`Ways to watch` <- factor(AvodatGmar$`Ways to watch`,order=T) ## ????????  ??????????
AvodatGmar$Gambler <- factor(AvodatGmar$Gambler,order=T,labels = c("Yes","No"))
AvodatGmar$Stattistics <- factor(AvodatGmar$Stattistics,order=T,labels = c("Yes","No"))
AvodatGmar$`Recommendation groups` <- factor(AvodatGmar$`Recommendation groups`,order=T,labels = c("Yes","No"))
library(dplyr)
AvodatGmar <- AvodatGmar %>% select(-`Ways to watch`)

AvodatGmar$Pred <- ifelse(AvodatGmar$Success >=5,1,0)

CrossTable(AvodatGmar$Pred,AvodatGmar$Gender, digits=2, chisq = TRUE ,prop.chisq=FALSE) ## ?????? ?????????????? ???? ???????????? ???? ??????????
CrossTable(AvodatGmar$Pred,AvodatGmar$`watch football`, digits=2, chisq = TRUE ,prop.chisq=FALSE) ## ?????????? ?????????? 
CrossTable(AvodatGmar$Pred,AvodatGmar$Gambler, digits=2, chisq = TRUE ,prop.chisq=FALSE)

AvodatGmar$`Amount of games per week`[is.na(AvodatGmar$`Amount of games per week`)] <- median(AvodatGmar$`Amount of games per week`,na.rm=T) 

set.seed(12)          
ntrain <- round(nrow(AvodatGmar)*0.8)      ##   ?????????? ???????? ?????????? 
tindex <- sample(nrow(AvodatGmar),ntrain)  ##  ?????????? ???????????????? ???? ????????????
train <- AvodatGmar[tindex,]  ##  ???????? ???? ?????????? 
test <- AvodatGmar[-tindex,]  ##  ???????? ???? ?????????? 


Model_glm2 <- step(glm(Pred~.,family=binomial, data=train),direction="both")
summary(Model_glm2)

train$Pred <-  predict (Model_glm2, train,type="response")
train$pred_ind <- ifelse(train$Pred > 0.5,1,0)
train_confMat <- table(train$Pred,train$pred_ind) %>%print ()
train_accuracy <- ((train_confMat[1,1]+train_confMat[2,2])/sum(train_confMat))  %>% print()
train_sensitivity <-(train_confMat[2,2] /sum(train_confMat[2,])) %>%print()
train_specificity <-(train_confMat[1,1] /sum(train_confMat[1,])) %>%print()
train_rocObject <- roc(test$Pred,test$pred_ind)
auc(test_rocObject)
train_TPR=rev(train_rocObject$sensitivities)
train_FPR=rev(1 - train_rocObject$specificities)
plot(train_FPR,train_TPR, type="o")
abline(0:1)


test$Pred <-  predict (Model_glm2, test,type="response")
test$pred_ind <- ifelse(test$Pred > 0.5,1,0)
test_confMat <- table(test$Pred,test$pred_ind) %>%print ()
test_accuracy <- ((test_confMat[1,1]+test_confMat[2,2])/sum(test_confMat))  %>% print()
test_sensitivity <-(test_confMat[2,2] /sum(test_confMat[2,])) %>%print()
test_specificity <-(test_confMat[1,1] /sum(test_confMat[1,])) %>%print()
test_rocObject <- roc(test$Pred,test$pred_ind)
auc(test_rocObject)
test_TPR=rev(test_rocObject$sensitivities)
test_FPR=rev(1 - test_rocObject$specificities)
plot(test_FPR,test_TPR, type="o")
abline(0:1)
