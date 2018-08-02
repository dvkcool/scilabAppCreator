# Creating a Signed Mac Application for Scilab
This project is part of Google Summer Of Code (GSoC) 2018 with Scilab.

## Pre-requisites
1. Compiled Scilab files.
2. A Developer ID issued by Apple.

## Major Changes at a glance
1. All the compiled code is moved to Resources folder.(the script manages the work of moving files to correct places you don't need to worry.)\
A new Info.plist file which is created according to the version number, I created a new Info.plist because the one available as a thirdparty was not in accordance with Apple Guidelines.\
2. Removal of checkmacosx.applescript, this file was an outdated apple script which creates error while codesigning. I did incorporate the applescript part in the scilab starter script with osascript - a modernly to use AppleScript features through shell script.

## Procedure
1. Download my project from github using following command.\
    `git clone https://github.com/dvkcool/scilabAppCreator.git`
2. Paste the scilab compiled files in the src folder of my project.
3. Run the main shell script, using `sudo sh createApp.sh`
4. Answer the questions like build version and signing key.\

_____________________________________________________________________________________________________________

Congratulations you have your DMG created in outputs folder of the project.<br>
You don't need to worry about anythig including the folder structure, the script takes care of everything and creates a nice Ready to Distribute dmg.

## Video Demo
https://youtu.be/VjRfisq-1pA


## Bugs/Doubts
Feel free to open an issue or mail me at divyanshukumarg@gmail.com

## Demo output
A compiled dmg for Scilab 6.0 can be found here: https://drive.google.com/open?id=1Gl4dRngHxGvSTOHOg_U8GX4yJlSu4LZU

_____________________________________________________________________________________________________________
Happy Coding
_____________________________________________________________________________________________________________
Divyanshu Kumar
