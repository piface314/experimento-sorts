# install.packages('psych')
# install.packages('car')
# install.packages('DescTools')
# install.packages('daewr')
# install.packages('kableExtra')
# install.packages('tidyverse')
# install.packages('hrbrthemes')
# install.packages("reshape")
# install.packages("reshape2")
install.packages("corrplot")

library("psych")
library("car")
library("DescTools")
library("daewr")
library("tidyverse")
library(ggplot2)
library(dplyr)
library("reshape")
library("reshape2")
library(corrplot)


df <- read.csv("data.csv", header = TRUE)
df$algorithm <- as.factor(df$algorithm)
df$language <- as.factor(df$language)
df$time <- df$time * 1000

df |> group_by(algorithm, language) |>
  summarize(media=mean(time), desv.pad=sd(time))

ggplot(df,aes(language,time))+geom_boxplot(aes(fill=algorithm))
  + labs(x = "Linguagem", y = "Tempo (ms)")

fit <- aov(time ~ algorithm + language + algorithm*language, data = df)
summary(fit)
plot(fit)

modelo <- glm(time ~ language + algorithm + language*algorithm,
              data=df,
              family=Gamma())
summary(modelo)
anova(modelo, test="Chisq")

tukey = TukeyHSD(fit)
print(tukey)
plot(tukey)


df$inter <- interaction(df$language, df$algorithm)
df2 <- melt(df, c("sample", "inter"), "time") |> cast(sample ~ inter)
corrplot(cor(df2))


