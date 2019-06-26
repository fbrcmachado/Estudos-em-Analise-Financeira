###FONTE: https://lamfo-unb.github.io/2017/07/22/intro-analise-acoes-1/



rm(list=ls())
install.packages("quantmod")
install.packages("ggplot2")
library(quantmod)
library(ggplot2)

pbr <- getSymbols("PBR", src = "yahoo", from = "2013-01-01", to = "2017-06-01", auto.assign = FALSE)

head(pbr)
tail(pbr)
summary(pbr)
str(pbr)


ggplot(pbr, aes(x = index(pbr), y = pbr[,6])) + geom_line(color = "darkblue") +
  ggtitle("Série de preços da Petrobras") +
  xlab("Data") + ylab("Preço ($)") + theme(plot.title = element_text(hjust = 0.5)) + 
  scale_x_date(date_labels = "%b %y", date_breaks = "6 months")


pbr_mm <- subset(pbr, index(pbr) >= "2016-01-01")

pbr_mm10 <- rollmean(pbr_mm[,6], 10, fill = list(NA, NULL, NA), align = "right")
pbr_mm30 <- rollmean(pbr_mm[,6], 30, fill = list(NA, NULL, NA), align = "right")

pbr_mm$mm10 <- coredata(pbr_mm10)
pbr_mm$mm30 <- coredata(pbr_mm30)


ggplot(pbr_mm, aes(x = index(pbr_mm))) + geom_line(aes(y = pbr_mm[,6], color = "PBR")) + 
  ggtitle("Série de preços da Petrobras") +
  geom_line(aes(y = pbr_mm$mm10, color = "MM10")) +
  geom_line(aes(y = pbr_mm$mm30, color = "MM30")) +
  xlab("Data") + ylab("Preço ($)") +
  theme(plot.title = element_text(hjust = 0.5), panel.border = element_blank()) +
  scale_x_date(date_labels = "%b %y", date_breaks = "3 months") +
  scale_colour_manual("Séries", values=c("PBR"="gray40", "MM10"="firebrick4", "MM30"="darkcyan"))
