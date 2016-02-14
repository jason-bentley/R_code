# Author: Jason Bentley (2015)
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Associations between acute health and childhood development - NOT REAL DATA"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      tags$head(tags$style("#PDxPlot{height:90vh !important;}")),
      radioButtons("outcome","Developmental outcome:",
                   c("DHR"="DV2",
                     "Language and cognitive skills"="LANGCOGCategory_Num",
                     "Physical health and wellbeing"="PHYSCategory_Num",
                     "Social competence"="SOCCategory_Num",
                     "Emotional maturity"="EMOTCategory_Num",
                     "Communication skills"="COMGENCategory_Num"),
                   selected = "DV2"),
      br(),
      sliderInput("shrinkage","Shrinkage factor (variance) (not yet active):",min = 0.1,max = 5,value = 0.5),
      br(),
      checkboxGroupInput("PDx_chap","ICD-10-AM Chapter:",
                   c('Infectious and parasitic diseases'='Chp01_PDx',
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
                     'Symptoms, signs not elsewhere classified'='Chp18_PDx',
                     'Injury, poisoning and certain other consequences of external causes'='Chp19_PDx'),
                     selected=c('Chp06_PDx','Chp09_PDx','Chp10_PDx','Chp19_PDx')),
      br(),
      radioButtons("imputed","Include adjustment for partially measured confounders",c("No"="0","Yes"="1"),selected = "0",inline=TRUE)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(width=6,
      tabsetPanel(
      tabPanel("Penalised associations",plotOutput("PDxPlot"))
      )
    )
  )
))
