library(rsconnect)
library(shiny)
library(tidyverse)
library(maps)
library(plotly)
library(shinyWidgets)
library(tm)
library(wordcloud)

df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv')
athletes <- read.csv("df_athlete.csv",stringsAsFactors = FALSE) 
dim(athletes)

athletes <- athletes %>% 
    mutate(Medal=replace_na(Medal,0),
           Gold=replace_na(Gold,0),
           Silver=replace_na(Silver,0),
           Bronze=replace_na(Bronze,0),
           Medal_Count = Gold + Silver + Bronze,
           Medal_Value = Gold*3 + Silver*2 + Bronze,
           Sex=if_else(Sex=="F","1","2"))

athletes <- 
    athletes %>% 
    select(-c(City)) %>% 
    drop_na()

dim(athletes)  

ageRange <- c(min(athletes$Age),max(athletes$Age))
weightRange <- c(min(athletes$Weight),max(athletes$Weight))
heightRange <- c(min(athletes$Height),max(athletes$Height))

test_df <-  athletes %>% 
    group_by(Sex) %>% 
    count()

ui <- fluidPage(
    
    titlePanel("Olympics Medal Explorer"),
    
    fluidPage(
        title="Olympics Medal Explorer",
        
        fluidRow(
            column(
                width=3,
                style = "background-color:#f0f0f0;",
                
                strong("Medals"),
                checkboxGroupInput("sideMedals", label = NULL, 
                                   choices = list("Gold" = 3, "Silver" = 2, "Bronze" = 1, "No Medal" = 0),
                                   selected = c(1,2,3)),
                
                sliderInput("year_imput", label = h3("Time Line"),
                            min = 1896, max = 2016, value = c(1896, 2010),width="100%",sep=""
                ),
                strong("Sex"),
                checkboxGroupInput("sideSex", label = NULL, 
                                   choices = list("Female" = 1, "Male" = 2),
                                   selected = c(1,2)),
                
                pickerInput("country_input","Country", 
                            choices=unique(athletes$country),
                            selected = unique(athletes$country),
                            options = list(`actions-box` = TRUE),multiple = T),
                
                pickerInput("sport_input","Sport", 
                            choices=unique(athletes$Sport),
                            selected = c("Gymnastics","Swimming","Athletics","Rowing",
                                         "Cycling"),
                            options = list(`actions-box` = TRUE),multiple = T),
                
                strong("Age"),
                plotOutput("histAge", height="8%"),
                sliderInput("sideAge", label = NULL, width="100%",
                            min = ageRange[1], max = ageRange[2], value = ageRange
                ),
                strong("Weight (kg)"),
                plotOutput("histWeight", height="8%"),
                sliderInput("sideWeight", label=NULL, width="100%",
                            min = weightRange[1], max = weightRange[2], value = weightRange
                ),
                strong("Height (cm)"),
                plotOutput("histHeight", height="8%"),
                sliderInput("sideHeight", label=NULL, width="100%",
                            min = heightRange[1], max = heightRange[2], value = heightRange
                )
            ),
            column(
                width=8,
                tabsetPanel(
                    tabPanel("Map", 
                             plotlyOutput("world_map",height = 800)), 
                    tabPanel("Sports",
                             plotOutput("word_cloud",height = 700),
                             br(),
                             br(),
                             plotOutput("lineSports",height = 500)
                             )
                   
                    ))
            
        )
        
        
    )
    
)

server <- function(input, output) {
    
    observe(print(input$sideAge))
    
    output$sideMedals <- renderPrint({ input$sideMedals })
    
    output$sideAge <- renderPrint({ input$sideAge })
    
    output$sideWeight <- renderPrint({ input$sideWeight })
    
    output$histAge <- renderPlot(
        athletes %>% 
            filter(Year>input$year_imput[1],
                   Year<input$year_imput[2],
                   country %in% input$country_input,
                   Age >= input$sideAge[1],
                   Age <= input$sideAge[2],
                   Weight >= input$sideWeight[1],
                   Weight <= input$sideWeight[2],
                   Height >= input$sideHeight[1],
                   Height <= input$sideHeight[2],
                   Medal_Value %in% input$sideMedals,
                   Sex %in% input$sideSex,
                   Sport %in% input$sport_input) %>% 
            ggplot(aes(Age)) + 
            geom_histogram(binwidth=2, fill="#56B4E9") +
            theme_minimal() +
            theme(axis.text.x=element_blank(),
                  axis.ticks.x=element_blank(),
                  axis.text.y=element_blank(),
                  axis.ticks.y=element_blank(),
                  plot.background = element_rect(fill = "#f0f0f0", color = "#f0f0f0")) +
            xlim(ageRange[1],ageRange[2]) +
            labs(x = NULL, y = NULL)
        , height=100)
    
    output$histWeight <- renderPlot(
        athletes %>% 
            filter(Year>input$year_imput[1],
                   Year<input$year_imput[2],
                   country %in% input$country_input,
                   Age >= input$sideAge[1],
                   Age <= input$sideAge[2],
                   Weight >= input$sideWeight[1],
                   Weight <= input$sideWeight[2],
                   Height >= input$sideHeight[1],
                   Height <= input$sideHeight[2],
                   Medal_Value %in% input$sideMedals,
                   Sex %in% input$sideSex,
                   Sport %in% input$sport_input) %>% 
            ggplot(aes(Weight)) + 
            geom_histogram(binwidth=5, fill="#56B4E9") +
            theme_minimal() +
            theme(axis.text.x=element_blank(),
                  axis.ticks.x=element_blank(),
                  axis.text.y=element_blank(),
                  axis.ticks.y=element_blank(),
                  plot.background = element_rect(fill = "#f0f0f0", color = "#f0f0f0")) +
            xlim(weightRange[1],weightRange[2]) +
            labs(x = NULL, y = NULL)
        , height=100)
    
    output$histHeight <- renderPlot(
        athletes %>% 
            filter(Year>input$year_imput[1],
                   Year<input$year_imput[2],
                   country %in% input$country_input,
                   Age >= input$sideAge[1],
                   Age <= input$sideAge[2],
                   Weight >= input$sideWeight[1],
                   Weight <= input$sideWeight[2],
                   Height >= input$sideHeight[1],
                   Height <= input$sideHeight[2],
                   Medal_Value %in% input$sideMedals,
                   Sex %in% input$sideSex,
                   Sport %in% input$sport_input) %>% 
            ggplot(aes(Height)) + 
            geom_histogram(binwidth=5, fill="#56B4E9") +
            theme_minimal() +
            theme(axis.text.x=element_blank(),
                  axis.ticks.x=element_blank(),
                  axis.text.y=element_blank(),
                  axis.ticks.y=element_blank(),
                  plot.background = element_rect(fill = "#f0f0f0", color = "#f0f0f0")) +
            xlim(weightRange[1],weightRange[2]) +
            labs(x = NULL, y = NULL)
        , height=100)
    
    output$lineSports <- renderPlot(
        athletes %>% 
            filter(Year>input$year_imput[1],
                   Year<input$year_imput[2],
                   country %in% input$country_input,
                   Age >= input$sideAge[1],
                   Age <= input$sideAge[2],
                   Weight >= input$sideWeight[1],
                   Weight <= input$sideWeight[2],
                   Height >= input$sideHeight[1],
                   Height <= input$sideHeight[2],
                   Medal_Value %in% input$sideMedals,
                   Medal!=0,
                   Sex %in% input$sideSex,
                   Sport %in% input$sport_input) %>% 
            ggplot(aes(Year, group=Sport, colour=Sport)) +
            geom_line(aes(fill=..count..), alpha=0.5, stat="bin", binwidth=4,size=2) +
            labs(x="Year",
                 y="Medals")+
            theme_classic()+
            theme(
            legend.text=element_text(size=9))
            
    )
    
    output$world_map <- renderPlotly({
        
        medals <- left_join(athletes,df,by=c("country"="COUNTRY"))
        
        medals <- medals %>% 
            group_by(country,CODE) %>% 
            filter(Year>input$year_imput[1],
                   Year<input$year_imput[2],
                   country %in% input$country_input,
                   Age >= input$sideAge[1],
                   Age <= input$sideAge[2],
                   Weight >= input$sideWeight[1],
                   Weight <= input$sideWeight[2],
                   Height >= input$sideHeight[1],
                   Height <= input$sideHeight[2],
                   Medal_Value %in% input$sideMedals,
                   Sex %in% input$sideSex,
                   Sport %in% input$sport_input) %>% 
            summarize(medal_count=sum(Medal_Count))
        
        l <- list(color = toRGB("grey"), width = 0.5)
        
        # specify map projection/options
        g <- list(
            showframe = FALSE,
            showcoastlines = FALSE,
            projection = list(type = 'Mercator')
        )
        
        
        p <- plot_geo(medals) %>%
            add_trace(
                z = ~medal_count, color = ~medal_count, colors = 'Spectral',
                text = ~country, locations = ~CODE, marker = list(line = l)
            ) %>%
            colorbar(title = 'Medal Count') %>%
            layout(
                geo = g
            )
    })
    
    output$word_cloud <- renderPlot({
        
        text=athletes %>% 
            filter(Year>input$year_imput[1],
                   Year<input$year_imput[2],
                   country %in% input$country_input,
                   Age >= input$sideAge[1],
                   Age <= input$sideAge[2],
                   Weight >= input$sideWeight[1],
                   Weight <= input$sideWeight[2],
                   Height >= input$sideHeight[1],
                   Height <= input$sideHeight[2],
                   Medal_Value %in% input$sideMedals,
                   Sex %in% input$sideSex,
                   Sport %in% input$sport_input) %>% 
                   select(Event)
        
        myCorpus = Corpus(VectorSource(text))
        myCorpus = tm_map(myCorpus, content_transformer(tolower))
        myCorpus = tm_map(myCorpus, removePunctuation)
        myCorpus = tm_map(myCorpus, removeNumbers)
        myCorpus = tm_map(myCorpus, removeWords,
                          c("mens","womens","metres"))
        
        myDTM = TermDocumentMatrix(myCorpus,
                                   control = list(minWordLength = 1))
        
        m = as.matrix(myDTM)
        
        v=sort(rowSums(m), decreasing = TRUE)
        
        wordcloud_rep <- repeatable(wordcloud)
        
        wordcloud_rep(names(v), v,scale=c(7,1.5),
                      size = 10, minRotation = -pi/2, maxRotation = -pi/2,
                      min.freq = 10, max.feq=3000,
                          colors=brewer.pal(8, "Spectral"))
            
    })
}

# Run the application 
shinyApp(ui = ui, server = server)