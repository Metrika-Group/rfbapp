library(hexSticker)
library(magick)
library(showtext)
library(dplyr)

# open https://fonts.google.com/
# font poma

# -------------------------------------------------------------------------
# inkaverse ---------------------------------------------------------------
# -------------------------------------------------------------------------
font_add_google("Righteous")
#font_add_google(name="Montserrat")

logo <- list.files("img/"
                   , full.names = T
                   , pattern = "raw_rbfapp_icon.png"
) %>% 
  image_read() 

sticker(logo, package="rfbapp",white_around_sticker = TRUE,
        p_size=20, s_x=1, s_y=.8, s_width=1.4, s_height=1.5, 
        h_fill="#0be247ff",h_color = "#000000",  p_family = "Righteous",p_color = "black",
        filename = "man/figures/rfbapp_sticker_logo.png"
)
