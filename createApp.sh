#!/bin/sh
# shellcheck disable=SC2155
# shellcheck disable=SC2164
# shellcheck disable=SC1091
# shellcheck disable=SC1117

# Checking if user has root access
if [[ $EUID -ne 0 ]]; then
   echo "You must run this script with root permissions."
   exit 0
fi


# Asking for developer ID certificate name
read -p "Enter your Developer ID certificate name: " Certificate

# Asking for version of build
read -p "Enter the version of scilab: "  version

# Checking if the version is already present then removing it
if [ -e ./outputs/app/Scilab-$version.app ]
then
    echo "This version is already present, It will be replaced"
        rm -rf ./outputs/app/Scilab-$version.app
        rm -rf ./outputs/dmg/Scilab-$version-Installer.dmg
fi

# Displaying a start message
echo "Please wait while I make the app"

# Creating a new app
mkdir -p Scilab-$version.app/Contents/MacOS/ Scilab-$version.app/Contents/Resources/

# copying the compiled files from src to resources folder
cp -R ./src/ Scilab-$version.app/Contents/Resources/

# copying the icon from etc to resources folder
cp -R ./etc/puffin.icns Scilab-$version.app/Contents/Resources/

# Copying the Info.plist files
cp -R ./etc/Info.plist Scilab-$version.app/Contents/

# Copying the main starter script
cp -R ./etc/scilab Scilab-$version.app/Contents/MacOS/

# Copying the scilab script which does not require Apple script
cp -R ./etc/bin/scilab Scilab-$version.app/Contents/Resources/bin/

# Removing the checkmacosx.applescript if present
rm -rf Scilab-$version.app/Contents/Resources/bin/checkmacosx.applescript

# Displaying done creation message
echo " I am done creating the app bundle, now I would ask your permission for certificate and begin code-signing"

# Signing all the jars and dylib
find Scilab-$version.app/Contents/ -type f \( -name "*.jar" -or -name "*.dylib" \) -exec codesign --verbose -f -s "$Certificate" {} \;

# Signing all the executable in bin folder
find Scilab-$version.app/Contents/Resources/bin/ -type f \( -name "*"  \) -exec codesign --verbose -f -s "$Certificate" {} \;

# Signing the main starter script in MacOS folder
find Scilab-$version.app/Contents/MacOS/ -type f \( -name "*"  \) -exec codesign --verbose -f -s "$Certificate" {} \;

# Signing the main app
codesign --deep --force --verbose --sign "$certificate"  Scilab-$version.app

# Putting the singned app in output folder
cp -R Scilab-$version.app ./outputs/app/

# Done creating the app and signing it
echo " Signed app bundle is created and it can be found in outputs folder"
echo " Now I will proceed for creating a dmg"

# Putting the singed app forward for dmg creation
cp -R Scilab-$version.app ./createDmg/

# Removing the app from main folder
rm -rf Scilab-$version.app

# Changing to create-dmg folder for creating DMG
cd ./createDmg

# Command to create a DMG
./create-dmg --window-size 381 290 \
 --background backimg.png \
  --icon-size 48 --volname "Scilab" \
  --app-drop-link 280 105 \
  --icon "Scilab-$version.app" 100 105 \
  Scilab-$version-Installer.dmg \
  Scilab-$version.app

# Copying the dmg to output folder
cp -R Scilab-$version-Installer.dmg ./../outputs/dmg/

# Removing the dmg from this folder
rm -rf Scilab-$version-Installer.dmg

# Removing the app from this folder
rm -rf Scilab-$version.app

echo "Congratulation your files are ready in output folder"

exit 0
