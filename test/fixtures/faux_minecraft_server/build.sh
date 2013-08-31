#! /bin/bash -

javac InputLoop.java
jar -cfm faux_minecraft_server.jar Manifest.txt InputLoop.class

