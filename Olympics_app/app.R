library(rsconnect)
library(shiny)
library(tidyverse)
library(maps)
library(plotly)
library(shinyWidgets)
library(tm)
library(wordcloud)

c1 <- "#f0f0f0"  # sidebar and top bar colour
c2 <- "#56B4E9"  # colour for histograms on sliders
c3 <- "PuBu"     # colour scale for map and wordcloud

df <- read.csv('2014_world_gdp_with_codes.csv')
athletes <- read.csv("df_athlete.csv",stringsAsFactors = FALSE)  %>%
    mutate(Medal=replace_na(Medal,0),
           Gold=replace_na(Gold,0),
           Silver=replace_na(Silver,0),
           Bronze=replace_na(Bronze,0),
           Medal_Count = Gold + Silver + Bronze,
           Medal_Value = Gold*3 + Silver*2 + Bronze,
           Sex=if_else(Sex=="F","1","2")) %>%
    select(-c(City)) %>%
    filter(Medal_Count > 0) %>%
    drop_na()

ageRange <- c(min(athletes$Age),max(athletes$Age))
weightRange <- c(min(athletes$Weight),max(athletes$Weight))
heightRange <- c(min(athletes$Height),max(athletes$Height))
yearRange <- c(min(athletes$Year),max(athletes$Year))
countries <- sort(unique(athletes$country))
sports <- sort(unique(athletes$Sport))

ui <- fluidPage(

    # this first fluidRow is the top bar
    fluidRow(
        style = paste("background-color:",c1),

        column(width = 3,
           h3("Olympic Medal Explorer"),
           img(src="rings.png", width="100%")
        ),
        column(width = 1,
            strong("Medals"),
            checkboxGroupInput("inpMedals", label = NULL,
                               choices = list("Gold" = 3, "Silver" = 2, "Bronze" = 1),
                               selected = c(1,2,3)),
            strong("Sex"),
            checkboxGroupInput("inpSex", label = NULL,
                               choices = list("Female" = 1, "Male" = 2),
                               selected = c(1,2))
        ),
        column(width = 2,
            strong("Age"),
            plotOutput("histAge", height="8%"),
            sliderInput("inpAge", label = NULL, width="100%",
                        min = ageRange[1], max = ageRange[2], value = ageRange
            )
        ),
        column(width = 2,
               strong("Weight (kg)"),
               plotOutput("histWeight", height="8%"),
               sliderInput("inpWeight", label=NULL, width="100%",
                           min = weightRange[1], max = weightRange[2], value = weightRange
               )
        ),
        column(width = 2,
               strong("Height (cm)"),
               plotOutput("histHeight", height="8%"),
               sliderInput("inpHeight", label=NULL, width="100%",
                           min = heightRange[1], max = heightRange[2], value = heightRange
               )
        )
    ),

    # this fluidRow contains the left sidebar and main content
    fluidRow(
        column(width=3, style=paste("background-color:",c1),

            pickerInput("inpCountry","Country",
                        choices=countries,
                        selected = countries,
                        options = list(`actions-box` = TRUE),multiple = T),

            pickerInput("inpSport","Sport",
                        choices = sports,
                        selected = sports,
                        options = list(`actions-box` = TRUE),multiple = T),

            strong("Timeline"),
            plotOutput("histYear", height="8%"),
            sliderInput("inpYear", label=NULL,
                        min=yearRange[1], max=yearRange[2], value=yearRange,width="100%",sep="",animate=TRUE
            )
        ),
        column(width=8,
            tabsetPanel(
                tabPanel("Map", plotlyOutput("world_map",height = 500)),
                tabPanel("Compare Top 5", plotOutput("lineSports",height = 500)),
                tabPanel("Winningest Events", plotOutput("word_cloud",height = 500))
            )
        )
    )
)

server <- function(input, output, session) {

    # this is the reactive object which feeds all the plots
    df_filtered <- reactive({
        athletes %>%
            filter(Year>input$inpYear[1],
               Year<input$inpYear[2],
               country %in% input$inpCountry,
               Age >= input$inpAge[1],
               Age <= input$inpAge[2],
               Weight >= input$inpWeight[1],
               Weight <= input$inpWeight[2],
               Height >= input$inpHeight[1],
               Height <= input$inpHeight[2],
               Medal_Value %in% input$inpMedals,
               Sex %in% input$inpSex,
               Sport %in% input$inpSport)
    })
    df_top_countries <- reactive({
        df_filtered() %>%
            group_by(country) %>%
            tally() %>%
            top_n(5)
    })
    output$histAge <- renderPlot(height=100,
        ggplot(df_filtered(), aes(Age)) +
            geom_histogram(binwidth=2, fill=c2) +
            theme_minimal() +
            theme(axis.text.x=element_blank(),
                  axis.ticks.x=element_blank(),
                  axis.text.y=element_blank(),
                  axis.ticks.y=element_blank(),
                  plot.background = element_rect(fill = c1, color = c1)) +
            xlim(ageRange[1],ageRange[2]) +
            labs(x = NULL, y = NULL)
    )
    output$histWeight <- renderPlot(height=100,
        ggplot(df_filtered(), aes(Weight)) +
            geom_histogram(binwidth=5, fill=c2) +
            theme_minimal() +
            theme(axis.text.x=element_blank(),
                  axis.ticks.x=element_blank(),
                  axis.text.y=element_blank(),
                  axis.ticks.y=element_blank(),
                  plot.background = element_rect(fill = c1, color = c1)) +
            xlim(weightRange[1],weightRange[2]) +
            labs(x = NULL, y = NULL)
    )
    output$histHeight <- renderPlot(height=100,
        ggplot(df_filtered(), aes(Height)) +
            geom_histogram(binwidth=5, fill=c2) +
            theme_minimal() +
            theme(axis.text.x=element_blank(),
                  axis.ticks.x=element_blank(),
                  axis.text.y=element_blank(),
                  axis.ticks.y=element_blank(),
                  plot.background = element_rect(fill = c1, color = c1)) +
            xlim(heightRange[1],heightRange[2]) +
            labs(x = NULL, y = NULL)
    )

    output$histYear <- renderPlot(height=100,
        ggplot(df_filtered(), aes(Year)) +
            geom_histogram(binwidth=4, fill=c2) +
            theme_minimal() +
            theme(axis.text.x=element_blank(),
                  axis.ticks.x=element_blank(),
                  axis.text.y=element_blank(),
                  axis.ticks.y=element_blank(),
                  plot.background = element_rect(fill = c1, color = c1)) +
            xlim(yearRange[1],yearRange[2]) +
            labs(x = NULL, y = NULL)
    )

    output$lineSports <- renderPlot(
        df_filtered() %>%
            group_by(Sport) %>%
            tally() %>%
            top_n(5) %>%
            inner_join(df_filtered()) %>%
            inner_join(df_top_countries(),
                       by=c("country" = "country")) %>%
            ggplot(aes(Year)) +
                geom_bar(fill=c2, width=4) +
                labs(x="Year", y="Medals") +
                theme_light() +
                theme(legend.position="none") +
                scale_x_discrete() +
                xlim(yearRange) +
                facet_grid(rows = vars(Sport), cols = vars(country))
    )

    output$world_map <- renderPlotly({

        medals <- left_join(df_filtered(), df, by=c("country"="COUNTRY")) %>%
            group_by(country,CODE) %>%
            summarize(medal_count=sum(Medal_Count))

        l <- list(color = toRGB("grey"), width = 0.5)
        g <- list(
            showframe = FALSE,
            showcoastlines = TRUE,
            projection = list(type = 'Mercator')
        )
        p <- plot_geo(medals) %>%
            add_trace(
                z = ~medal_count, color = ~medal_count, colors = c3,
                text = ~country, locations = ~CODE, marker = list(line = l)
            ) %>%
            colorbar(title = 'Medal Count') %>%
            layout(geo = g)
    })

    output$word_cloud <- renderPlot({

        text = df_filtered() %>%
            select(Event)

        myCorpus = Corpus(VectorSource(text))
        myCorpus = tm_map(myCorpus, content_transformer(tolower))
        myCorpus = tm_map(myCorpus, removePunctuation)
        myCorpus = tm_map(myCorpus, removeNumbers)
        myCorpus = tm_map(myCorpus, removeWords, c("mens","womens","metres"))

        myDTM = TermDocumentMatrix(myCorpus, control = list(minWordLength = 1))

        m = as.matrix(myDTM)
        v=sort(rowSums(m), decreasing = TRUE)
        wordcloud_rep <- repeatable(wordcloud)
        wordcloud_rep(names(v), v,scale=c(5,1),
                      size = 10, minRotation = -pi/2, maxRotation = -pi/2,
                      max.words=30, colors=brewer.pal(8, c3)
        )
    })
}

# Run the application
shinyApp(ui = ui, server = server)
