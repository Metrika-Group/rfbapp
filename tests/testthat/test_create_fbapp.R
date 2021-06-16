
#, "categorical", "percent"
# "date","boolean","text","photo",
# "counter","multicat", "score","rust_rating",
# "audio","location"

test_that("test create template for numeric", {
  
  out1 <- create_fbapp_template(variable="peso tuberculo",
                              type = "numeric",
                              defaultValue=10,
                              minimum=0,
                              maximum=100,
                              details="kg/ha",
                              categories=c("category1","category2","category3"),
                              isVisible="",
                              realPosition="")
  
  out2 <- create_fbapp_template(variable="",
                               type = "numeric",
                               defaultValue=10,
                               minimum=0,
                               maximum=10,
                               details="kg/ha",
                               isVisible="",
                               realPosition="")
  
  testthat::expect_equal(nrow(out1),1)
  testthat::expect_error(out2)
  
  
  out3 <- testthat::expect_error(create_fbapp_template(variable="peso tuberculo",
                               type = "numeric2",
                               defaultValue=10,
                               minimum=0,
                               maximum=100,
                               details="kg/ha",
                               isVisible="",
                               realPosition=""))

  
  # expect_success(expect_length(1, 1))
  # expect_failure(expect_length(1, 2), "has length 1, not length 2.")
  # expect_success(expect_length(1:10, 10))
  # expect_success(expect_length(letters[1:5], 5))
})



