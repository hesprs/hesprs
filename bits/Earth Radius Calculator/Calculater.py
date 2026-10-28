import numpy as np
lat1 = np.radians(float(input('Give the latitude of the first spot: ')))
lat2 = np.radians(float(input('Give the latitude of the second spot: ')))
lon1 = np.radians(float(input('Give the longitude of the first spot: ')))
lon2 = np.radians(float(input('Give the longitude of the second spot: ')))
d = float(input('Give the kilometre distance between two spots: '))
dlat = lat2 - lat1
dlon = lon2 - lon1
r = d / (np.arccos(np.sin(lat1) * np.sin(lat2) + np.cos(lat1) * np.cos(lat2) * np.cos(lon1 - lon2)))
print("Radius of the earth: " + str(r) + " kilometers.")