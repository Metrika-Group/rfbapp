library(hexSticker)
library(magick)
library(showtext)
library(dplyr)

# open https://fonts.google.com/
# font poma

# -------------------------------------------------------------------------
# inkaverse ---------------------------------------------------------------
# -------------------------------------------------------------------------
#font_add_google("Righteous")

logo <- list.files("img/"
                   , full.names = T
                   , pattern = "rfbapp_logo_raw_v02.png"
) %>% 
  image_read() 

sticker(logo, package="Rfbapp",white_around_sticker = TRUE,
        p_size=20, s_x=1, s_y=.8, s_width=1.4, s_height=1.2, 
        h_fill="#0be247ff",h_color = "#000000",  p_family = "Righteous",p_color = "black",
        filename = "img/rfbapp_logo.png"
)