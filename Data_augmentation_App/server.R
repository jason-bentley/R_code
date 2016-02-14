library(shiny)
library(dplyr)

# Define server logic required to create caterpillar plot
shinyServer(function(input, output, session) {
  observe({
    list.var <- list('Infectious and parasitic diseases'='Chp01_PDx',
                       'Neoplasms'='Chp02_PDx',
                       'Diseases of the blood and blood-forming organs and immune mechanism'='Chp03_PDx',
                       'Endocrine, nutritional and metabolic diseases'='Chp04_PDx',
                       'Mental and behavioural disorders'='Chp05_PDx',
                       'Nervous system diseases'='Chp06_PDx',
                       'Diseases of eye and adnexa'='Chp07_PDx',
                       'Diseases of ear and mastoid'='Chp08_PDx',
                       'Circulatory system diseases'='Chp09_PDx',
                       'Respiratory diseases'='Chp10_PDx',
                       'Digestive diseases'='Chp11_PDx',
                       'Diseases of the skin and subcutaneous tissue'='Chp12_PDx',
                       'Diseases of the musculoskeletal system and connective tissue'='Chp13_PDx',
                       'Genitourinary system diseases'='Chp14_PDx',
                       'Certain conditions originating in the perinatal period'='Chp16_PDx',
                       'Congenital anomalies'='Chp17_PDx',
                       'Injury, poisoning and certain other consequences of external causes'='Chp19_PDx')
    updateCheckboxGroupInput(session,"PDx_chap","ICD-10-AM Chapter:",choices=list.var,selected=c('Chp06_PDx','Chp09_PDx','Chp10_PDx','Chp19_PDx'))
  })
  
  data0 = read.csv(file="simulated_data.csv",sep=",",header=T)
  max.x = max(data0$UpperCL)
  InputData <- reactive({
    data0 %>% filter(outcome==input$outcome & chapter%in%c(input$PDx_chap) & impute_flag == input$imputed)
  })
  
  output$PDxPlot <- renderPlot({
    # plotting penalised associations for primary diagnoses
    # plot should be according to order and chapters noted - leave a clear space for separation
    par(las=1,mar=c(4,40,0.1,0.1),oma=c(0,0,0,0))
    data <- InputData()
    n.parm = dim(data)[1]
    cols = rep("blue",n.parm)
    cols[data$LowerCL <= 1 & data$UpperCL >= 1] <- "black"
    data$indx = c(1:n.parm)
    plot(data$OddsRatioEst,c(1:n.parm),pch=19,main="",xaxs="i",yaxs="i",ylim=c(0,n.parm+1),col=cols,cex=0,xlim=c(0,max.x),axes=F,ylab="",xlab="Adjusted Odds Ratio and\n95% Profile Likelihood Confidence Limits")
    abline(v=c(1),lty=c(1),col="grey")
    for (i in 1:n.parm){lines(c(data$LowerCL[i],data$UpperCL[i]),c(i,i),col="black")}
    axis(2,at=c(1:n.parm),labels=data$Dx_desc,lwd.ticks=0)
    axis(1,at=c(0:floor(max.x)),labels=c(0:floor(max.x)))
    box()
    points(data$OddsRatioEst,c(1:n.parm),pch=19)
    data.sig <- data[(data$LowerCL <= 1 & data$UpperCL >= 1)==FALSE,]
    points(data.sig$OddsRatioEst,data.sig$indx,pch=19,col="skyblue")
    for (i in 1:dim(data.sig)[1]){lines(c(data.sig$LowerCL[i],data.sig$UpperCL[i]),c(data.sig$indx[i],data.sig$indx[i]),col="skyblue",lwd=0.5)}
  })
  
})