# Indirect absolute effects 
An R function to yield indirect absolute effects using the **GRADE approach** for binary outcomes (Guyatt et al., 2013), the **transitive risks** framework (Spineli et al., 2017), and the **back-calculation method** (Dias et al., 2010). This is a three-stage approach:

- firstly, the absolute risks for all interventions of the network are obtained using the GRADE approach for binary outcomes (Guyatt et al., 2013), and the transitive risks framework (Spineli et al., 2017). The  transitive risks framework advocates that an intervention has the same absolute risk regardless of the control intervention in the comparisons of a network. After selecting a proper baseline risk for the reference intervention of the network, the absolute risks of the non-reference interventions are obtained as a function of the baseline risk and the corresponding network meta-analysis effects size of comparisons with the reference intervention;
- secondly, the baseline risk and absolute risks from the first stage are incorporated into the formula to obtain the direct and network meta-analysis absolute effects (see Guyatt et al. 2013);
- finally, the back-calculation approach is employed to obtain the indirect absolute effects (Dias et al., 2010).

## Installation
Run the following code to install the development version:

``` r
install.packages("devtools")
devtools::install_github("LoukiaSpin/indirectnma")
```

## Example
We consider the direct and network meta-analysis odds ratio of comparisons among topical antibiotics without steroids for chronically discharging ears as reported in Salanti et al. (2014) (see Table 1 and Figure 4, respectively).

``` r
discharging.ears
#> experimental control nma_or nma_lower nma_upper direct_or direct_lower direct_upper
#>            B       A   0.19      0.07      0.48      0.09         0.01         0.51
#>            C       A   0.60      0.22      1.60        NA           NA           NA
#>            D       A   0.32      0.11      0.94      1.42         0.65         3.09
#>            C       B   1.74      0.92      3.32      1.46         0.80         2.67
#>            D       B   3.22      1.60      6.47      3.47         1.71         7.07
#>            D       C   1.85      0.87      3.92      1.69         0.59         4.83
```

Use the `absolute_risk` function to calculate the unique absolute risks for the interventions B, C, and D while assuming a baseline risk of 0.80 for intervention A.  The absolute risks are per 1,000 participants.

``` r
absol_risk <- absolute_risk(data = discharging.ears[1:3, c("experimental", "nma_or", "nma_lower", "nma_upper")], 
                            ref = "A", 
                            base_risk = 0.80, 
                            measure = "OR", 
                            log = FALSE)
absol_risk
#> versus A   risk  lower   upper
#>        B    432    219     658
#>        C    706    468     865
#>        D    561    306     790
```

Create a vector comprising the baseline risk, followed by the absolute risks as they appear in the second column of `absol_risk`.

``` r
(absol_risk_new <- c(0.80, round(absol_risk[, 2]/1000, 2)))
#> 0.80 0.43 0.71 0.56
```

Use the `absolute_effects` function to obtain the indirect, direct and network meta-analysis (NMA) absolute effects. 

``` r
absolute_effects(data_nma = discharging.ears[, c("nma_or", "nma_lower", "nma_upper")], 
                 data_dir = discharging.ears[, c("direct_or", "direct_lower", "direct_upper")], 
                 abs_risk = absol_risk_new, 
                 compar = discharging.ears[, c("experimental", "control")])          

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
#> |D            |B       |  278|   117|   400|
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
#> |D            |B       |  294|   133|   412|
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
#> |D            |B       |  786|   666|   806|
#> |D            |C       |  162|    65|   245|
```

## References
Dias S, Welton NJ, Caldwell DM, Ades AE. Checking consistency in mixed treatment comparison meta-analysis. *Stat Med* 2010;29(7-8):932-44. [doi: 10.1002/sim.3767](https://onlinelibrary.wiley.com/doi/10.1002/sim.3767)

Guyatt GH, Oxman AD, Santesso N, Helfand M, Vist G, Kunz R, et al. GRADE guidelines: 12. Preparing summary of findings tables-binary outcomes. *J Clin Epidemiol* 2013;66(2):158-72. [doi: 10.1016/j.jclinepi.2012.01.012](https://www.jclinepi.com/article/S0895-4356(12)00032-7/fulltext)

Salanti G, Del Giovane C, Chaimani A, Caldwell DM, Higgins JP. Evaluating the quality of evidence from a network meta-analysis. *PLoS One* 2014;9(7):e99682. 
[doi: 10.1371/journal.pone.0099682](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0099682)

Spineli LM, Brignardello-Petersen R, Heen AF, Achille F, Brandt L, Guyatt GH, et al. Obtaining absolute effect estimates to facilitate shared decision making in the context of multiple-treatment comparisons. Abstracts of the Global Evidence Summit, Cape Town, South Africa. *Cochrane Database of Systematic Reviews* 2017;9(Suppl 1):18911.
