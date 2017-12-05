## Predicting the next location: a recurrent model with spatial and temporal contexts
[Liu Q, Wu S, Wang L, et al.](https://github.com/charlesliucn/Trajectory-DM/blob/master/Literature/Predicting-the-Next-Location/Predicting%20the%20Next%20Location--A%20Recurrent%20Model%20with%20Spatial%20and%20Temporal.pdf)


#### 1. Introduction
+ FPMC(Factorizing Personalized Markov Chain)
	- sequential prediction & location predication
	- independence assumption among factors

+ TF(Tensor Factorization)
	- time-aware recommendation
	-  modeling spatial temporal information
	- cold start problem

+ RNN(Recurrent Neural Network)
	- word embedding
	- sequential click prediction

+ some intuition:
	- similar interests and demands in short period
	- regular and periodical behavior

+ Spatial Temporal Recurrent Neural Network(ST-RNN)
	- local temporal context
	- recurrent structure to capture periodical context
	- time-specific transition matrices: properties of time intervals
	- distance-specific transition matrices: properties of distances
	- continuous ---> discete bins
	- calculation by linear interpolation in both temporal and spatial context
	
* * * 

#### 2. Related Work: the state-of-the-art methods
+ Factorization Method:
	- Matrix Factorization:
		- collaborative filtering
		- factorize a matrix into two low-rank matrices, the matrix can be approximated by multiplying calculation
		- extended to time-aware and location-aware

	- Tensor Factorization:
		- time bins as another dimension
		- temporal and spatial can be included concurrently

	- time SVD++
		- Collective Factorization
		- Problem: Hard to predict future behaviors(time bins never appearing in training data)

+ Neighborhood Method:
	- Time-aware:
		- giving more relevance to recent observations and less to past ones
		- prediction based on power-law distribution or muti-center gaussian model
		- condsidering use's interest

	- Personalized Ranking Metric Embedding(PRME)
		- Problem: Unable to model the underlying properties in behavior history


+ Markov Chain Method:
	- Estimated transition matrix indicates the probabilty of a behavior(based on past)
	- Factorizing Personalized Markov Chain(FPMC):
		- factorization of probability transition matrix
		- extended by modeling interest-forgetting curve and capturing boredom
		- applied in spatial prediction by using location Constraint(or combining with general MC methods)
		- Problem: assuming all components linearly combined, which is a wrong independent assumption

+ RNN Method:
	- word embedding & sequential click prediction
	- suitable for modeling temporal information
	- Problem：
		* it assumes that temporal dependency changed monotonously along with the position
		*  cannot well model local temporal contexts
		* incapable to model continuous distance and time intervals

* * * 

#### 3. ST-RNN Model

* * * 

#### 4. Parameter Inference:
+ Bayesian Personalized Ranking:
	- assumption: prefer a selected location rather than a negative one
	- maximize the probability

+ Back Propagation Through Time Algorithm

* * *

#### 5. Performance Evaluation:
+ recall
+ F1-Score
+ MAP
+ AUC


