# mcwrapper

A Minecraft Server wrapper. This enables a Minecraft server admin to easily start a server and send commands and also do safe, automatic backups.

*I'm MC Wrapper and I'm here to say that I wanna wrap up minecraft so everything'll be okay.*

## Quickstart

To use `mcwrapper`, first open `mcwrapper` in your text editor of choice (eg TextMate, `vim`). At the top of the file are configuration parameters. You should set them to their necessary values. The important one is `MINECRAFT_SERVER_PATH` which is the path to the minecraft_server.jar on your filesystem.

When running, `mcwrapper` will use the directory that contains your minecraft_server.jar file to store it's necessary files along with the server's world data.

Once you have the script properly configured, you can start the server by running the following:

    ./mcwrapper start
    
After that, you can execute arbitrary commands to the server:

    ./mcwrapper op spizzike
    ./mcwrapper save-all
    ./mcwrapper save-off
    ./mcwrapper save-on

If you'd like to stop the server, issue the following:

    ./mcwrapper stop
    
You can also find out whether the server is running:

    ./mcwrapper status
    
The status action will return 0 if the server is running or 1 if it's stopped.

## Details

When running, `mcwrapper` creates 2 files:

 * mcwrapper.pid -- the pid of the currently running process. This is used by `mcwrapper` for sanity checks but can also be used by 3rd party scripts to see if minecraft_server is running.
 * command_input -- the FIFO used for communicating with the server.
 
The names of the above files are both configurable using the variables at the top of `mcwrapper`

You can run arbitrary commands either through the mcwrapper script as seen in the Quickstart or you can output commands directly to the command_input FIFO. This is handy if you write re-usable Minecraft scripts.

Examples of working directly with the FIFO:

    echo "tell spizzike you are awesome" > command_input

If you have a file called "gimmie_diamond.mcs" containing the following text:

    give spizzike 264
    give spizzike 264
    give spizzike 264
    give spizzike 264
    give spizzike 264
    give spizzike 264

You can run that all through the Minecraft server with the following command:

    command_input < gimmie_diamond.mcs

## Backing Up Minecraft Data

Since it's not safe to back up the world data while the server is running, you need to force a save, then disable writing world data to disk during a backup.

This is done by issuing the following commands:

    ./mcwrapper save-all
    ./mcwrapper save-off
    # at this point, do the backup
    ./mcwrapper save-on
    
## The Future (Todo List)

In the future I aim to create sysV init scripts for Linux (Ubuntu flavoured) and OSX launchd configs. I also plan on including Minecraft backup support to SnapBackup, my backup script (http://github.com/spikegrobstein/snapbackup).

## About

`mcwrapper` is written by Spike Grobstein <spikegrobstein@mac.com>    
http://sadistech.com    
http://spike.grobste.in    
http://github.com/spikegrobstein