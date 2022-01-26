# Indirect absolute effects 
An R function to obtain indirect absolute effects based on the GRADE approach for absolute effects (Guyatt et al., 2013) and the transitive risks framework (Spineli et al., 2017).

## Installation
Run the following code to install the development version:

``` r
install.packages("devtools")
devtools::install_github("LoukiaSpin/Indirect-absolute-effects")
```

## Example
We consider the direct and network meta-analysis odds ratio of comparisons among topical antibiotics without steroids for chronically discharging ears as reported in Salanti et al. (2014) (see Table 1 and Figure 4, respectively).

``` r
load("./data/chronically.discharging.ears.RData")
#>  experimental control nma_or nma_lower nma_upper direct_or direct_lower direct_upper
#>            B       A   0.19      0.07      0.48      0.09         0.01         0.51
#>            C       A   0.60      0.22      1.60        NA           NA           NA
#>            D       A   0.32      0.11      0.94      1.42         0.65         3.09
#>            C       B   1.74      0.92      3.32      1.46         0.80         2.67
#>            C       D   3.22      1.60      6.47      3.47         1.71         7.07
#>            D       C   1.85      0.87      3.92      1.69         0.59         4.83
```

Use the `absolute_risk` function to calculate the unique absolute risks for the interventions B, C, and D while assuming a baseline risk of 0.80 for intervention A.  The absolute risks are per 1,000 participants.

``` r
source("./R/obtain.absolute.risks_function.R")

absol_risk <- absolute_risk(data = ears[1:3, c("experimental", "nma_or", "nma_lower", "nma_upper")], 
                            ref = "A", 
                            base_risk = 0.80, 
                            measure = "OR", 
                            log = FALSE)
absol_risk
#> versus A nma_or nma_lower nma_upper
#>        B    432       219       658
#>        C    706       468       865
#>        D    561       306       790
```

Create a vector comprising the baseline risk and followed by the absolute risks as they appear in `absol_risk`.

``` r
(absol_risk_new <- c(0.80, round(absol_risk[, 2]/1000, 2)))
#> 0.80 0.43 0.71 0.56
```

Use the `absolute_effects` function to obtain the indirect, direct and network meta-analysis absolute effects. 

``` r
source("./R/indirect.absolute.effects_function.R")

absolute_effects(data_nma = ears[, c("nma_or", "nma_lower", "nma_upper")], 
                 data_dir = ears[, c("direct_or", "direct_lower", "direct_upper")], 
                 abs_risk = absol_risk_new, 
                 compar = ears[, c("experimental", "control")])          

#> $risk_diff_nma
#>
#> Table: NMA Absolute effects
#>
#> |experimental |control | mean| lower| upper|
#> |:------------|:-------|----:|-----:|-----:|
#> |B            |A       | -368|  -581|  -142|
#> |C            |A       |  -94|  -332|    65|
#> |D            |A       | -239|  -494|   -10|
#> |C            |B       |  138|   -20|   285|
#> |C            |D       |  177|    87|   231|
#> |D            |C       |  142|   -35|   273|
#>
#> $risk_diff_dir
#>
#> Table: Direct absolute effects
#>
#> |experimental |control | mean| lower| upper|
#> |:------------|:-------|----:|-----:|-----:|
#> |B            |A       | -535|  -762|  -129|
#> |C            |A       |   NA|    NA|    NA|
#> |D            |A       |   50|   -78|   125|
#> |C            |B       |   94|   -54|   238|
#> |C            |D       |  185|    97|   235|
#> |D            |C       |  123|  -131|   300|
#>
#> $risk_diff_ind
#> 
#> Table: indirect absolute effects
#>
#> |experimental |control | mean| lower| upper|
#> |:------------|:-------|----:|-----:|-----:|
#> |B            |A       | -213|  -414|  -155|
#> |C            |A       |  -94|  -332|    65|
#> |D            |A       |  112|    11|   154|
#> |C            |B       | -380|  -417|  -268|
#> |C            |D       |  269|   221|   291|
#> |D            |C       |  162|    65|   245|
```

## References
Guyatt GH, Oxman AD, Santesso N, Helfand M, Vist G, Kunz R, et al. GRADE guidelines: 12. Preparing summary of findings tables-binary outcomes. *J Clin Epidemiol* 2013;66(2):158-72. [doi: 10.1016/j.jclinepi.2012.01.012](https://www.jclinepi.com/article/S0895-4356(12)00032-7/fulltext)

Salanti G, Del Giovane C, Chaimani A, Caldwell DM, Higgins JP. Evaluating the quality of evidence from a network meta-analysis. *PLoS One* 2014;9(7):e99682. 
[doi: 10.1371/journal.pone.0099682](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0099682)

Spineli LM, Brignardello-Petersen R, Heen AF, Achille F, Brandt L, Guyatt GH, et al. Obtaining absolute effect estimates to facilitate shared decision making in the context of multiple-treatment comparisons. Abstracts of the Global Evidence Summit, Cape Town, South Africa. *Cochrane Database of Systematic Reviews* 2017;9(Suppl 1):18911.
