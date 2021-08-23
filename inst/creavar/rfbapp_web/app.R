###
library(shiny)
library(dplyr)
library(shinycssloaders)
library(DT)
library(DBI)
library(RSQLite)
library(RMySQL)

print("111")

print(getwd())

########## SETUP of SQLITE DATABASE ######################################################

if(!file.exists("rfbapp.sqlite3")){

    conn <- dbConnect(
        RSQLite::SQLite(),
        "rfbapp.sqlite3"
    )
    
    DBI::dbExecute(conn, "DROP TABLE IF EXISTS vartable")
    
    create_rfbapp_query = "CREATE TABLE vartable (
                                  vid                             INTEGER PRIMARY KEY AUTOINCREMENT,
                                  trait                           TEXT,
                                  format                          TEXT,
                                  defaultValue                    TEXT,
                                  minimum                         TEXT,
                                  maximum                         TEXT,
                                  details                         TEXT,
                                  categories                      TEXT,
                                  isVisible                       TEXT,
                                  realPosition                    TEXT
                                )"
    
    #DBI::dbExecute(conn, "DROP TABLE IF EXISTS rfbapp")
    # Execute the query created above
    DBI::dbExecute(conn, create_rfbapp_query)
    dbDisconnect(conn)
    
    
}

###
vardata <- reactiveValues(data = data.frame())



print("paso 1")

################################################################################################


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel(
        h1("rfbapp web: Form Generator for FieldBookApp", align = 'center'),
        windowTitle = "rfbapp shiny web"
    ),

    # Sidebar with a slider input for number of bins 
    #sidebarLayout(
        #sidebarPanel(
            # sliderInput("bins",
            #             "Number of bins:",
            #             min = 1,
            #             max = 50,
            #             value = 30)
        #),

        # Show a plot of the generated distribution
        #mainPanel(
           
    fluidRow(
        column(
            width = 2,   
                
           actionButton("btn_add_trait", "Add variable",  
                        class = "btn-success",
                        style = "color: #fff;",
                        icon = icon('plus'),
                        width = '100%'
           )
           
        )
    ),
    fluidRow(
        column(
            width = 12,
            title = "Motor Trend Car Road Tests",
            br(),
            DT::DTOutput("tbl") %>%
                withSpinner(),
            tags$br(),
            tags$br()
        )
    ),
    
    
           
        #)
    #)
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    observeEvent(input$btn_add_trait, {
        showModal(modalDialog(
            title = "Form",
            "",
            selectInput("sel_var_type",label = "Type of varible",
                        choices = c("numeric","categorical", "percent", "photo",
                                    "audio","date","boolean","text",
                                    "counter","multicat","rust_rating","location"
                                    )
                        ),
            #condition for numeric variables
            conditionalPanel(
                condition = "input.sel_var_type == 'numeric'",
                    textInput("num_txt_var_name",label = "Variable abbreviation name",value = ""),
                    textInput("num_txt_details",label = "Details",placeholder = "Full name or description of the variable"),
                    numericInput("num_var_min",label = "Minimum value", value = 0),
                    numericInput("num_var_max",label = "Maximum value", value = 100)
                    
            ), 
            #condition for categorical variables
            conditionalPanel(
                condition = "input.sel_var_type == 'categorical'",
                textInput("cat_txt_var_name",label = "Variable abbreviation name", value = ""),
                textInput("cat_txt_details",label = "Details", placeholder = "Full name or description of the variable"),
                selectizeInput("cat_sel_values", "Insert categories", c(),
                               multiple = TRUE, options = list(
                                   'create' = TRUE,
                                   'persist' = FALSE)
                )
                
            ),
            #condition for percentage variables
            conditionalPanel(
                condition = "input.sel_var_type == 'percent'",
                textInput("pct_txt_var_name",label = "Variable abbreviation name", value = ""),
                textInput("pct_txt_details",label = "Details", placeholder = "Full name or description of the variable")
            ),  
             #
            #condition for photo variables
            conditionalPanel(
                condition = "input.sel_var_type == 'photo'",
                textInput("pho_txt_var_name",label = "Variable abbreviation name", value = ""),
                textInput("pho_txt_details",label = "Details", placeholder = "Full name or description of the variable")
            ),
            conditionalPanel(
                condition = "input.sel_var_type == 'audio'",
                textInput("aud_txt_var_name",label = "Variable abbreviation name", value = ""),
                textInput("aud_txt_details",label = "Details", placeholder = "Full name or description of the variable")
            ),   
            #condition for audio variables
            #condition for date variables
            conditionalPanel(
                condition = "input.sel_var_type == 'date'",
                textInput("date_txt_var_name",label = "Variable abbreviation name", value = ""),
                textInput("date_txt_details",label = "Details", placeholder = "Full name or description of the variable")
            ), 
            #condition for boolean variables
            conditionalPanel(
                condition = "input.sel_var_type == 'boolean'",
                textInput("bool_txt_var_name",label = "Variable abbreviation name", value = ""),
                textInput("bool_txt_details",label = "Details", placeholder = "Full name or description of the variable")
            ), 
            #condition for text data
            conditionalPanel(
                condition = "input.sel_var_type == 'text'",
                textInput("text_txt_var_name",label = "Variable abbreviation name", value = ""),
                textInput("text_txt_details",label = "Details", placeholder = "Full name or description of the variable")
            ), 
            #condition for counter variables
            conditionalPanel(
                condition = "input.sel_var_type == 'counter'",
                textInput("count_txt_var_name",label = "Variable abbreviation name", value = ""),
                textInput("count_txt_details",label = "Details", placeholder = "Full name or description of the variable")
            ),
            #condition for multi-categorical variables
            conditionalPanel(
                condition = "input.sel_var_type == 'multicat'",
                textInput("mulc_txt_var_name",label = "Variable abbreviation name", value = ""),
                textInput("mulc_txt_details",label = "Details", placeholder = "Full name or description of the variable"),
                selectizeInput("mulc_sel_values", "Insert categories", c(),
                               multiple = TRUE, options = list(
                                   'create' = TRUE,
                                   'persist' = FALSE)
                )
                
            ),
            #condition for rust_rating variables
            conditionalPanel(
                condition = "input.sel_var_type == 'rust_rating'",
                textInput("rust_txt_var_name",label = "Variable abbreviation name", value = ""),
                textInput("rust_txt_details",label = "Details", placeholder = "Full name or description of the variable")
            ),
            

            #condition for location variables
            conditionalPanel(
                condition = "input.sel_var_type == 'location'",
                textInput("local_txt_var_name",label = "Variable abbreviation name", value = ""),
                textInput("local_txt_details",label = "Details", placeholder = "Full name or description of the variable")
            ), 
            size = 'm',
            footer = list(
                modalButton('Cancel'),
                actionButton(
                    'btn_submit',
                    'Submit',
                    class = "btn btn-primary",
                    style = "color: white"
                )
            )
        ))
    })
    
    ### reactive data
    
     rfbapp_form <- reactive({
    #     
        #type of var
        #input$sel_var_type

        if(type=="numeric"){
           out <-  create_fbapp_template(variable=input$num_txt_var_name,
                                  type = input$sel_var_type,
                                  defaultValue=10,
                                  minimum = as.numeric(input$num_var_min),
                                  maximum = as.numeric(input$num_var_max),
                                  details = input$num_txt_details,
                                  isVisible="",
                                  realPosition="")
        }
        if(type == "categorical"){
          out <-  create_fbapp_template(
                         variable=input$cat_txt_var_name ,
                         type = input$sel_var_type,
                         defaultValue="",
                         categories=input$cat_sel_values,
                         details= input$cat_txt_details,
                         isVisible="",
                         realPosition=""
                        )
        }
    #     
    #     
    #     
    #     ##categorical
    #     input$cat_txt_var_name 
    #     input$cat_txt_details 
    #     
    #     
    #     ##percentage
    #     input$pct_txt_var_name 
    #     input$pct_txt_details
    #     
    #     #audio
    #     input$aud_txt_var_name 
    #     input$aud_txt_details
    #     
    #     #photo
    #     input$pho_txt_var_name 
    #     input$pho_txt_details
    #     
    #     #date
    #     input$date_txt_var_name 
    #     input$date_txt_details
    #     
    #     #bool
    #     input$bool_txt_var_name 
    #     input$bool_txt_details
    #     
    #     #text
    #     input$text_txt_var_name 
    #     input$text_txt_details
    #     
    #     #count
    #     input$count_txt_var_name 
    #     input$count_txt_details
    #     
    #     #multicat
    #     input$mulc_txt_var_name 
    #     input$mulc_txt_details
    #     
    #     #rust score
    #     input$rust_txt_var_name 
    #     input$rust_txt_details    
    #     
    #     #location
    #     input$local_txt_var_name 
    #     input$local_txt_details
    #     
    #     
    #     #table
    #     out <- data.frame(
    #         trait = as.character(variable), 
    #         format = as.character(type), 
    #         defaultValue=as.character(defaultValue), 
    #         minimum = as.character(minimum), 
    #         maximum = as.character(maximum), 
    #         details = as.character(details), 
    #         categories = as.character(categories), 
    #         isVisible = as.character(isVisible), 
    #         realPosition =as.character(realPosition)
    #     )
    #     
         out
     })#end of reactive
    
    observeEvent(input$btn_submit ,{
        
        
        conn <- dbConnect(
            RSQLite::SQLite(),
            "rfbapp.sqlite3"
        )
        
        # dbExecute(conn, "INSERT INTO vartable (model, mpg, cyl, disp, hp, drat, wt, qsec, vs,am, gear, carb)
        #                  VALUES ('corvet',160.0,110,3.90,2.620,16.46,0,1,'res1', 'res2', 12.2,32.12)")
        # trait                           TEXT,
        #format                          TEXT,
        
        insert_values <- paste0(
                                c(as.character(input$num_txt_var_name),as.character(input$sel_var_type), 
                                "", as.character(input$num_var_min), as.character(input$num_var_max),
                                as.character(input$num_txt_details), "ll", "ll", "ll"), 
                                collapse = "','"
                                )
        print(insert_values)
        insert_values <- paste0("VALUES ('", insert_values, "')")                                    
        insert_query  <- paste0("INSERT INTO vartable (trait, format, defaultValue, minimum,                         
                                       maximum, details, categories, isVisible, realPosition)",  
                                insert_values
                               )
        print(insert_query)
        
        dbExecute(conn, insert_query)
        
        conn <- dbConnect(RSQLite::SQLite(), "rfbapp.sqlite3")
        out <- dbGetQuery(conn, 'SELECT * FROM vartable')
        if(is.null(out)){
            vardata$records <- data.frame()
        } else if(nrow(out)==0){
            vardata$records <- data.frame()
        } else {
            vardata$records <- out
        }
        
        
        #print(a1)
        dbDisconnect(conn)
        
    })
    
    output$tbl <- DT::renderDT(
        #conn <- dbConnect(RSQLite::SQLite(), "inst/creavar/rfbapp_web/temp.sqlite3")
        #verificamos los datos de la tabla
        vardata$records, options = list(lengthChange = FALSE, selection = 'single')
    )
    
}

# Run the application 
shinyApp(ui = ui, server = server)
