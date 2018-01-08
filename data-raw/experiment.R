experiment <-
  tibble::tribble( ~participant, ~condition,   ~score,
                            "1",        "A",  0.13443,
                            "2",        "A", -0.84568,
                            "3",        "A",  0.00206,
                            "4",        "B",  0.26099,
                            "5",        "B", -0.21393,
                            "6",        "B",  0.02092,
                            "7",        "A", -0.19361,
                            "8",        "A",  0.06070,
                            "9",        "A",  0.12345,
                           "10",        "B",  0.57700,
                           "11",        "B",  1.46021,
                           "12",        "B",  0.33404,
                           "13",        "B",  0.66038,
                           "14",        "A",  0.39141,
                           "15",        "A",  0.09818,
                           "16",        "B", -0.00347,
                           "17",        "B",  0.97415,
                           "18",        "B",  0.07023,
                           "19",        "A",  0.27890,
                           "20",        "A", -0.18722)

readr::write_csv(experiment, "data-raw/experiment.csv")

devtools::use_data(experiment, overwrite = TRUE, compress = "xz")
