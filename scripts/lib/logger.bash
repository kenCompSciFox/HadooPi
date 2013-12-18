# logger shell utility functions
# Directs output to a specified log file in a standard format
#

# sets the logfile name
function set_logfile_name {
	if [ -n "$1" ]
    	then
		LOGFILE_NAME=$1
		return 0
	fi

}


# Change the logfile date format from the default of YYMMDD HH:MM:SS
# you are responsible for making sure the format is valid
function set_date_format {
	if [ -n "$1" ]
    	then
		LOGFILE_DATE_FORMAT=$1
		return 0
	fi
}

function default_logfile {
	LOGFILE_NAME=${LOGPATH}"/"${LOGFILE_BASENAME}-${LOGDATE}.log
	echo ${LOGFILE_NAME}
	return 0
}



# basic formatted log entry - need to spice this up a little later on
# will print all arguments passed to it along with a formatted date
# should do nothing of passed an empty string
# USAGE: log_entry DEBUG this is a debugging message
function log_entry {

	if [ -n "$1" ]
	then
		ENTRY=`date +"${LOGFILE_DATE_FORMAT}"`": "
     		for var in "$@"
		do
			ENTRY=${ENTRY}${var}" "
		done
		echo ${ENTRY} >> ${LOGFILE_NAME}
	fi
}
