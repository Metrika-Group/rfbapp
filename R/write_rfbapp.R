##TODO
# crear una funcion para escribir archivos .trt
### write.csv(fbapp_traitlist, file = paste0("/app/", filename,".trt"), row.names = FALSE, na = "")
# el archivo debe guardarse en la direcion que el usuario elija
# validar que la funcion sea la correcta

#' Write data to an trt file
#' @description \code{write_rfbapp} write a data.frame to an \code{.trt} file (FieldBook App format)
#' @param x object that has table containing a set of variables
#' @param file \code{trt} file name
#' @importFrom utils write.csv
#' @export

write_rfbapp <- function(x, file = NULL ){
  
  if(is.null(file)){
    message("Please enter a file name / Ingres un nombre para el archivo")
    return()
  }
  
  if(!grepl(pattern = "\\.trt$", file)){
    message("File name must include .trt extension / El archivo debe incluir una extesion .trt")
    return()
  }
  
  
  if(!is.element("trait",set = colnames(x))){
    message("Variable's form must include trait colummn")
    return()
  }
  
  if(anyDuplicated(x$trait)>0){
    dup <- x$trait[duplicated(x$trait)]
    msg <- paste0("There duplicates in your variable's form. Please, remove duplicates", paste0(dup, collapse = ", "))
    message(msg)
    return()
  }
  
  
  if(is.element("rfbapp",class(x))){
    write.csv(x, file = file, row.names = FALSE, na = "")  
  } else {
    message("this file is not fiel book app form file")
  }
  

}
