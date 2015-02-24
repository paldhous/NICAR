
infile = open("HURDAT2.txt","r")
outfile = open("storms_raw.csv","w")

header = "name,year,month,day,hour,minute,timestamp,record_ident,status,latitude,longitude,max_wind_kts,max_wind_kph,max_wind_mph,min_press\n"
outfile.write(header)

n=1

for line in infile:
	if line[0:2] == "AL":
		name = line.split()[1]
		name = name.title()[:-1]
		if name == "Unnamed":
			name = "Unnamed "+str(n)
			n += 1
	else:
		year = line[0:4]
		month = line[4:6]
		day = line[6:8]
		hour = line[10:12]
		minute = line[12:14]
		timestamp = year+"-"+month+"-"+day+" "+hour+":"+minute 
		record_ident = line[16]
		status = line[19:21]
		latitude = line[23:27]
		n_s = line[27]
		if n_s == "S":
			latitude = str(-1*float(latitude))
		longitude = line[30:35]
		w_e = line[35]
		if w_e == "W":
			longitude = str(-1*float(longitude))
		max_wind_kts = line[38:41]
		if max_wind_kts == "-99":
			max_wind_kts = ""
			max_wind_kmh = ""
			max_wind_mph = ""
		else:
			max_wind_kmh = str(int(round(1.852*float(max_wind_kts))))
			max_wind_mph = str(int(round(1.1507794*float(max_wind_kts))))
		min_press = line[43:47]
		if min_press == "-999":
			min_press = ""

		output = name+","+year+","+month+","+day+ ","+hour+","+minute+","+timestamp+","+record_ident+","+status+","+latitude+","+longitude+","+max_wind_kts+","+max_wind_kmh+","+max_wind_mph+","+min_press+"\n"
		outfile.write(output)
		print "Processing storm: "+name+" - "+timestamp

outfile.close()

print "Done!"
