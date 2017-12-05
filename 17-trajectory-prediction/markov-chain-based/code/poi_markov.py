# encoding:UTF-8

"""
Trajectory prediction based on Markov Chain model using POI.
"""

import numpy as np
import pandas as pd

FILENAME = "tweets.txt"

def readdata():
	userID = []
	POI = []
	with open(FILENAME) as file:
		for line in file:
			ID, user, lat, lon, time, unknown, ad, share, poiuser= line.split("",9)
			userID.append(int(user))
			POI.append(poiuser)
	# keep the useful data
	data = pd.DataFrame({'userID':userID,'POI':POI})
	return data

def groupbyuser(data):
	# the data is grouped by userID
	groupdata = data.groupby(data['userID'])
	return groupdata

def trajextraction(trajdata):
	# the trajectory data is ordered by time for each user
	traj = np.array(trajdata)
	trajbytime = []
	totalnum = len(traj)
	for i in range(totalnum):
		poi = traj[i][0]
		trajbytime.append([poi])
	return trajbytime

def transitionmatrix(trajbytime,minnumpoint):
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
	# print(groupdata)
	minnumpoint = [1,10,20,50]
	for m in minnumpoint:
		correctnum = 0 # the number of correct prediction
		usernum_valid = 0 # the number of total valid predictions
		usernum_ttl = 0 # the total number of users
		for i,j in groupdata:
			usernum_ttl = usernum_ttl + 1
			# print('--------------------')
			# print('User ID: %d' % i)
			trajbytime= trajextraction(j)
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
		print('The number of users(vaild):')
		print(usernum_valid)
		print('The number of correct predicitions:')
		print(correctnum)
		print('The prediction of Markov Chain based method:')
		precision = float(correctnum)/float(usernum_valid)
		print(precision)

if __name__ == '__main__':
	markov()
