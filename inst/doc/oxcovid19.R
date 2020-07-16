## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----workflow, echo = FALSE, eval = TRUE, fig.width = 8, fig.height = 10, fig.pos = "center"----
DiagrammeR::grViz("
  digraph oxcovid19 {

    # a 'graph' statement
    graph [overlap = false, fontsize = 12, fontname = Helvetica]

    # Terminal nodes
    node [shape = oval, width = 1.5, penwidth = 2, fontsize = 14]
        
    a [label = '@@1'; color = darkgreen; fontcolor = darkgreen];
    h [label = '@@8'; color = crimson; fontcolor = crimson];

    # Input/output nodes
    node [shape = parallelogram, fixedsize = true, height = 1, width = 1.5, penwidth = 2, color = royalblue1, fontcolor = royalblue1]
    
    b [label = '@@2'];

    # Process nodes
    node [shape = rect]
  
    d [label = '@@4'];
    f [label = '@@6'];

    # Package nodes
    node [shape = oval, fixedsize = TRUE, width = 2, penwidth = 2, fontsize = 10, fontname = Courier, color = darkviolet, fontcolor = darkviolet]
    
    c [label = '@@3';];
    e [label = '@@5'];
    g [label = '@@7'];

    edge [minlen = 2, arrowsize = 0.75, penwidth = 2, color = dimgray]
    
    a -> b
    b -> d
    d -> f
    f -> h

    edge [minlen = 3]

    b -> c
    c -> b
    d -> e
    e -> d
    f -> g
    g -> f

    subgraph {
      rank = same; b; c;
    }

    subgraph {
      rank = same; d; e;
    }

    subgraph {
      rank = same; f; g;
    }

  }

    [1]: 'START'
    [2]: 'Step 1:\\nConnect\\nto server'
    [3]: 'oxcovid19\\nconnect_oxcovid19()'
    [4]: 'Step 2:\\nRetrieve\\ntable'
    [5]: 'oxcovid19\\nget_table; get_layer'
    [6]: 'Step 3:\\nQuery\\ntable'
    [7]: 'dplyr - filter; select\\nsf - st_read'
    [8]: 'END'
")

## ----workflow1, echo = TRUE, eval = TRUE--------------------------------------
library(oxcovid19)

## Step 1: Create a connection to OxCOVID19 PostgreSQL server
con <- connect_oxcovid19()

## Step 2: Access epidemiology table from OxCOVID19 PostgreSQL server
epi_tab <- get_table(con = con, tbl_name = "epidemiology")

## Step 3: Query the epidemiology table to show data for Great Britain
gbr_epi_tab <- dplyr::filter(.data = epi_tab, countrycode == "GBR")

## ----workflow2, echo = FALSE, eval = TRUE-------------------------------------
gbr_epi_tab

## ----workflow3, echo = TRUE, eval = TRUE--------------------------------------
## Load magrittr to use pipe operator %>%
library(magrittr)

connect_oxcovid19() %>%
  get_table(tbl_name = "epidemiology") %>%
  dplyr::filter(countrycode == "GBR")

