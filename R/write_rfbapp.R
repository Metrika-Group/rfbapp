##TODO
# crear una funcion para escribir archivos .trt
### write.csv(fbapp_traitlist, file = paste0("/app/", filename,".trt"), row.names = FALSE, na = "")
# el archivo debe guardarse en la direcion que el usuario elija
# validar que la funcion sea la correcta

#' Write data to an trt file
#' @description \code{write_rfbapp} write a data.frame to an \code{.trt} file (FieldBook App format)
#' @param x object that has table containing a set of variables
#' @param file \code{trt} file name
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
  
  if(is.element("rfbapp",class(x))){
    write.csv(x, file = paste0("/app/", file,".trt"), row.names = FALSE, na = "")  
  }
  

}
