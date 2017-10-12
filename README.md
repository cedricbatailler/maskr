maskr
====================

[![CRAN status](http://www.r-pkg.org/badges/version/maskr)](https://cran.r-project.org/package=maskr) [![Build Status](https://travis-ci.org/cedricbatailler/maskr.svg?branch=master)](https://travis-ci.org/cedricbatailler/maskr)

## Installation

Development version from Github:

``` r
if(!require(devtools)){install.packages("devtools")}
devtools::install_github("cedricbatailler/maskr")
```

## What does it do ?

According to Wicherts et al. (2016), insufficient blinding during the data anaysis phase is considered as one of the 34 *degrees of freedom* that researchers have during the design, collection, analysis and report of psychological studies. They say:

> "It is surprising that blinding to conditions and hypotheses of experimenters, coders, and observers is considered to be crucial during data collection, while in practice, the analyses are typically conducted by a person who is not only aware of the hypotheses, but also benefits directly from corroborating them (commonly by means of a significance test). Together with the many researcher DFs during the analyses, these factors do not entail the most optimal mix for objective and unbiased results."

One suggestion to prevent such biases would be then to divide data collection and data analysis between two persons: an experimenter, and a data analyst. However, this solution is costly and is thus not always practicable. Another solution would be to use a tool that allows the experimenter to be blind during the analysis stage.

That's what `maskr` is for.

More precisely, `maskr` allow to process outliers data while being blind to experimental conditions. To this end, categorical variables are encrypted.

## How to use it ?

Below we use the `mtcars` dataset and consider that we are interested in the effects of the number of cylinders `cyl` and `vs` on fuel consumption `mpg`. We start by encrypting these two columns.

``` r
library(maskr)
data(mtcars)
dic <- dictionary(mtcars, cyl, vs)
mtcars_encrypted <- encrypt(mtcars, dic, cyl, vs)
```

We can then process outliers on the encrypted dataframe. For instance, we can choose to remove observations with studentized residuals superior than 2.

``` r
devtools::install_github("cedricbatailler/LIPmisc")
library(LIPmisc)
mtcars_encrypted$id <- 1:nrow(mtcars_encrypted)
outliers <- lm_outliers(mtcars_encrypted, mpg ~ cyl, id)
mtcars_encrypted <- mtcars_encrypted[!mtcars_encrypted$id==outliers$id[outliers$sdr>2],]
```

And finally we can conduct our analyses, as planned, with the back-decrypted dataframe.

``` r
mtcars_decrypted <- decrypt(mtcars_encrypted, dic, cyl, vs)
lm(mpg ~ cyl * vs, mtcars_decrypted)
```

## References

Wicherts, J. M., Veldkamp, C. L. S., Augusteijn, H. E. M., Bakker, M., van Aert, R. C. M., & van Assen, M. A. L. M. (2016). Degrees of Freedom in Planning, Running, Analyzing, and Reporting Psychological Studies: A Checklist to Avoid p-Hacking. Frontiers in Psychology, 7(November), 1–12. http://doi.org/10.3389/fpsyg.2016.01832
