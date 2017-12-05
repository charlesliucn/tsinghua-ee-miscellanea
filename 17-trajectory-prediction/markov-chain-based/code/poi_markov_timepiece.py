# encoding:UTF-8

"""
Trajectory prediction based on Markov Chain model using POI.
"""

import numpy as np
import pandas as pd
import time

FILENAME = "tweets.txt"

def readdata():
	userID = []
	POI = []
	timestamp = []
	date = []
	with open(FILENAME) as file:
		for line in file:
			ID, user, lat, lon, timestr, unknown, ad, share, poiuser= line.split("",9)
			if isvalidtime(timestr):
				userID.append(int(user))
				POI.append(poiuser)
				timestamp.append(timestr)
				date.append(timestr[0:10])	
	# keep the useful data
	data = pd.DataFrame({'userID':userID,'date':date,'timestamp':timestamp,'POI':POI})
	return data

def isvalidtime(timestr):
	try:
		time.strptime(timestr,"%Y-%m-%d %H:%M:%S")
		return True
	except:
		return False

def groupbyuser(data):
	# the data is grouped by userID
	groupdata = data.groupby(['userID','date'])
	return groupdata

def markov():
	data = readdata()
	groupdata = groupbyuser(data)
	length = []
	for i, j in groupdata:
		print('----------------------------')
		print('userID & Date:',i)
		print(j)
		length.append(len(j))
	MAXLEN = max(length)
	print('max length:', MAXLEN)

if __name__ == '__main__':
	markov()
