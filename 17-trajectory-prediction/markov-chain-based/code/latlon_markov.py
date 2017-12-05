# encoding:UTF-8

"""
Trajectory prediction based on Markov Chain model 
using the data of latitude(lat) and longitude(lon).
Each point in a trajectory includes lat and lon.

markov() is the main function, the parameters are:
	minnumpoint	: the minute number of the points 
				 in a single trajectory
 	nkeep	   	: the number of decimal digits of 
 				 the lat and lon data.
""" 

import numpy as np
import pandas as pd

FILENAME = "tweets_latlon.txt"

def readdata():
	userID = []
	latitude = []
	longitude = []
	with open(FILENAME) as file:
		for line in file:
			ID, user, lat, lon, _ = line.split("",4)
			userID.append(int(user))
			latitude.append(lat)
			longitude.append(lon)
	# keep the useful data
	data = pd.DataFrame({'userID':userID,'lat':latitude,'lon':longitude})
	return data

def groupbyuser(data):
	# the data is grouped by userID
	groupdata = data.groupby(data['userID'])
	return groupdata

def trajextraction(trajdata,nkeep):
	# the trajectory data is ordered by time for each user
	traj = np.array(trajdata)
	trajbytime = []
	totalnum = len(traj)
	for i in range(totalnum):
		lat = float(traj[i][0])
		lon = float(traj[i][1])
		trajbytime.append([round(lat+lon,nkeep)])
	return trajbytime

def transitionmatrix(trajbytime, minnumpoint):
	# compute the transition matrix for each user
	trajbytime = np.array(trajbytime)
	totalnum = len(trajbytime)
	# some user have only 1 data
	# we think it useless
	if totalnum > minnumpoint: 
		traindata = trajbytime[0:-1]
		testdata = trajbytime[-1]
		trainnum= len(traindata)
		uniq, indices = np.unique(traindata, return_inverse = True)
		uniqnum = len(uniq)
		transmatrix = np.zeros((uniqnum,uniqnum))
		for i in range(trainnum-1):
			transmatrix[indices[i]][indices[i+1]] = transmatrix[indices[i]][indices[i+1]] + 1
		for i in range(uniqnum):
			if(sum(transmatrix[i]) != 0):
				transmatrix[i] = transmatrix[i]/sum(transmatrix[i])
		usereff =  1 # the user is not used for prediction
		return transmatrix, testdata, uniq, indices, trainnum, usereff
	else:
		transmatrix = []
		testdata = []
		uniq = []
		indices = []
		trainnum = []
		usereff =  0
		return transmatrix, testdata, uniq, indices, trainnum, usereff

def trajprediction(transmatrix, uniq, indices, trainnum):
	# prediction based on the computed Markov transition matrices
	if transmatrix != []:
		last = transmatrix[indices[trainnum-1]]
		maxindex = np.where(last == max(last))
		pred = uniq[maxindex]
		return list(pred)
	else:
		return [0] # no prediciton

def judge(testdata,pred):
	if testdata in pred: # prediction correctly
		return 1
	else:
		return 0

def markov():
	data = readdata()
	# print(data)
	groupdata = groupbyuser(data)
	nkeep = [4,3,2,1]
	minnumpoint = [1,10,20,50]
	for n in nkeep:
		for m in minnumpoint:
			correctnum = 0 # the number of correct prediction
			usernum_valid = 0 # the number of total valid predictions
			usernum_ttl = 0 # the total number of users
			for i,j in groupdata:
				usernum_ttl = usernum_ttl + 1
				# print('--------------------')
				# print('User ID: %d' % i)
				trajbytime= trajextraction(j,n)
				transmatrix, testdata, uniq, indices, trainnum, usereff = transitionmatrix(trajbytime,m)
				if usereff: usernum_valid = usernum_valid + 1
				pred = trajprediction(transmatrix, uniq, indices,trainnum)
				singlejudge = judge(testdata,pred)
				# if singlejudge: print('Correct!') 
				# else: print('Wrong!')
				if singlejudge == 1:
					correctnum = correctnum + 1
			print('==========================')
			print('The number of users(total):')
			print(usernum_ttl)
			print('The number of users(valid):')
			print(usernum_valid)
			print('The number of correct predictions:')
			print(correctnum)
			print('The prediction of Markov Chain based method:')
			precision = float(correctnum)/float(usernum_valid)
			print(precision)


if __name__ == '__main__':
	markov()