###
library(shiny)
library(dplyr)
library(shinycssloaders)
library(DT)
library(DBI)
library(RSQLite)
library(RMySQL)
library(rfbapp)
library(shinyFeedback)
library(shinyjs)
library(shinyvalidate)


source("helper.R")

########## SETUP of SQLITE DATABASE ######################################################

#if(!file.exists("rfbapp.sqlite3")){
conn <- dbConnect(
  RSQLite::SQLite(),
  "rfbapp.sqlite3"
)

DBI::dbExecute(conn, "DROP TABLE IF EXISTS tblfbapp")
DBI::dbExecute(conn, "DROP TABLE IF EXISTS tblview")

create_rfbapp_query = "CREATE TABLE tblfbapp (
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

create_tblview_query = "CREATE TABLE tblview (
                                  vid                             INTEGER PRIMARY KEY AUTOINCREMENT,
                                  trait                           TEXT,
                                  format                          TEXT,
                                  defaultValue                    TEXT,
                                  minimum                         TEXT,
                                  maximum                         TEXT,
                                  details                         TEXT,
                                  categories                      TEXT,
                                  isVisible                       TEXT,
                                  realPosition                    TEXT,
                                  Nevaluation                     INTEGER
                                )"


#DBI::dbExecute(conn, "DROP TABLE IF EXISTS rfbapp")
# Execute the query created above
DBI::dbExecute(conn, create_rfbapp_query)
DBI::dbExecute(conn, create_tblview_query)
dbDisconnect(conn)
#}

###
vardata <- reactiveValues(data = data.frame())



print("paso 1")

################################################################################################


# Define UI for application that draws a histogram
ui <- fluidPage(
  
  useShinyFeedback(),
  shinyjs::useShinyjs(),
  # Application title
  titlePanel(
    h1("rfbapp web: Form Generator for FieldBookApp", align = 'center'),
    windowTitle = "rfbapp shiny web"
  ),
  
  fluidRow(
    column(
      width = 2,   
      
      actionButton("btn_add_vars", "Add variable",  
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
      tags$br(),
      downloadButton("btn_export_formvars", "Export form")
    )
  ),
  
  
  
  #)
  #)
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  
  
  # Validator of Inputs -------------------------------------------------------------
  
  iv <- InputValidator$new()
  # Add validation rules
  iv$add_rule("num_txt_var_name", ~ if (nchar(.) < 3) "Require At least 3 characters") #sv_required(message = "Required. At least 3 characters"))
  iv$add_rule("num_txt_details",  ~ if (nchar(.) < 3) "Require At least 3 characters")
  iv$add_rule("num_txt_details", sv_required(message = "Require At least 3 characters"))
  iv$add_rule("num_var_min", ~ if (is.na(.)) "Insert a number") #shinyvalidate::sv_numeric())
  iv$add_rule("num_var_max", ~ if (is.na(.)) "Insert a number") #shinyvalidate::sv_numeric())
  #categorical validations
  iv$add_rule("cat_txt_var_name", ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  iv$add_rule("cat_txt_details", ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  iv$add_rule("cat_sel_values", ~ if (length(.) < 2) "Require At least 2 categories")#sv_required(message = "Required. At least 2 categories"))
  #percentage validations
  iv$add_rule("pct_txt_var_name", ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  iv$add_rule("pct_txt_details",  ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  #audio validations
  iv$add_rule("aud_txt_var_name", ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  iv$add_rule("aud_txt_details",  ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  #photo validations
  iv$add_rule("pho_txt_var_name", ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  iv$add_rule("pho_txt_details",  ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  #date valiations
  iv$add_rule("date_txt_var_name", ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  iv$add_rule("date_txt_details",  ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  #bool validations
  iv$add_rule("bool_txt_var_name", ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  iv$add_rule("bool_txt_details",  ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  #text validations
  iv$add_rule("text_txt_var_name", ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  iv$add_rule("text_txt_details",  ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  #count validations
  iv$add_rule("count_txt_var_name", ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  iv$add_rule("count_txt_details",  ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  #multicategorical validations
  iv$add_rule("mulc_txt_var_name", ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  iv$add_rule("mulc_txt_details",  ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  iv$add_rule("mulc_sel_values",   ~ if (length(.) < 2) "Require At least 2 categories")#sv_required(message = "Required. At least 2 categories"))
  #rust score validations
  iv$add_rule("rust_txt_var_name", ~ if (nchar(.) < 3) "Require At least 3 characters") #sv_required(message = "Required. At least 3 characters"))
  iv$add_rule("rust_txt_details",  ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  #locations
  iv$add_rule("local_txt_var_name", ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  iv$add_rule("local_txt_details",  ~ if (nchar(.) < 3) "Require At least 3 characters")#sv_required(message = "Required. At least 3 characters"))
  
  # Start displaying errors in the UI
  iv$enable()
  
  # Form Modal Dialog -------------------------------------------------------
  
  observeEvent(input$btn_add_vars, {
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
      numericInput("neval_time",label = "Evaluations in time",value = 1,min = 1),
      
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
  
  
  # Reactive data - tblrecords ----------------------------------------------
  
  tblrecords <- reactive({
    
    type <- as.character(input$sel_var_type)
    
    if(type=="numeric"){
      
      out <-  data.frame(
        variable=input$num_txt_var_name,
        type = input$sel_var_type,
        defaultValue="",
        minimum = as.numeric(input$num_var_min),
        maximum = as.numeric(input$num_var_max),
        categories = "",
        details = input$num_txt_details,
        isVisible="",
        realPosition="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type == "categorical"){
      
      out <- data.frame(
        variable=input$cat_txt_var_name ,
        type = input$sel_var_type,
        defaultValue="",
        minimum = "",
        maximum = "",
        categories=input$cat_sel_values,
        details= input$cat_txt_details,
        isVisible="",
        realPosition="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type == "percent"){
      
      out <- data.frame(
        variable=input$pct_txt_var_name ,
        type = input$sel_var_type,
        defaultValue="",
        minimum = "",
        maximum = "",
        categories="",
        details= input$pct_txt_details,
        isVisible="",
        realPosition="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type == "audio"){
      
      out <-  data.frame(
        variable = input$aud_txt_var_name ,
        type = input$sel_var_type,
        defaultValue ="",
        minimum = "",
        maximum = "",
        categories ="",
        details = input$aud_txt_details,
        isVisible ="",
        realPosition ="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type =="photo"){
      
      out <-  data.frame(
        variable = input$pho_txt_var_name ,
        type = input$sel_var_type,
        defaultValue ="",
        minimum = "",
        maximum = "",
        categories ="",
        details = input$pho_txt_details,
        isVisible ="",
        realPosition ="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type == "date") {
      
      out <-  data.frame(
        variable = input$date_txt_var_name ,
        type = input$sel_var_type,
        defaultValue ="",
        minimum = "",
        maximum = "",
        categories ="",
        details = input$date_txt_details,
        isVisible ="",
        realPosition ="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type == "bool"){
      
      out <-  data.frame(
        variable = input$bool_txt_var_name ,
        type = input$sel_var_type,
        defaultValue ="",
        minimum = "",
        maximum = "",
        categories ="",
        details = input$bool_txt_details,
        isVisible ="",
        realPosition ="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type =="text"){
      
      out <-  data.frame(
        variable = input$text_txt_var_name ,
        type = input$sel_var_type,
        defaultValue ="",
        minimum = "",
        maximum = "",
        categories ="",
        details = input$text_txt_details,
        isVisible ="",
        realPosition ="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type == "counter"){
      
      out <-  data.frame(
        variable = input$count_txt_var_name ,
        type = input$sel_var_type,
        defaultValue ="",
        minimum = "",
        maximum = "",
        categories ="",
        details = input$count_txt_details,
        isVisible ="",
        realPosition ="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type == "multicat"){
      
      out <-  data.frame(
        variable = as.character(input$mulc_txt_var_name),
        type = as.character(input$sel_var_type),
        defaultValue = "",
        minimum = "",
        maximum = "",
        categories = input$mulc_sel_values,
        details = input$mulc_txt_details,
        isVisible = "",
        realPosition = "",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type == "rust_rating"){
      
      out <-  data.frame(
        variable = input$rust_txt_var_name ,
        type = input$sel_var_type,
        defaultValue ="",
        minimum = "",
        maximum = "",
        categories ="",
        details = input$rust_txt_details,
        isVisible ="",
        realPosition ="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type == "location"){
      
      out <-  data.frame(
        variable = input$local_txt_var_name,
        type = input$sel_var_type,
        defaultValue ="",
        minimum = "",
        maximum = "",
        categories ="",
        details = input$local_txt_details,
        isVisible ="",
        realPosition ="",
        ntime = as.numeric(input$neval_time)
      )
    } 
    
    out
  })  
  
  
  
  # Reactive data- User's forms ---------------------------------------------
  
  rfbapp_form <- reactive({
    #     
    #type of var
    type <- as.character(input$sel_var_type)
    
    if(type=="numeric"){
      
      out <-  create_fbapp_template(
        variable=input$num_txt_var_name,
        type = input$sel_var_type,
        defaultValue=10,
        minimum = as.numeric(input$num_var_min),
        maximum = as.numeric(input$num_var_max),
        details = input$num_txt_details,
        isVisible="",
        realPosition="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type == "categorical"){
      
      out <-  create_fbapp_template(
        variable=input$cat_txt_var_name ,
        type = input$sel_var_type,
        defaultValue="",
        categories=input$cat_sel_values,
        details= input$cat_txt_details,
        isVisible="",
        realPosition="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type == "percent"){
      
      out <-  create_fbapp_template(
        variable=input$pct_txt_var_name ,
        type = input$sel_var_type,
        defaultValue="",
        categories="",
        details= input$pct_txt_details,
        isVisible="",
        realPosition="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type == "audio"){
      
      out <-  create_fbapp_template(
        variable = input$aud_txt_var_name ,
        type = input$sel_var_type,
        defaultValue ="",
        categories ="",
        details = input$aud_txt_details,
        isVisible ="",
        realPosition ="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type =="photo"){
      
      out <-  create_fbapp_template(
        variable = input$pho_txt_var_name ,
        type = input$sel_var_type,
        defaultValue ="",
        categories ="",
        details = input$pho_txt_details,
        isVisible ="",
        realPosition ="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type == "date") {
      
      out <-  create_fbapp_template(
        variable = input$date_txt_var_name ,
        type = input$sel_var_type,
        defaultValue ="",
        categories ="",
        details = input$date_txt_details,
        isVisible ="",
        realPosition ="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type == "bool"){
      
      out <-  create_fbapp_template(
        variable = input$bool_txt_var_name ,
        type = input$sel_var_type,
        defaultValue ="",
        categories ="",
        details = input$bool_txt_details,
        isVisible ="",
        realPosition ="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type =="text"){
      
      out <-  create_fbapp_template(
        variable = input$text_txt_var_name ,
        type = input$sel_var_type,
        defaultValue ="",
        categories ="",
        details = input$text_txt_details,
        isVisible ="",
        realPosition ="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type == "counter"){
      
      out <-  create_fbapp_template(
        variable = input$count_txt_var_name ,
        type = input$sel_var_type,
        defaultValue ="",
        categories ="",
        details = input$count_txt_details,
        isVisible ="",
        realPosition ="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type == "multicat"){
      
      out <-  create_fbapp_template(
        variable = as.character(input$mulc_txt_var_name),
        type = as.character(input$sel_var_type),
        defaultValue = "",
        categories = input$mulc_sel_values,
        details = input$mulc_txt_details,
        isVisible = "",
        realPosition = "",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type == "rust_rating"){
      
      out <-  create_fbapp_template(
        variable = input$rust_txt_var_name ,
        type = input$sel_var_type,
        defaultValue ="",
        categories ="",
        details = input$rust_txt_details,
        isVisible ="",
        realPosition ="",
        ntime = as.numeric(input$neval_time)
      )
      
    } else if(type == "location"){
      
      out <-  create_fbapp_template(
        variable = input$local_txt_var_name,
        type = input$sel_var_type,
        defaultValue ="",
        categories ="",
        details = input$local_txt_details,
        isVisible ="",
        realPosition ="",
        ntime = as.numeric(input$neval_time)
      )
    } 
    
    out
  })#end of reactive
  
  
  AllInputs <- reactive({
    x <- reactiveValuesToList(input)
  })
  
  
  # Reactive check value ----------------------------------------------------
  
  cond <- reactive({ 
    out <- check_input_condition(input$sel_var_type, AllInputs())
    out
  })
  
  
  # Submit data -------------------------------------------------------------
  
  
  
  
  observeEvent(input$btn_submit ,{
    
    cond <- cond() 
    abbvar <- get_abbvar(input$sel_var_type, AllInputs())
    
    if(isFALSE(cond)){ 
      msg <- "Please correct the errors in the form and try again" 
      showNotification(msg,type = "error")
      
    } else {
      
      conn <- dbConnect(
        RSQLite::SQLite(),
        "rfbapp.sqlite3"
      )
      out <- dbGetQuery(conn, 'SELECT * FROM tblfbapp')
      
      res <- check_form(out)$cond
      msg <- check_form(out)$msg
      
      
      if(is.null(out)){
        showNotification(msg, type = "error",duration = 3) 
        vardata$records <- data.frame()
        
      } else if(is.element(abbvar, out$trait)){
        showNotification("The variable abbreviation is repeated. Change for other", type = "error",duration = 3) 
        vardata$records <- out
        
      } else {
        dbWriteTable(conn, "tblfbapp", rfbapp_form(), append=TRUE) 
        out <- dbGetQuery(conn, 'SELECT * FROM tblfbapp')
        shiny::showNotification(msg, type = "message", duration = 3) 
        
        vardata$records <- out
      }
      
      dbDisconnect(conn)
    }
  })
  
  
  # DT table results --------------------------------------------------------
  
  output$tbl <- DT::renderDT(
    #verificamos los datos de la tabla
    vardata$records, options = list(lengthChange = FALSE, selection = 'single')
  )
  
  # Button exports variable's form ------------------------------------------
  
  output$btn_export_formvars <- downloadHandler(
    # For PDF output, change this to "report.pdf"
    filename =  function() {
      paste0("fbapp_form",".trt")
    },
    content = function(file) {
      conn <- dbConnect(
        RSQLite::SQLite(),
        "rfbapp.sqlite3"
      )
      out <- dbGetQuery(conn, 'SELECT * FROM tblfbapp')
      class(out) <- c("data.frame","rfbapp")
      dbDisconnect(conn)
      write_rfbapp(out, file)
    })
  
}

# Run the application 
shinyApp(ui = ui, server = server)


##TODO 4: remover duplicados en trait abbreviation name
##TODO 5: agregar eval en el tiempo

#https://mastering-shiny.org/action-transfer.html

####### referencias
##1. https://stackoverflow.com/questions/50251813/how-to-update-datatable-in-shiny-with-button
##2. https://stackoverflow.com/questions/48719266/how-to-ensure-unique-ids-when-inserting-into-sqlite-database-in-r-shiny
##3. https://stackoverflow.com/questions/58610472/how-to-insert-values-to-the-sqlite-database-from-r-data


