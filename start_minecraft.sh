#! /bin/bash

# get the settings
. mcwrapper.conf

function read_pipe {
	# read from the command pipe
	exec < $COMMAND_PIPE
	
	read INPUT
	echo $INPUT
	
	# if the user said "stop" then exit after the command completes.
	if [[ "$INPUT" = "stop" ]]; then
		exit 0
	fi
	
	# recurse
	read_pipe
}

function set_up_pipe {
	if [[ ! -p "$COMMAND_PIPE" ]]; then
		echo "Pipe doesn't exist, creating it..."
		mkfifo $COMMAND_PIPE
	fi
}

read_pipe | $MINECRAFT_SERVER_CMD	
