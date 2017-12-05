# encoding:UTF-8
import pandas as pd
import numpy as np
from matplotlib import pyplot

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
	trajlength= len(traj)
	return trajlength

def datadist(leninfo, maxlength):
	index = (leninfo['trajlen'] <= maxlength)
	ntraj = len(leninfo[index])
	return ntraj

def markov():
	data = readdata()
	groupdata = groupbyuser(data)
	userID = []
	trajlength = []
	for i,j in groupdata:
		userID.append(i)
		trajlength.append(trajextraction(j))
	usernum = len(userID)
	trajnum = sum(trajlength)
	longestlen = max(trajlength)
	print('---------------------------------------------')
	print('The number of users: %d' % usernum)
	print('---------------------------------------------')
	print('The number of trajectories:  %d' % trajnum)
	print('---------------------------------------------')
	print('The length of the longest trajectory:  %d' % longestlen)
	print('---------------------------------------------')
	leninfo = pd.DataFrame({'userID':userID,'trajlen':trajlength})
	mark = range(1,longestlen+20,20)
	partnum = []
	prop = []
	for j in mark:
		partnum.append(datadist(leninfo,j))
		p = float(datadist(leninfo,j))/float(usernum)
		prop.append(p)
	dist = pd.DataFrame({'MaxLength':mark,'NumofTraj':partnum,'Proportion':prop})
	print('The Distribution of the trajectory lengths:')
	print(dist)
	print('---------------------------------------------')
	# plot of trajectories shorter than 100
	num_bins = 400
	pyplot.hist(trajlength,num_bins)
	pyplot.xlabel('The length of trajectories')
	pyplot.xlim(0,100)
	pyplot.ylabel('Frequency')
	pyplot.title('The Distribution of Length of Trajectories')
	pyplot.show()

if __name__ == '__main__':
	markov()
