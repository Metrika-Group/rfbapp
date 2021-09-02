#' Get abbreviation name of variables
#' @param type type of variable
#' @param inputs list of inputs
#' 

get_abbvar <- function(type, inputs){
  
  if(type == "numeric"){
    out <-  inputs$num_txt_var_name
  } else if(type =="categorical"){
    out <-  inputs$cat_txt_var_name
  } else if(type =="percent"){
    out <-  inputs$pct_txt_var_name
  } else if(type == "audio"){
    out <-  inputs$aud_txt_var_name
  } else if(type == "photo"){
    out <-  inputs$pho_txt_var_name
  } else if(type == "date"){
    out <-  inputs$date_txt_var_name
  } else if(type == "boolean"){
    out <-  inputs$bool_txt_var_name
  } else if(type == "text"){
    out <-  inputs$text_txt_var_name
  } else if(type == "counter"){
    out <-  inputs$count_txt_var_name
  } else if(type == "multicat"){
    out <-  inputs$mulc_txt_var_name
  } else if(type == "rust_rating"){
    out <-  inputs$rust_txt_var_name
  } else if(type == "location"){
    out <-  inputs$local_txt_var_name
  }
  
  return(out)
  
}


#####

get_tbl_records <- function(inputs){
      
  type <- as.character(inputs$sel_var_type)
  
  if(type=="numeric"){
    
    out <-  data.frame(
      trait=inputs$num_txt_var_name,
      type = inputs$sel_var_type,
      defaultValue="",
      minimum = as.numeric(inputs$num_var_min),
      maximum = as.numeric(inputs$num_var_max),
      categories = "",
      details = inputs$num_txt_details,
      isVisible="",
      realPosition="",
      ntime = as.numeric(inputs$neval_time)
    )
    
  } else if(type == "categorical"){
    
    out <- data.frame(
      trait=inputs$cat_txt_var_name ,
      type = inputs$sel_var_type,
      defaultValue="",
      minimum = "",
      maximum = "",
      categories=  paste0(inputs$cat_sel_values,collapse = "," ),
      details= inputs$cat_txt_details,
      isVisible="",
      realPosition="",
      ntime = as.numeric(inputs$neval_time)
    )
    
  } else if(type == "percent"){
    
    out <- data.frame(
      trait=inputs$pct_txt_var_name ,
      type = inputs$sel_var_type,
      defaultValue="",
      minimum = "",
      maximum = "",
      categories="",
      details= inputs$pct_txt_details,
      isVisible="",
      realPosition="",
      ntime = as.numeric(inputs$neval_time)
    )
    
  } else if(type == "audio"){
    
    out <-  data.frame(
      trait = inputs$aud_txt_var_name ,
      type = inputs$sel_var_type,
      defaultValue ="",
      minimum = "",
      maximum = "",
      categories ="",
      details = inputs$aud_txt_details,
      isVisible ="",
      realPosition ="",
      ntime = as.numeric(inputs$neval_time)
    )
    
  } else if(type =="photo"){
    
    out <-  data.frame(
      trait = inputs$pho_txt_var_name ,
      type = inputs$sel_var_type,
      defaultValue ="",
      minimum = "",
      maximum = "",
      categories ="",
      details = inputs$pho_txt_details,
      isVisible ="",
      realPosition ="",
      ntime = as.numeric(inputs$neval_time)
    )
    
  } else if(type == "date") {
    
    out <-  data.frame(
      trait = inputs$date_txt_var_name ,
      type = inputs$sel_var_type,
      defaultValue ="",
      minimum = "",
      maximum = "",
      categories ="",
      details = inputs$date_txt_details,
      isVisible ="",
      realPosition ="",
      ntime = as.numeric(inputs$neval_time)
    )
    
  } else if(type == "boolean"){
    
    out <-  data.frame(
      trait = inputs$bool_txt_var_name ,
      type = inputs$sel_var_type,
      defaultValue ="",
      minimum = "",
      maximum = "",
      categories ="",
      details = inputs$bool_txt_details,
      isVisible ="",
      realPosition ="",
      ntime = as.numeric(inputs$neval_time)
    )
    
  } else if(type =="text"){
    
    out <-  data.frame(
      trait = inputs$text_txt_var_name ,
      type = inputs$sel_var_type,
      defaultValue ="",
      minimum = "",
      maximum = "",
      categories ="",
      details = inputs$text_txt_details,
      isVisible ="",
      realPosition ="",
      ntime = as.numeric(inputs$neval_time)
    )
    
  } else if(type == "counter"){
    
    out <-  data.frame(
      trait = inputs$count_txt_var_name ,
      type = inputs$sel_var_type,
      defaultValue ="",
      minimum = "",
      maximum = "",
      categories ="",
      details = inputs$count_txt_details,
      isVisible ="",
      realPosition ="",
      ntime = as.numeric(inputs$neval_time)
    )
    
  } else if(type == "multicat"){
    
    out <-  data.frame(
      trait = as.character(inputs$mulc_txt_var_name),
      type = as.character(inputs$sel_var_type),
      defaultValue = "",
      minimum = "",
      maximum = "",
      categories = paste0(inputs$mulc_sel_values, collapse = ","),
      details = inputs$mulc_txt_details,
      isVisible = "",
      realPosition = "",
      ntime = as.numeric(inputs$neval_time)
    )
    
  } else if(type == "rust_rating"){
    
    out <-  data.frame(
      trait = inputs$rust_txt_var_name ,
      type = inputs$sel_var_type,
      defaultValue ="",
      minimum = "",
      maximum = "",
      categories ="",
      details = inputs$rust_txt_details,
      isVisible ="",
      realPosition ="",
      ntime = as.numeric(inputs$neval_time)
    )
    
  } else if(type == "location"){
    
    out <-  data.frame(
      trait = inputs$local_txt_var_name,
      type = inputs$sel_var_type,
      defaultValue ="",
      minimum = "",
      maximum = "",
      categories ="",
      details = inputs$local_txt_details,
      isVisible ="",
      realPosition ="",
      ntime = as.numeric(inputs$neval_time)
    )
  } 
  
  out
  
        
}




#####

#' Check whether a condition is satisfied or not
#' @param type type of variable
#' @param inputs list of inputs
#' 
check_input_condition <- function(type, inputs){
  
  if(type == "numeric"){
    cond <-  (nchar(inputs$num_txt_var_name)>2 && nchar(inputs$num_txt_details)>2 && !is.na(inputs$num_var_min) && !is.na(inputs$num_var_max))
  } else   if(type =="categorical"){
    cond <- ( nchar(inputs$cat_txt_var_name)>2 && nchar(inputs$cat_txt_details)>2 && length(inputs$cat_sel_values)>1)
  } else if(type =="percent"){
    cond <- (nchar(inputs$pct_txt_var_name)>2 && nchar(inputs$pct_txt_details)>2)
  } else if(type == "audio"){
    cond <-  (nchar(inputs$aud_txt_var_name)>2 && nchar(inputs$aud_txt_details)>2)
  } else if(type == "photo"){
    cond <-  (nchar(inputs$pho_txt_var_name)>2 && nchar(inputs$pho_txt_details)>2)
  } else if(type == "date"){
    cond <-  (nchar(inputs$date_txt_var_name)>2 && nchar(inputs$date_txt_details)>2)
  } else if(type == "boolean"){
    cond <-  (nchar(inputs$bool_txt_var_name)>2 && nchar(inputs$bool_txt_details)>2)
  } else if(type == "text"){
    cond <-  (nchar(inputs$text_txt_var_name)>2 && nchar(inputs$text_txt_details)>2)
  } else if(type == "counter"){
    cond <-  (nchar(inputs$count_txt_var_name)>2 && nchar(inputs$count_txt_details)>2)
  } else if(type == "multicat"){
    cond <-  (nchar(inputs$mulc_txt_var_name)>2 && nchar(inputs$mulc_txt_details)>2 && length(inputs$mulc_sel_values)>1)
  } else if(type == "rust_rating"){
    cond <-  (nchar(inputs$rust_txt_var_name )>2 && nchar(inputs$rust_txt_details)>2)
  } else if(type == "location"){
    cond <-  (nchar(inputs$local_txt_var_name)>2 && nchar(inputs$local_txt_details)>2)
  }
  
return(cond)
  
}

#' Detect duplicates
#' @param x field book app's form table
#' 
check_form <- function(x){
  
  if(anyDuplicated(x$trait)>0){
    
    dup <- x$trait[duplicated(x$trait)]
    msg <- paste0("There duplicates in your variable's form. Please, remove duplicates ", paste0(dup, collapse = ", "))
    cond <- TRUE
    
  } else{
    msg <- "Variable successfully added"
    cond <- FALSE
  }
  
  out <- list(msg=msg, cond = cond)
  
}



