# *rfbapp*  <img src="man/figures/rfbapp_sticker_logo_rmbgr.png" width="200" align="right" />

An R package to facilitate generating variable/trait worksheet for [Field Book App](https://play.google.com/store/apps/details?id=com.fieldbook.tracker&hl=es_PE&gl=US).

[rfbapp](https://github.com/Metrika-Group/rfbapp) aims at creating and automating customized variables in *Field Book App*, a mobile phone application to collect data in the field and laboratory. Most frequently, users create variables through the user app's interface one by one. Also, it's quite intrincate to create variables outside of the application. With *rfbapp* users can automate the creation of multiples variables at once without interacting with the mobile application. Then, users are able to export them inside a *.trt* file, to be finally load it in Field Book App's trait folder. 

An important feature of Field Book App is that runs without any internet connection, making a plausible solution in places where there is bad or no internet connection. It operates on android devices and it free to use.

*rfbapp* supports the whole list types of variables available in Field Book App, such as:

- `Numerical variables`
- `Categorical variables`
- `Percentage variables` 
- `Audio record variables` 
- `Photo record variables` 
- `Date variables` 
- `GPS/Location variables`
- `Boolean variables` 
- `Free Text variables` 
- `Counting variables` 
- `Multi-categorical variables` 
- `Rust scoring variables` 

## Installation and Usage

You can install ``rfbapp` using:

``` r
if (!require("remotes"))
  install.packages("remotes")
remotes::install_github("Metrika-Group/rfbapp")
```
Load `rfbapp` in your R console

``` r
library(rfbapp)
```

More details in the website (under construction)

## Workflow

The main workflow consist of three steps:

1. Create and define your variables with `rfbapp` and export variables in `.trt` file.
2. Transfer `.trt` in the `trait` folder of the `Field Book App`
3. Go, collect your data!


<img src="man/figures/rfbapp_workflow.png" />


