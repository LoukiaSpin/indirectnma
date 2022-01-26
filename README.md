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
data(chronically discharging ears)
```

## References
Guyatt GH, Oxman AD, Santesso N, Helfand M, Vist G, Kunz R, et al. GRADE guidelines: 12. Preparing summary of findings tables-binary outcomes. *J Clin Epidemiol* 2013;66(2):158-72. [doi: 10.1016/j.jclinepi.2012.01.012](https://www.jclinepi.com/article/S0895-4356(12)00032-7/fulltext)

Salanti G, Del Giovane C, Chaimani A, Caldwell DM, Higgins JP. Evaluating the quality of evidence from a network meta-analysis. *PLoS One* 2014;9(7):e99682. 
[doi: 10.1371/journal.pone.0099682](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0099682)

Spineli LM, Brignardello-Petersen R, Heen AF, Achille F, Brandt L, Guyatt GH, et al. Obtaining absolute effect estimates to facilitate shared decision making in the context of multiple-treatment comparisons. Abstracts of the Global Evidence Summit, Cape Town, South Africa. *Cochrane Database of Systematic Reviews* 2017;9(Suppl 1):18911.
