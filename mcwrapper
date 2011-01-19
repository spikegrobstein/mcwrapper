#! /bin/bash

MINECRAFT_SERVER_PATH="/Users/spike/minecraft/minecraft_server.jar"
MX_SIZE="1024M"
MS_SIZE="1024M"

MINECRAFT_SERVER_CMD="java -Xmx${MX_SIZE} -Xms${MS_SIZE} -jar $MINECRAFT_SERVER_PATH nogui"

COMMAND_PIPE="command_input"

# END CONFIGURATION SETTINGS ############
#########################################

function read_command {
	# read from the command pipe
	exec < $COMMAND_PIPE
	
	read INPUT
	echo $INPUT
	
	# if the user said "stop" then exit after the command completes.
	if [[ "$INPUT" = "stop" ]]; then
		exit 0
	fi
	
	# recurse
	read_command
}

function set_up_pipe {
	if [[ ! -p "$COMMAND_PIPE" ]]; then
		echo "Pipe doesn't exist, creating it..."
		mkfifo $COMMAND_PIPE
	fi
}

read_command | $MINECRAFT_SERVER_CMD	
