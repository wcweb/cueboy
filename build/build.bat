:: This is a simple script that compiles the plugin using the free Flex SDK on Windows.
:: Learn more at http://developer.longtailvideo.com/trac/wiki/PluginsCompiling

SET FLEXPATH="E:\document\actionscript\flex_sdk_4.6"

echo "Compiling player 5 plugin..Cueboy."

%FLEXPATH%\bin\mxmlc ..\src\as\us\wcweb\Cueboy\Cueboy.as -sp ..\src\as -o ..\cueboy.swf -library-path+=..\lib -load-externs=..\lib\jwplayer-5-classes.xml -use-network=false -static-link-runtime-shared-libraries=true -optimize=true