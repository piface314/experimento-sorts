# install.packages('psych')
# install.packages('car')
# install.packages('DescTools')
# install.packages('daewr')
# install.packages('kableExtra')
# install.packages('tidyverse')


install.packages('hrbrthemes')

library("psych")
library("car")
library("DescTools")
library("daewr")
library("tidyverse")
library(ggplot2)
library(dplyr)
library(hrbrthemes)
hrbrthemes::import_roboto_condensed()


df <- read.csv("data2.csv", header = TRUE)

df$algorithm <- as.factor(df$algorithm)
df$language <- as.factor(df$language)

df

df |> group_by(algorithm, language) |>  summarize(media=mean(time), desv.pad=sd(time))

df |> filter(language == "c") |>
  ggplot(aes(x=time, fill=algorithm)) +
  geom_histogram(bins = 100, color="#e9ecef", alpha=0.6, position = 'identity') +
  #scale_fill_manual(values=c("#69b3a2", "#404080", "#804040", "#a2b369")) +
  theme_ipsum() +
  labs(fill="")

df |> filter(language == "python") |>
  ggplot(aes(x=time, fill=algorithm)) +
  geom_histogram(bins = 100, color="#e9ecef", alpha=0.6, position = 'identity') +
  #scale_fill_manual(values=c("#69b3a2", "#404080", "#804040", "#a2b369")) +
  theme_ipsum() +
  labs(fill="")

df |> filter(language == "lua") |>
  ggplot(aes(x=time, fill=algorithm)) +
  geom_histogram(bins = 100, color="#e9ecef", alpha=0.6, position = 'identity') +
  #scale_fill_manual(values=c("#69b3a2", "#404080", "#804040", "#a2b369")) +
  theme_ipsum() +
  labs(fill="")

#df |> with(table(algorithm, language))
#  as.data.frame() |> ggplot(aes(factor(Fertilizante), Freq, fill = Praga)) +     
#  geom_col(position = 'dodge')  # |> barplot(beside = TRUE, legend = TRUE)


#df |> ggplot(aes(x=Fertilizante, y=Producao, color=Fertilizante)) +
#  geom_boxplot(outlier.shape=NA) +
#  geom_jitter(width=0.2)

# 
# df |> ggplot(aes(x=Praga, y=Praga)) +
#   geom_boxplot(outlier.shape = NA)
# 
#df |> ggplot(aes(x=Fertilizante, y=Producao, color=Fertilizante)) +
#   geom_boxplot(outlier.shape = NA)



#x <- sqrt(df$Producao)
#qqPlot(x, id=F, main="QQ Plot para produção")
#shapiro.test(x)

#fit <- aov(sqrt(Producao) ~ Fertilizante, data = df)
#summary(fit)
#plot(fit)

#tukey = TukeyHSD(fit)
#print(tukey)
#plot(tukey)

#modelo <- glm(Praga ~ Fertilizante, data=df, family=binomial(link = "logit"))
#summary(modelo)

#anova(modelo, test="Chisq")
