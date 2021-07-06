
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
  testthat::expect_null(out2)
  
  
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

test_that("test ntime: number of evaluation per time", {
  
  null_out <- create_fbapp_template(variable="peso tuberculo",
                                type = "numeric",
                                defaultValue=10,
                                minimum=0,
                                maximum=100,
                                details="kg/ha",
                                categories=c("category1","category2","category3"),
                                isVisible="",
                                realPosition="",
                                ntime = 0)
  
  ntimes_out_1 <- create_fbapp_template(variable="peso tuberculo",
                                    type = "numeric",
                                    defaultValue=10,
                                    minimum=0,
                                    maximum=100,
                                    details="kg/ha",
                                    categories=c("category1","category2","category3"),
                                    isVisible="",
                                    realPosition="",
                                    ntime = 4)
  
  ntimes_out_2 <- create_fbapp_template(variable="peso tuberculo",
                                           type = "numeric",
                                           defaultValue=10,
                                           minimum=0,
                                           maximum=100,
                                           details="kg/ha",
                                           categories=c("category1","category2","category3"),
                                           isVisible="",
                                           realPosition="",
                                           ntime = 1)
  
  
  testthat::expect_equal(nrow(ntimes_out_1),4)
  testthat::expect_equal(nrow(ntimes_out_2),1)
  testthat::expect_equal(length(unique(ntimes_out_1$trait)),4)
  testthat::expect_equal(length(unique(ntimes_out_2$trait)),1)
  testthat::expect_null(null_out)
})

