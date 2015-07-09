# FusionRP
Code for FusionRP: parameter fitting, plotting and outlier detection

Overview:
1. Data format
2. Description of files
3. Generating synthetic data
4. Parameter Fitting
5. Plotting functions (2D only)
6. Outlier detection

----------------------------------------------------------------------------
1. Data format: 
Suppose the data are 'd' dimensional. 
On each line, we have a new data point. Each data point is represented by a
space separated (d+1)-tuple of the form (coordinate_1, coordinate_2, ..., coordinate_d, count).
For example: call-in vs call-out
1 0 1000
0 1 901
1 1 678
2 1 19
1 2 32
2 2 5
3 1 1

This means the data are 2-dimensional and (1,0) is observed 1000 times.
In other words 1000 people have 1 call-in and 0 call-out. 
Similarly, the last data point says that only one person has 3 call-in and 1 call-out.
The same interpretation can be extended to higher dimensional data. 

-------------------------------------------------------------------------------------
2. Description of the files:

Code to generate synthetic data:
- gen_synthetic_data.m : 2-dimensional data only
- gen_synthetic_data2.m : d > 1 dimensional data (generalization of above code)

Fitting functions:
- paramLearn_nD.m : Learn parameters of FusionRP

Outlier detection:
- detect_outliers.m	

Plotting functions (d = 2 only)
- plotcon.m: Plot contours from a data file
- plotcon_syn.m: Plot contours analytically from FusionRP fit

Sample:
- sample_data	: Sample data to illustrate format
- sample_script.m : Sample script to illustrate usage

Helper functions:	
drchrnd.m	: Generate Dirichlet random variables
dir_param.m: Method of moments estimator of Dirichlet-Multinomial
MLE2D2.m	: Maximum Likelihood estimator of Beta-Binomial (for 2-dimensional data only)
MLEnD.m	  : Maximum Likelihood estimator of Dirichlet-Multinomial (general case)
log_pdf.m : Logarithm of probability density function of FusionRP

---------------------------------------------------------------------------------------------
3. Generation of synthetic data:
FusionRP parameters are:
  s: start probability (between 0 and 1)
  alpha: parameter of Dirichlet distribution (non-negative; d-dimensional)
  
Use gen_synthetic_data2.m for synthetic data. Example usage:
>> s = 0.1;
>> alpha = [1; 0.5; 2]; % 3-D example
>> N = 1e5; %Number of customers
>> data = gen_synthetic_data2(N, s, alpha);

----------------------------------------------------------------------------------------------
4. Parameter Fitting:
Requires data in correct format written to a text file.

>> filename = 'sample_data' %2-D dataf
>> [s, alpha, data] = paramLearn_nD(filename, 2); 

The third argument, data just returns the data read from the file 
and is optional.

-------------------------------------------------------------------------------------------
5. Plotting functions:
Contour plots (2-D data only).
plotcon: takes data and plots empirical contours
plotcon_syn: takes FusionRP parameters and plots synthetic contours

--------------------------------------------------------------------------------------------------
6. Anomaly detection:
Usage: detect_outliers(filename, dim)
Prints out POSSIBLE outliers based on FusionRP fit. 
It is conservative, in that it prints out many outliers. 

Procedure:
For each observation x, the algorithm finds:
  - an expected count: lambda
  - lower limit: lower
  - upper limit: upper
Flag x as possible anomaly if lambda does not lie in the interval (lower, upper).

Suggested fix:
Assign each outlier a score based on one of the following measure of deviation:
  - score = abs(x - lambda) / sqrt(lambda) : number of standard deviations from the mean
  - Standard deviations from confidence interval:
    if (lambda > upper); score = (upper - lambda)/sqrt(lambda)
    else if (lambda  < lower); score = (lower - lambda) / sqrt(lambda)
Sort outliers based on the assigned outlier score and consider only the top n outliers.



