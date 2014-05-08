# This is a simple script that compiles the plugin using MXMLC (free & cross-platform).
# To use, make sure you have downloaded and installed the Flex SDK in the following directory:

FLEXPATH=~/developer/SDKs/3.6.0

echo "Compiling with MXMLC..."

$FLEXPATH/bin/mxmlc ../src/as/us/wcweb/Cueboy/Cueboy.as -sp ../src/as -o ../Cueboy.swf -library-path+=../lib -load-externs=../lib/jwplayer-5-classes.xml -use-network=false