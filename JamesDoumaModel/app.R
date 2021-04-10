library(shiny)
library(shinydashboard)
library(shinydashboardPlus)


ui = dashboardPage(
    options = list(sidebarExpandOnHover = TRUE),
    header = dashboardHeader(),
    sidebar = dashboardSidebar(minified = TRUE, collapsed = TRUE),
    body = dashboardBody(
        fluidRow(
            column(width = 8,
       valueBoxOutput("cars_in_us"),
       valueBoxOutput("cars_with_FSD"),
       valueBoxOutput("drivers_using_beta"),
       valueBoxOutput("miles_driven_fsd")
        )
        )
    ),
    controlbar = dashboardControlbar(
        skin = "dark",
        controlbarMenu(
            id = "menu",
            controlbarItem(
                "Tab 1",
                "Welcome to tab 1",
                numericInput(
                    "fleet",
                    "Size of the Tesla Fleet (Millions):",
                    min = 1, max = 3, value = 1, step = .1
                ),
                sliderInput(
                    "us_fraction",
                    "Fraction of Fleet in US :",
                    min = 0, max = 1, value = .5
                ),
                sliderInput(
                    "fsd_take_rate",
                    "FSD Take Rate :",
                    min = 0, max = 1, value = .5
                ),
                sliderInput(
                    "fsd_usage",
                    "Fraction with FSD who will use FSD :",
                    min = 0, max = 1, value = 1
                ),
                numericInput(
                    "avg_miles_driven",
                    "Average Miles Driven Per Car (thousands):",
                    min = 5, max = 25, value = 10, step = .5
                ),
                sliderInput(
                    "fsd_engagement",
                    "Fraction of miles where FSD is Engaged:",
                    min = 0, max = 1, value = 1
                ),
            ),
            controlbarItem(
                "Tab 2",
                "Welcome to tab 2"
            )
        )
    ),
    title = "DashboardPage"
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
   
    num_in_Us <- reactive({
        input$fleet * input$us_fraction
    }) 
    
    num_cars_fsd <- reactive({
        num_in_Us() * input$fsd_take_rate
    })
    
    owners_with_beta <- reactive({
        num_cars_fsd() * input$fsd_usage
    })
    
    num_miles_on_beta <- reactive({
        owners_with_beta() * input$avg_miles_driven * input$fsd_engagement
    })

    output$cars_in_us <- renderValueBox({
        valueBox(
            value = num_in_Us(),
            subtitle ="Number in Millions",
            icon = icon("car")
        )
    })
    
    output$cars_with_FSD <- renderValueBox({
        valueBox(
            value = num_cars_fsd(),
            subtitle = "Cars Eligable for Beta (Millions)"
            
        )
    })
    
    output$drivers_using_beta <- renderValueBox({
        valueBox(
            value = owners_with_beta(),
            subtitle = "Cars with Beta Downloaded (Millions)"
            
        )
    })
    
    output$miles_driven_fsd <- renderValueBox({
        valueBox(
            value = num_miles_on_beta(),
            subtitle = "Number of Miles on FSD (Billions)" 
            
        )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
