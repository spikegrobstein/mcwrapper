# mcwrapper

A Minecraft Server wrapper for POSIX compatible operating systems (OSX, Linux, BSD, etc).
This enables a Minecraft server admin to easily start and stop their server, send commands
and also do safe, automatic world data backups.

*I'm MC Wrapper and I'm here to say that I wanna wrap up minecraft so everything'll be okay.*

## Install

`mcwrapper` can now be installed via RubyGems.org. To install, simply run the following command:

    gem install mcwrapper

This will install a new executable in your RubyGems installation's `bin` folder. To verify
that it installed properly, you can run:

    mcwrapper --version

This should show your currently installed version.

## Quickstart

If you don't have `minecraft_server.jar` installed on your machine:

    mkdir minecraft_server
    cd minecraft_server
    mcwrapper install
    
Follow the instructions (press enter when prompted). This will download the current version
of `minecraft_server.jar` from Mojang and place it in the correct location.

To start Minecraft Server, `cd` into the directory with `minecraft_server.jar` and execute:

    mcwrapper start

The above will start up a Minecraft server instance using default settings. All support files
related to mcwrapper will be stored in the `minecraft_server.jar` directory.

## Usage

Basic usage is:

    mcwrapper <action> [ <action_params> ]

Use the help action to see a full breakdown of usage:

    mcwrapper help

See the Configuration section below for instructions on modifying the default configuration and
creating an `mcwrapper.config` file.

### Actions

#### help

Also aliased as `--help`, `-h`, and `-?`.

Prints the help screen which includes information about all the built-in commands. Calling
`mcwrapper` without any arguments does the same thing.

#### version

Also aliased as `--version`.

Prints the version of `mcwrapper`.

#### about

Prints information about the program and the author and where to get additional information.

#### start

Starts the Minecraft server if it has not already been started and return to the prompt
immediately. Returns a zero status on success and non-zero if an error occurs. The Minecraft
server process is run in the background as the current user.

See the `status` command for documentation on how to tell if Minecraft is already running.

#### stop

Stops the Minecraft server if it's running.

#### restart

Restarts the Minecraft server by stopping it, then starting it again.

#### status

Checks whether the Minecraft server is running. Returns a zero status code if it's running,
and a non-zero if it's not running.

#### check

Does a sanity check and ensures that `mcwrapper` is configured properly. If the
`minecraft_server.jar` isn't found or some other configuration parameter is improperly
set, it will let you know.

`check` will return a zero status if everything is ok or a non-zero in the result of an error.

#### install

Used to install the Minecraft server from minecraft.net. It will install to the location defined
by the configuration. If `MINECRAFT_SERVER_PATH` is not set, it defaults to the current
directory.

#### update

Update the currently installed `minecraft_server.jar`. If the server is currently running,
`mcwrapper` will stop it, install the new version, renaming the current version to
`minecraft_server.jar.old` and start the new server up.

#### log

Tail the Minecraft server log in real-time. Press ^C to stop it.

#### backup

Backup your world data safely without interruption to anyone connected to the server.

What `backup` does is disable world-data writing, copy and compress the current world data
to the backup directory, then re-enables world-data writing.

#### restore

Restore world data from a previous backup. This cannot be done without interruption to the
users, so when running `restore`, any connected clients will be disconnected.

#### config

The `config` action is used for fetching configuration options for `mcwrapper`. All results
are printed to STDOUT and are designed for use with external scripts.

Usage:

    mcwrapper config <param>

The following are `config` parameters that can be read:

##### serverpath

The value of the `MINECRAFT_SERVER_PATH` configuration parameter. This is the path to the
`minecraft_server.jar`.

##### serverdir

The value of the `MINECRAFT_SERVER_DIR` configuration parameter. This is the path to the
directory that contains `minecraft_server.jar`.

##### pidfile

The path to the .pid file for `mcwrapper`.

##### pid

The pid for the currently running `mcwrapper` instance. If it's not running, it will
return an error with a non-zero status.

##### pipe

The path to the `command_input` FIFO.

##### command

The command that will be used to launch the Minecraft Server.

##### backupdir

The path to the directory for world backups.

##### latestbackup

The path to the latest backup.

##### backup-retention

The number of backups to retain after doing a backup.

#### prop

Used to read properties from the `server.properties` file that is used by the Minecraft
server. This is a convenience action to simplify reading configuration parameters by
external scripts.

Usage:

    mcwrapper prop <prop_name>

Example to read the TCP port that the server is running on:

    mcwrapper prop server-port

#### command

Aliased as `cmd`.

Used for running commands on the minecraft server. This can be used to send chat messages
to players, give players inventory items or kick players.

Example to send a chat message:

    mcwrapper cmd say hi everybody

## Configuration

`mcwrapper` is configured using environment variables, but you can also specify these settings
in a `mcwrapper.conf` file. `mcwrapper` searches for this file, in the following order, in
the following places:

 1. `$MCWRAPPER_CONFIG_PATH` environment variable
 2. `./mcwrapper.conf`
 3. `~/.mcwrapper.conf`
 4. `/etc/mcwrapper.conf`

All parameters that can be set in this file can also be set in your shell's environment either
via using `export` directly or by putting in your `.bashrc` or `.bash_profile`.

The `mcwrapper.conf` file and other configuration is not required as it has sensible defaults
and will try to find the location of `minecraft_server.jar` on its own (starting with the
current directory). An example `mcwrapper.conf-example` file is located in the distribution which
contains documentation and examples of all configuration options.

## Details

When running, `mcwrapper` uses 2 files:

 * `mcwrapper.pid` -- the pid of the currently running process. This is used by `mcwrapper` for
 sanity checks but can also be used by 3rd party scripts to see if `minecraft_server` is running.
 * `command_input` -- the FIFO used for communicating with the server.

The names and locations of the above files are both configurable in `mcwrapper.conf`.

You can run arbitrary commands either through the mcwrapper script as seen in the Quickstart
or you can output commands directly to the `command_input` FIFO. This is handy if you write
re-usable Minecraft scripts.

Examples of working directly with the FIFO:

    echo "tell spizzike you are awesome" > command_input

If you have a file called `gimmie_diamond.mcs` containing the following text:

    give spizzike 264
    give spizzike 264
    give spizzike 264
    give spizzike 264
    give spizzike 264
    give spizzike 264

You can run that all through the Minecraft server with the following command:

    command_input < gimmie_diamond.mcs

## Backing Up Minecraft Data

Since it's not safe to back up the world data while the server is running, you need to force
a save, then disable writing world data to disk during a backup.

`mcwrapper` contains a backup action for just this purpose. To back up your current world data
directory, run the following command:

    mcwrapper backup

`mcwrapper` will read your `server.properties` file to learn the location of your world data
and, after flushing anything in memory, creates a timestamped directory in the minecraft server
directory and creates a symlink to the latest backup called `latest`.

By default, the backup action will simply copy your world data and server configuration (white
lists, server.properties, ban lists, etc) into the backups directory, but it can be configured
to zip or tgz the backup data. See `mcwrapper.conf-example` for information on this.

Assuming your `mcwrapper` lives in `/usr/local/minecraft/mcwrapper`, `backup` will do the
following:

 1. create `/usr/local/minecraft/backups/YYYYMMDDHHMMSS` where YYYYMMDDHHMMSS is the current
 timestamp
 2. copy `/usr/local/minecraft/world` and any other configuration data in `/usr/local/minecraft`
 into the above directory
 3. create a symlink to the latest backup at `/usr/local/minecraft/backups/latest`
 4. delete old backups. Defaults to keeping the latest 5.

The name of the `latest` backup can be configured by editing that setting in `mcwrapper`. You
can also configure how many previous backups are kept. Again, see `mcwrapper.conf-example` for
information on doing this.

## Restoring from a Minecraft backup

If you ever find a need to restore from a previous world data backup, `mcwrapper` now using the
`restore` action and passing a path (full or relative) to the backup you wish to restore:

    mcwrapper restore backups/20111118123456

The above example will perform the following actions:

 1. gracefully stop the Minecraft server if it's running.
 2. do a non-clobbering backup of the current world data. This means that regardless of what
 your backup retention settings are, it will not delete any while creating a backup of the
 current world data.
 3. copy the specified backup directory into the servers's world directory.
 4. start Minecraft server up if it was previously running.

In addition to the above, a file is also created inside the world directory called
`RESTORED_FROM` which contains the argument specified to the `restore` action.

## The Future (Todo List)

In the future I aim to create sysV init scripts for Linux (Ubuntu flavoured) and OSX launchd
configs. I also plan on including Minecraft backup support to SnapBackup, my backup
script (http://github.com/spikegrobstein/snapbackup).

## About

`mcwrapper` is written by Spike Grobstein <me@spike.cx>    
http://sadistech.com    
http://spike.grobste.in    
http://github.com/spikegrobstein
