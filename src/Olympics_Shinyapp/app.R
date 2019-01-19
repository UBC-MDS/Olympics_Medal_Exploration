
library(shiny)
library(tidyverse)
library(maps)
library(plotly)

df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv')
athletes <- read.csv("data/df_athlete.csv") 
athletes <- athletes %>% 
    mutate(Gold=replace_na(Gold,0),
           Silver=replace_na(Silver,0),
           Bronze=replace_na(Bronze,0),
           Medal_Count = Gold + Silver + Bronze,
           Medal_Value = Gold*3 + Silver*2 + Bronze)

ageRange <- c(10,70)
weightRange <- c(25,150)
heightRange <- c(10,300)

test_df <-  athletes %>% 
    group_by(Sex) %>% 
    count()

ui <- fluidPage(

    titlePanel("Olympics Medal Explorer"),
    
    fluidPage(
        title="Olympics Medal Explorer",
        
        fluidRow(
            column(
                width=4,
                style = "background-color:#f0f0f0;",
                
                strong("Medals"),
                checkboxGroupInput("sideMedals", label = NULL, 
                              choices = list("Gold" = 3, "Silver" = 2, "Bronze" = 1, "No Medal" = 0),
                              selected = c(1,2,3)),
                
                strong("Sex"),
                plotOutput("barSex", height="8%"),
                checkboxGroupInput("sideSex", label = NULL, 
                                   choices = list("Female" = 1, "Male" = 2),
                                   selected = c(1,2)),
                
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
                
                plotlyOutput("world_map",height = 800),
                
                plotOutput("lineSports"),

                sliderInput("year_imput", label = h3("Input Time Period"),
                               min = 1896, max = 2016, value = c(2000, 2010),width="100%",sep=""
                ),



                selectizeInput(
                    'country_input', 'Select Countries',
                    choices = unique(athletes$country),
                    multiple = TRUE,
                    width="100%",
                    selected=unique(athletes$country)
                )
            )
        )
              
              
    )
    
)

server <- function(input, output) {

    observe(print(input$sideAge))
    
    output$sideMedals <- renderPrint({ input$sideMedals })
    
    output$sideAge <- renderPrint({ input$sideAge })
    
    output$sideWeight <- renderPrint({ input$sideWeight })
    
    output$barSex <- renderPlot(
        athletes %>% 
            filter(
                Age >= input$sideAge[1],
                Age <= input$sideAge[2],
                Weight >= input$sideWeight[1],
                Weight <= input$sideWeight[2],
                Height >= input$sideHeight[1],
                Height <= input$sideHeight[2],
                Medal_Value %in% input$sideMedals
            ) %>% 
            # group_by(Sex) %>% 
            # count() %>% 
            ggplot(aes(Sex)) + 
                geom_dotplot() +
                theme_minimal() +
                theme(axis.text.x=element_blank(),
                    axis.ticks.x=element_blank(),
                    axis.text.y=element_blank(),
                    axis.ticks.y=element_blank(),
                    plot.background = element_rect(fill = "#f0f0f0", color = "#f0f0f0")) +
                labs(x = NULL, y = NULL) +
                coord_flip() 
            , height=100)
    
    output$histAge <- renderPlot(
        athletes %>% 
            filter(
                Age >= input$sideAge[1],
                Age <= input$sideAge[2],
                Weight >= input$sideWeight[1],
                Weight <= input$sideWeight[2],
                Height >= input$sideHeight[1],
                Height <= input$sideHeight[2],
                Medal_Value %in% input$sideMedals
            ) %>% 
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
            filter(
                Age >= input$sideAge[1],
                Age <= input$sideAge[2],
                Weight >= input$sideWeight[1],
                Weight <= input$sideWeight[2],
                Height >= input$sideHeight[1],
                Height <= input$sideHeight[2],
                Medal_Value %in% input$sideMedals
            ) %>% 
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
            filter(
                Age >= input$sideAge[1],
                Age <= input$sideAge[2],
                Weight >= input$sideWeight[1],
                Weight <= input$sideWeight[2],
                Height >= input$sideHeight[1],
                Height <= input$sideHeight[2],
                Medal_Value %in% input$sideMedals
            ) %>% 
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
            filter(
                Age >= input$sideAge[1],
                Age <= input$sideAge[2],
                Weight >= input$sideWeight[1],
                Weight <= input$sideWeight[2],
                Height >= input$sideHeight[1],
                Height <= input$sideHeight[2],
                Medal_Value %in% input$sideMedals
            ) %>% 
            ggplot(aes(Year, group=Sport, colour=Sport)) +
                geom_line(aes(fill=..count..), alpha=0.5, stat="bin", binwidth=4) +
                theme(legend.position="none")
    )
    
    output$world_map <- renderPlotly({
        
        medals <- left_join(athletes,df,by=c("country"="COUNTRY"))
        
        medals <- medals %>% 
            group_by(country,CODE) %>% 
            filter(Year>input$year_imput[1],
                   Year<input$year_imput[2],
                   country %in% input$country_input) %>% 
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
                title = 'World medal history',
                geo = g
            )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
