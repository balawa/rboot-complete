Introduction
------------
This project contains all the necessary files for creating and running rboot on ESP8266. 
Current setting is for ESP-01 512K version.
You can change the setting by changing the flash size in Makefile.


To compile
----------
1) Edit the Makefile to set the paths to the SDK.
2) Set WIFI_SSID & WIFI_PWD as env vars or in the makefile.
3) Set OTA server details in rboot-sample/rboot-ota.h
2) Run make.
3) esptool2, rboot, rboot-sample will be compiled. 
4) Run make check to find if all files are generated.
5) make flash 
6) Connect a terminal and type 'help'.
7) Run webserver, as below
8) type ota in serial terminal


Running webserver.
cd rboot-sample
python -m SimpleHTTPServer

Press Ctrl+C to quit.

NOTE
----

Tested with SDK v1.3 on an ESP01
change in rboot-sample/rom1.ld for >512KB flash, as below
irom0_0_seg :                         org = 0x40282010, len = 0x3C000


Thanks
------
My source is gathered and edited from GitHub: https://github.com/raburton/esptool2
https://github.com/raburton/rboot
https://github.com/raburton/rboot-sample

Urmil Parikh from Klar Systems. http://zmote.io