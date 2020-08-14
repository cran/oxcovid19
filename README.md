
<!-- README.md is generated from README.Rmd. Please edit that file -->

# oxcovid19: An R API to the Oxford COVID-19 Database

<!-- <img src="man/figures/oxcovid19.png" width="200px" align="right" /> -->

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN](https://img.shields.io/cran/l/oxcovid19.svg)](https://CRAN.R-project.org/package=oxcovid19)
[![CRAN
status](https://www.r-pkg.org/badges/version/oxcovid19)](https://CRAN.R-project.org/package=oxcovid19)
[![cran
checks](https://cranchecks.info/badges/summary/oxcovid19)](https://cran.r-project.org/web/checks/check_results_oxcovid19.html)
[![CRAN](http://cranlogs.r-pkg.org/badges/oxcovid19)](https://CRAN.R-project.org/package=oxcovid19)
[![CRAN](http://cranlogs.r-pkg.org/badges/grand-total/oxcovid19)](https://CRAN.R-project.org/package=oxcovid19)
[![R build
status](https://github.com/como-ph/oxcovid19/workflows/R-CMD-check/badge.svg)](https://github.com/como-ph/oxcovid19/actions)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/como-ph/oxcovid19?branch=master&svg=true)](https://ci.appveyor.com/project/como-ph/oxcovid19)
[![Travis build
status](https://travis-ci.org/como-ph/oxcovid19.svg?branch=master)](https://travis-ci.org/como-ph/oxcovid19)
[![R build
status](https://github.com/como-ph/oxcovid19/workflows/test-coverage/badge.svg)](https://github.com/como-ph/oxcovid19/actions)
[![Codecov test
coverage](https://codecov.io/gh/como-ph/oxcovid19/branch/master/graph/badge.svg)](https://codecov.io/gh/como-ph/oxcovid19?branch=master)
[![CodeFactor](https://www.codefactor.io/repository/github/como-ph/oxcovid19/badge)](https://www.codefactor.io/repository/github/como-ph/oxcovid19)
[![DOI](https://zenodo.org/badge/276818770.svg)](https://zenodo.org/badge/latestdoi/276818770)
<!-- badges: end -->

The [OxCOVID19 Project](https://covid19.eng.ox.ac.uk) aims to increase
our understanding of the COVID-19 pandemic and elaborate possible
strategies to reduce the impact on the society through the combined
power of statistical, mathematical modelling, and machine learning
techniques. The [OxCOVID19 Database](https://covid19.eng.ox.ac.uk) is a
large, single-centre, multimodal relational database consisting of
information (using acknowledged sources) related to COVID-19 pandemic.
This package provides an [R](https://www.r-project.org)-specific
interface to the [OxCOVID19 Database](https://covid19.eng.ox.ac.uk)
based on widely-used data handling and manipulation approaches in
[R](https://www.r-project.org).

## Motivation

The [OxCOVID19 Project](https://covid19.eng.ox.ac.uk) team presented to
the [CoMo
Consortium](https://www.tropicalmedicine.ox.ac.uk/news/como-consortium-the-covid-19-pandemic-modelling-in-context)
during its weekly meeting on the 1st of July 2020. During this meeting,
the [CoMo
Consortium](https://www.tropicalmedicine.ox.ac.uk/news/como-consortium-the-covid-19-pandemic-modelling-in-context)
considered the use of the [OxCOVID19
Database](http://covid19.eng.ox.ac.uk/) for use in filling data and
information for country-specific parameters required in the [CoMo
Consortium](https://www.tropicalmedicine.ox.ac.uk/news/como-consortium-the-covid-19-pandemic-modelling-in-context)
model. Given that the [CoMo
Consortium](https://www.tropicalmedicine.ox.ac.uk/news/como-consortium-the-covid-19-pandemic-modelling-in-context)
model is [R](https://www.r-project.org)-centric, it makes logical sense
to build an [R](https://www.r-project.org)-specific API to connect with
the [OxCOVID19](https://covid19.eng.ox.ac.uk)
[PostgreSQL](https://www.postgresql.org) database. This package aims to
facilitate the possible use of the
[OxCOVID19](https://covid19.eng.ox.ac.uk) database for this purpose
through purposefully-written functions that connects an R user to the
database directly from [R](https://www.r-project.org) (as opposed to
doing a manual download of the data or using separate tools to access
[PostgreSQL](https://www.postgresql.org)) and processes and structures
the available datasets into country-specific tables structured for the
requirements of the [CoMo
Consortium](https://www.tropicalmedicine.ox.ac.uk/news/como-consortium-the-covid-19-pandemic-modelling-in-context)
model. A direct link to the [PostgreSQL](https://www.postgresql.org) via
[R](https://www.r-project.org) is also advantageous as this is updated
more frequently than the CSV datasets made available via
[GitHub](https://github.com/covid19db/data).

## Installation

You can install `oxcovid19` from [CRAN](https://cran.r-project.org)
with:

``` r
install.packages("oxcovid19")
```

You can install the development version of `oxcovid19` from
[GitHub](https://github.com/como-ph/oxcovid19) with:

``` r
if(!require(remotes)) install.packages("remotes")
remotes::install_github("como-ph/oxcovid19")
```

## Usage

The primary use case for the `oxcovid19` package is for facilitating a
simplified, [R](https://www.r-project.org)-based workflow for 1)
connecting to the [OxCOVID19](https://covid19.eng.ox.ac.uk)
[PostgreSQL](https://www.postgresql.org) server; 2) accessing table/s
available from the [PostgreSQL](https://www.postgresql.org) server; and,
3) querying the [PostgreSQL](https://www.postgresql.org) server with
specific parameters to customise table/s output for intended use.

The following code demonstrates this workflow:

``` r
library(oxcovid19)
#> 
#>   ___          ____  ___ __     __ ___  ____   _   ___
#>  / _ \ __  __ / ___|/ _ \\ \   / /|_ _||  _ \ / | / _ \
#> | | | |\ \/ /| |   | | | |\ \ / /  | | | | | || || (_) |
#> | |_| | >  < | |___| |_| | \ V /   | | | |_| || | \__, |
#>  \___/ /_/\_\ \____|\___/   \_/   |___||____/ |_|   /_/
#>     ___           _          _
#>    |  _ \   __ _ | |_  __ _ | |__    __ _  ___   ___
#>    | | | | / _` || __|/ _` || '_ \  / _` |/ __| / _ \
#>    | |_| || (_| || |_| (_| || |_) || (_| |\__ \|  __/
#>    |____/  \__,_| \__|\__,_||_.__/  \__,_||___/ \___|
#> 
#> The OxCOVID19 Database makes use of several datasets. If you
#> use any of the data provided by this package, please include
#> the appropriate citation as described at the following
#> website:
#> 
#> https://covid19.eng.ox.ac.uk/data_sources.html

## Step 1: Create a connection to OxCOVID19 PostgreSQL server
con <- connect_oxcovid19()

## Step 2: Access epidemiology table from OxCOVID19 PostgreSQL server
epi_tab <- get_table(con = con, tbl_name = "epidemiology")

## Step 3: Query the epidemiology table to show data for Great Britain
gbr_epi_tab <- dplyr::filter(.data = epi_tab, countrycode == "GBR")
```

**Step 1** and **Step 2** above are facilitated by the
`connect_oxcovid19` and the `get_table` functions provided by the
`oxcovid19` package. These functions are basically low-level wrappers to
functions in the [`DBI`](https://db.rstudio.com/dbi/) and
[`RPostgres`](https://rpostgres.r-dbi.org) packages applied specifically
to work with the [OxCOVID19](https://covid19.eng.ox.ac.uk)
[PostgreSQL](https://www.postgresql.org). These functions facilitate
convenient access to the server for general
[R](https://www.r-project.org) users without having to learn to use the
`DBI` and `RPostgres` packages.

**Step 3**, on the other hand, is facilitated by the `dplyr` package
functions which were designed to work with different types of tables
including those from various database server connections such as
[PostgreSQL](https://www.postgresql.org).

The output of the workflow shown above is:

    #> # Source:   lazy query [?? x 15]
    #> # Database: postgres [covid19@covid19db.org:5432/covid19]
    #>    source date       country countrycode adm_area_1 adm_area_2 adm_area_3 tested
    #>    <chr>  <date>     <chr>   <chr>       <chr>      <chr>      <chr>       <int>
    #>  1 GBR_P… 2020-03-21 United… GBR         England    Blackpool  Blackpool      NA
    #>  2 GBR_P… 2020-03-20 United… GBR         England    Derbyshire North Eas…     NA
    #>  3 GBR_P… 2020-03-20 United… GBR         England    Cambridge… South Cam…     NA
    #>  4 GBR_P… 2020-03-20 United… GBR         England    Cambridge… Huntingdo…     NA
    #>  5 GBR_P… 2020-03-20 United… GBR         England    Central B… Central B…     NA
    #>  6 GBR_P… 2020-03-20 United… GBR         England    Shropshire Shropshire     NA
    #>  7 GBR_P… 2020-03-20 United… GBR         England    Wiltshire  Wiltshire      NA
    #>  8 GBR_P… 2020-03-20 United… GBR         England    Cheshire … Cheshire …     NA
    #>  9 GBR_P… 2020-03-20 United… GBR         England    Durham     Durham         NA
    #> 10 GBR_P… 2020-03-20 United… GBR         England    Isle of W… Isle of W…     NA
    #> # … with more rows, and 7 more variables: confirmed <int>, recovered <int>,
    #> #   dead <int>, hospitalised <int>, hospitalised_icu <int>, quarantined <int>,
    #> #   gid <chr>

The `oxcovid19` package functions are also designed to allow *pipe
operations* using the `magrittr` package. The workflow above can be done
using piped operations as follows:

``` r
## Load magrittr to use pipe operator %>%
library(magrittr)

connect_oxcovid19() %>%
  get_table(tbl_name = "epidemiology") %>%
  dplyr::filter(countrycode == "GBR")
#> # Source:   lazy query [?? x 15]
#> # Database: postgres [covid19@covid19db.org:5432/covid19]
#>    source date       country countrycode adm_area_1 adm_area_2 adm_area_3 tested
#>    <chr>  <date>     <chr>   <chr>       <chr>      <chr>      <chr>       <int>
#>  1 GBR_P… 2020-03-21 United… GBR         England    Blackpool  Blackpool      NA
#>  2 GBR_P… 2020-03-20 United… GBR         England    Derbyshire North Eas…     NA
#>  3 GBR_P… 2020-03-20 United… GBR         England    Cambridge… South Cam…     NA
#>  4 GBR_P… 2020-03-20 United… GBR         England    Cambridge… Huntingdo…     NA
#>  5 GBR_P… 2020-03-20 United… GBR         England    Central B… Central B…     NA
#>  6 GBR_P… 2020-03-20 United… GBR         England    Shropshire Shropshire     NA
#>  7 GBR_P… 2020-03-20 United… GBR         England    Wiltshire  Wiltshire      NA
#>  8 GBR_P… 2020-03-20 United… GBR         England    Cheshire … Cheshire …     NA
#>  9 GBR_P… 2020-03-20 United… GBR         England    Durham     Durham         NA
#> 10 GBR_P… 2020-03-20 United… GBR         England    Isle of W… Isle of W…     NA
#> # … with more rows, and 7 more variables: confirmed <int>, recovered <int>,
#> #   dead <int>, hospitalised <int>, hospitalised_icu <int>, quarantined <int>,
#> #   gid <chr>
```

The workflow using the piped workflow outputs the same result as the
earlier workflow but with a much streamlined use of code.

## Limitations

The `oxcovid19` package is in active development which will be dictated
by the evolution of the [OxCOVID19
Database](http://covid19.eng.ox.ac.uk/) over time. Whilst every attempt
will be employed to maintain syntax of current functions, it is possible
that current functions may change syntax or operability in order to
ensure relevance or maybe deprecated in lieu of a more appropriate
and/or more performant function. In either of these cases, any change
will be well-documented and explained to users and deprecation will be
staged in such a way that users will be informed in good time to allow
for transition to using the new functions.

## Citations

If you find [OxCOVID19 Database](http://covid19.eng.ox.ac.uk/) useful
please cite:

Adam Mahdi, Piotr Błaszczyk, Paweł Dłotko, Dario Salvi, Tak-Shing Chan,
John Harvey, Davide Gurnari, Yue Wu, Ahmad Farhat, Niklas Hellmer,
Alexander Zarebski, Bernie Hogan, Lionel Tarassenko, **Oxford COVID-19
Database: a multimodal data repository for better understanding the
global impact of COVID-19**. University of Oxford, 2020.

The [OxCOVID19 Database](http://covid19.eng.ox.ac.uk/) is the result of
many hours of volunteer efforts and generous contributions of many
organisations. If you use a specific table please also cite the
underlying source as described
[here](https://covid19.eng.ox.ac.uk/data_sources.html). Sources of
specific tables can also be accessed via the `oxcovid19` package through
the `data_sources` dataset. For example, if you have accessed the
**Epidemiology** table from the database, you can access the sources for
this table with:

``` r
data_sources[["epidemiology"]]
```

which gives the following result:

    #> # A tibble: 45 x 5
    #>    Country  `Source code` Source          Features           `Terms of Use`     
    #>    <chr>    <chr>         <chr>           <chr>              <chr>              
    #>  1 World    WRD_ECDC      European Centr… confirmed, dead, … ECDC Copyright     
    #>  2 Argenti… LAT_DSRP      covid-19_latin… confirmed, dead, … CC BY-NC-SA 4.0    
    #>  3 Austral… AUS_C1A       covid-19-au     tested, confirmed… For educational an…
    #>  4 Austria  EU_ZH         COVID19 EU      tested, confirmed… MIT                
    #>  5 Belgium  BEL_LE        covid19-be      tested, confirmed… CC0 1.0 Universal  
    #>  6 Brazil   BRA_MSHM      covid19-Brazil… confirmed (countr… Public Domain      
    #>  7 Brazil   LAT_DSRP      covid-19_latin… confirmed,  dead,… CC BY-NC-SA 4.0    
    #>  8 Canada   CAN_GOV       Public Health … tested, confirmed… Attribution requir…
    #>  9 Chile    LAT_DSRP      covid-19_latin… confirmed,  dead,… CC BY-NC-SA 4.0    
    #> 10 China    CHN_ICL       Imperial Colle… confirmed,  dead,… with permission    
    #> # … with 35 more rows
