#!/bin/awk -f

# (c) vivus-ignis, http://my.opera.com/vivus-ignis/blog/

BEGIN {
	#DEBUG = 1
	host="127.0.0.1"
	port="6379"
	_ORS = ORS
	RS = ORS = "\r\n"
	Redis = "/inet/tcp/0/"host"/"port
	split("set setnx rpush lpush lset lrem sadd srem sismember echo getset smove zadd zrem zscore zincrby",BulkCmds)
	split("mset msetnx",MultiBulkCmds)
}

# -- arange
#
#	returns a string containing array elements range
#	for stop param it is allowed to give "end" value
#
# Args:
#	array -- array
#	start -- first index of range
#	stop -- last index of range
#
function arange(array,start,stop) {
	if(stop == end) { stop=alast(array) }
	k=0
	for (i=start;i<=stop;i++) { 
		if(k>0) { result = result" "array[i] } else { result=array[i] }
		k++
	}
	return result

}

# -- alast
#
#	returns last array element index
#
function alast(array) {
	arrcnt=0
	for(i in array) { arrcnt++}
	return arrcnt
}

# -- asearch
#
#	returns 1 if an array has an element with given value,
#	returns 0 otherwise
#
# Args:
#	array -- array
#	value -- element value to search for
#
function asearch(array,value) {
	for(i in array) { if(array[i] == value) return 1 }
	return 0
}

{

	if (DEBUG == 1) print "D: cmdline params: " $0 
	split($0,CmdArray)
	Operator=CmdArray[1]

	if ((asearch(BulkCmds,Operator)) == 1) {
		if (DEBUG == 1) print "D: bulk command"
		Key=CmdArray[2]
		Args=arange(CmdArray,3,end)
		ValueLength=length(Args) 
		Args=Key" "ValueLength"\r\n"Args
		Cmd=Operator" "Args
	}
	else if ((asearch(MultiBulkCmds,Operator)) == 1) {
		if (DEBUG == 1) print "D: multibulk command"
		Args=arange(CmdArray,2,end)
		split(Args,ArgsArray)
		Cmd="*"(alast(ArgsArray) + 1)"\r\n$"length(Operator)"\r\n"Operator"\r\n"
		ArgsArrayLength=alast(ArgsArray)
		for(i=1;i<=ArgsArrayLength;i++) {
			if (DEBUG == 1) print "D: i = "i" ArgsArray[i] ="ArgsArray[i]
			Cmd=Cmd"$"(length(ArgsArray[i]))"\r\n"ArgsArray[i]"\r\n"
		}
	}
	else {
		if (DEBUG == 1) print "D: inline command"
		Args=arange(CmdArray,2,end)
		Cmd=Operator" "Args
	}
	if (DEBUG == 1) print "D: <command>"Cmd"</command>"
	print Cmd |& Redis

	# reading response
	Redis |& getline
	if((substr($0,1,1)) == "+" ) { 
		if (DEBUG == 1) print "D: reply: OK ("$0")"
		exit 0 
	}
	if((substr($0,1,1)) == "-" ) { 
		if (DEBUG == 1) print "D: reply: Error ("$0")"
		exit 1 
	}
	if((substr($0,1,1)) == ":" ) { 
		if (DEBUG == 1 ) print "D: reply: integer ("$0")"
		ORS = _ORS
		print(substr($0,2))
		ORS = RS
	}
	if((substr($0,1,1)) == "$" ) {
		if (DEBUG == 1) print "D: reply: bulk ("$0")"
		if ($0 == "$-1") {
			# no such key
			ORS = _ORS
			print "(nil)"
			ORS = RS
		} else {
			Redis |& getline
			ORS = _ORS
			print $0
			ORS = RS
		}
	}
	if((substr($0,1,1)) == "*" ) {
		if (DEBUG == 1) print "D: reply: multibulk ("$0")"
		Cycles=substr($0,2)
		for(i=1;i<=Cycles;i++) {
			Redis |& getline
			if ($0 == "$-1") {
				if(i>1) { Response = Response" (nil)" } else { Response="(nil)" }
			} else {
				Redis |& getline
				if(i>1) { Response = Response" "$0 } else { Response=$0 }
			}
			if (DEBUG == 1) print "D: i="i" Response: "Response
		}
		ORS = _ORS
		print Response
		ORS = RS
	}
}
END { close(Redis) }

