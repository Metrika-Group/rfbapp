## Prototyping
## https://docs.google.com/spreadsheets/d/1FthwUVFJeokvDWqMm1OuC3N8nCtUNGdVlq9Nob05jWM/edit?usp=drive_web&ouid=112193923761283870355
# format <- list(
#                numeric="numeric",
#                categorical = "categorical",
#                percent = "percent",
#                date = "date",
#                boolean = "boolean",
#                text ="text",
#                photo = "photo",
#                counter="counter",
#                multicat="multicat"
#                score = "score",
#                audio = "audio",
#                location = "location"
#      )


fbapp_attributes <- function(variable="",
                             type=c("numeric", "categorical","percent",
                                    "date","boolean","text",
                                    "photo", "counter","multicat", 
                                    "rust_rating", "audio", "location"),
                             defaultValue="",
                             minimum=0, maximum= 1,
                             details="", categories="",
                             isVisible="", realPosition=1){
  
  type <- match.arg(type)
  variable_type <- c("numeric", "categorical","percent",
                     "date","boolean","text",
                     "photo", "counter","multicat", 
                     "rust_rating", "audio", "location"
                    )
  
  ######## check variable name and type
  
  if(type==""){
    print("The lower limit is missing / inserte un limite inferior")
    return()
  }
  
  if(is.null(variable)){
    print("The variable name is missing / Insert el nombre de la variable")
    return()
  }
  
  if(variable==""){
    print("The variable name is missing / Insert el nombre de la variable")
    return()
  }
  
  if(is.null(type)){
    print("The variable type is missing / Inserte el tipo de varible")
    return()
    
  } else if(!is.element(el = type, set = variable_type)){
    print("The variable type is not available / El tipo de variable no esta disponible")
    return()
  }
  
  ######### type: numeric 
  
  if(type=="numeric" && is.null(minimum)){
    print("The lower limit is missing / inserte un limite inferior")
    return()
  }
  
  if(type=="numeric" && is.null(maximum)){
    print("The upper limit is missing / inserte un limite superior")
    return()
  }

  ######### check type: categories
    
  if(type=="categorical" && is.null(categories)){
    print("Categories are missing / inserte las categorias")
    return()
  }
  
  if(type=="categorical" && categories==""){
    print("Categories are missing / inserte las categorias")
    return()
  }
  
  if(type=="categorical" && length(categories)<2){
    print("At least two categories are required / Se requieren como minimo 2 categorias")
    return()
  }
  
  ######### check v.type : multi-categories
  
  if(type=="multicat" && is.null(categories)){
    print("Categories are missing / inserte las categorias")
    return()
  }
  
  if(type=="multicat" && categories==""){
    print("Categories are missing / inserte las categorias")
    return()
  }
  
  if(type=="multicat" && length(categories)<2){
    print("At least two categories are required / Se requieren como minimo 2 categorias")
    return()
  } else {
    categories <- paste0(categories, collapse = "/")
  }
  
  ####### check details attribute
  
  if(is.null(defaultValue)){
    defaultValue <- ""
  }
  
  if(is.null(details)){
      details <- ""
  } 
  
  out <- data.frame(
                    trait = as.character(variable), format = as.character(type), defaultValue=as.character(defaultValue), 
                    minimum = as.character(minimum), maximum = as.character(maximum), details = as.character(details), 
                    categories = as.character(categories), isVisible = as.character(isVisible), realPosition =as.character(realPosition)
                    )
  
  return(out)
  
}

#' Create Field Book App template
#' 
#' @title Create templates to import on mobiles devices with Field Book App
#' @param variable character. variable name
#' @param type character. type of variables. There are 12 types of variables \code{numeric}
#' @param defaultValue numeric or character. Value to display on the interface by default.
#' @param minimum numeric. lower limit value for numerical traits. Only available for type \code{numeric} variables.
#' @param maximum numeric. upper limit value for numerical traits. Only available for type \code{numeric} variables.
#' @param details character. Provide details about the variable. For example variable's full name or variable's units
#' @param categories A character vector of categories of the variable. Only available for type \code{categorical}
#' @param isVisible boolean. If \code{true}, the variables should be visible in the interface, otherwise is \code{false}.
#' @param realPosition integer. Position of variable in the table 
#' @param num_eval integer. Number of evaluation per variable
#' @author Omar Benites
#' @export
create_fbapp_template <- function(variable="",
                                  type = c("numeric", "categorical", "percent",
                                           "date","boolean","text","photo",
                                           "counter","multicat", "score","rust_rating",
                                           "audio","location"
                                           ),
                                  defaultValue="",
                                  minimum=0,
                                  maximum=100,
                                  details="",
                                  categories=NULL,
                                  isVisible="",
                                  realPosition="",
                                  num_eval = 1
                                  ){
      
      #Field book app attributes
      type <- match.arg(type)
              
         if(type=="numeric"){  #numeric variable
           
           out <- fbapp_attributes(
                                  variable = variable, type = type, 
                                  defaultValue = defaultValue, 
                                  minimum = minimum, maximum = maximum,
                                  details = details
                                  )           
           
         } else if(type == "percent"){ #Percent variable
           
           out <- fbapp_attributes(
                                   variable = variable, 
                                   type = type, 
                                   defaultValue = defaultValue, 
                                   minimum=0, 
                                   maximum = 100
                                  )       
           
           
         }  else if(type=="categorical" || type == "multicat"){
              
            
            out <- fbapp_attributes(
                                   variable = variable, 
                                   type = type, 
                                   defaultValue = defaultValue, 
                                   categories = categories,
                                   details = details
                                   )  
            
         } else if(type=="date"){
           
           out <- fbapp_attributes(
                                  variable = variable, 
                                  type = type, 
                                  defaultValue =defaultValue, 
                                  details = details
                                  )  
           
         } else if(type=="boolean"){
           
           #defaultValue = "TRUE" or "FALSE" in uppercase
           out <- fbapp_attributes(
                                   variable = variable, 
                                   type = type, 
                                   defaultValue =defaultValue, 
                                   details = details
                                  )  
           
         } else if(type == "text"){
           out <- fbapp_attributes(
                                   variable = variable, 
                                   type = type, 
                                   defaultValue =defaultValue, 
                                   details = details
                                  ) 
         } else if(type == "photo"){
            out <- fbapp_attributes(
                                    variable = variable, 
                                    type = type
                                   ) 
         } else if(type == "counter"){
           out <- fbapp_attributes(
                                   variable = variable, 
                                   type = type,
                                   details = details
                                   ) 
         } else if(type == "rust_rating"){
           out <- fbapp_attributes(
                                   variable = variable, 
                                   type = type, 
                                   defaultValue =defaultValue 
                                   ) 
         } else if(type == "audio"){
           out <- fbapp_attributes(
                                   variable = variable, 
                                   type = type, 
                                   defaultValue =defaultValue, 
                                   ) 
         } else if(type == "location"){
             out <- fbapp_attributes(
                                     variable = variable, 
                                     type = "location", 
                                     defaultValue = defaultValue 
                                    ) 
         } 
           
        return(out)   
}
                    

