Spatial visualization of unnormalized data is often effectively just plotting population density. Scaling by population density can help, but depending on the type of data, this can effectively be plotting inverse population density. To adjust for this, I suggest plotting a weighted residual instead. Several of these options are briefly discussed below. It is possible that these ideas already exist in literature, but I haven't run across them. Also an R-file with a function that implements these methods is included.

## Weighted Least Squares

Starting with the assumption that a quantity <em>q<sub>i</sub></em> in region <em>i</em> with a population <em>p<sub>i</sub></em> is normally distributed with the variance proportional to the population:

<img src="https://render.githubusercontent.com/render/math?math=q_i = N(\alpha p_i, \beta p_i)">

Then the scalar &alpha; can be found with weighted least squares and is equal to the total proportion:

<img src="https://render.githubusercontent.com/render/math?math=\alpha = \frac{\sum_i q_i}{\sum_i p_i}">

And the new value to be plotted is the weighted residual:

<img src="https://render.githubusercontent.com/render/math?math=r_i =\frac{q_i - \alpha p_i}{\sqrt{\beta p_i}}">

The term &beta; doesn't affect the relative scaling but can be calculated in 2 ways.

a. Using the least squares estimate:

<img src="https://render.githubusercontent.com/render/math?math=\beta = \frac{1}{N-1} \sum_{i=1}^N \frac{(q_i - \alpha p_i)^2}{p_i}"> 

b. Use variance estimate from binomial distribution assumption:

<em>&beta; = P(1-P)</em> where <em>P</em> is the total proportion,  <em>P = &alpha;</em> in this case.


## Difference in proportions
Starting with the assumption that  <em>q<sub>i</sub></em> is  binomially  distributed, then the estimate for the proportion is:

<img src="https://render.githubusercontent.com/render/math?math=P_i = \frac{q_i}{p_i}">

with estimate variance: 

<img src="https://render.githubusercontent.com/render/math?math=var(P_i) = \frac{P_i(1-P_i)}{p_i}">


In this case, what is used to plot is the variance weighted difference in proportion of region <em>i</em> and the proportion of the rest of the data:

<img src="https://render.githubusercontent.com/render/math?math=r_i = \frac{P_i - P_{t\neq i}}{\sqrt{ var(P_i)  \plus  var(P_{t\neq i} )} }">

where <em>P</em><sub>i &ne;t</sub> is the total proportion estimate from the data set not including region <em>i</em>.


## Example 
In the figure below, lightning deaths from 1959 to 1994 are plotted below to demonstrate these normalization techniques. The lightning data is sourced from https://www.weather.gov/cae/lightningbystate.html and the population numbers are from the 1979 estimate sourced from https://www2.census.gov/programs-surveys/popest/datasets/1970-1980/national/asrh/. In the raw numbers, the larger population of Florida makes it stand out. In the per-population plot, the small population makes Wyoming stand out. The weighted least squares normalization is able to highlight both Florida and Wyoming along with a handful of other states. It also highlights how California is surprisingly low. In the binomially distributed normalization, California is so low that it washes out the rest. In my experience the second method can amplify outliers in some data sets, which may or may not be desirable depending on the goal.
![Comparision](https://user-images.githubusercontent.com/102822092/167511207-8ae95be8-a9e4-4d15-80b8-badd0a5991a0.png)
