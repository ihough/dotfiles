#!/usr/bin/env zsh

# Based on https://github.com/mathiasbynens/dotfiles/blob/main/.macos

# Backup current settings
echo "Backing up current macOS settings in $(pwd)/.bak/"
echo "macOS may request permissions to read current defaults."
mkdir -p .bak
now=$(date -Iseconds | sed s/://g)
defaults read > .bak/defaults_$now
defaults -currentHost read > .bak/defaults-currentHost_$now
pmset -g custom > .bak/pmset-$now
unset now
echo "Backup complete"

# Close any open System Preferences panes, to prevent them from overriding
# settings we're about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


###############################################################################
# Computer name                                                               #
###############################################################################

# Ask to set computer name (as done via System Preferences → Sharing)
if read -q "reply?${1:-Change computer name ($(scutil --get ComputerName))? [y/N] }"; then
  echo
  read "computer?Enter new name: "
  sudo scutil --set ComputerName $computer
  sudo scutil --set HostName $computer
  sudo scutil --set LocalHostName $computer
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$computer"
  echo "Computer name is '$(scutil --get ComputerName)'"
else
  echo
fi


###############################################################################
# General UI/UX                                                               #
###############################################################################

echo "Configuring General UI/UX"

# Set language and text formats
defaults write -globalDomain AppleLanguages -array "en-IE" "fr-FR"
defaults write -globalDomain AppleLocale -string "en_FR"
defaults write -globalDomain AppleICUDateFormatStrings -dict \
  1 -string "y-MM-dd"
defaults write -globalDomain AppleICUNumberSymbols -dict \
  0 -string "." \
  1 -string " " \
  10 -string "." \
  17 -string " "

# Automatically hide scrollbars
defaults write -globalDomain AppleShowScrollBars -string "Automatic"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

# Disable automatic capitalization as it's annoying when typing code
defaults write -globalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they're annoying when typing code
defaults write -globalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it's annoying when typing code
defaults write -globalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they're annoying when typing code
defaults write -globalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Display ASCII control characters using caret notation in standard text views
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write -globalDomain NSTextShowsControlCharacters -bool true

# Adjust toolbar title rollover delay (default 0.5)
defaults write -globalDomain NSToolbarTitleViewRolloverDelay -float 0.2

# # Expand save panel by default
# defaults write -globalDomain NSNavPanelExpandedStateForSaveMode -bool true
# defaults write -globalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# # Expand print panel by default
# defaults write -globalDomain PMPrintingExpandedStateForPrint -bool true
# defaults write -globalDomain PMPrintingExpandedStateForPrint2 -bool true

# # Disable the “Are you sure you want to open this application?” dialog
# defaults write com.apple.LaunchServices LSQuarantine -bool false

# Require password immediately after sleep or screen saver begins
# Since macOS 10.13 must use a profile to configure ask for password delay


###############################################################################
# Trackpad, Mouse, and Keyboard                                               #
###############################################################################

echo "Configuring Trackpad, Mouse, and Keyboard"

# Disable swipe between pages
defaults write -globalDomain AppleEnableSwipeNavigateWithScrolls -bool false
defaults write -globalDomain AppleEnableMouseSwipeNavigateWithScrolls -bool false

# Disable “natural” (Lion-style) scrolling
defaults write -globalDomain com.apple.swipescrolldirection -bool false

# Trackpad: enable tap to click for this user and for the login screen
defaults write -globalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write -globalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Trackpad: tap or click with two fingers for secondary click
defaults -currentHost write -globalDomain com.apple.trackpad.enableSecondaryClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true

# # Trackpad: Disable force click and look up
# defaults write -globalDomain com.apple.trackpad.forceClick -bool false
# defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -bool false
# defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool true

# Mouse: enable right click for secondary click
defaults write com.apple.AppleMultitouchMouse MouseButtonMode -string "TwoButton"
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string "TwoButton"

# Keyboard: disable press-and-hold to show accents menu in favour of key repeat
defaults write -globalDomain ApplePressAndHoldEnabled -bool false

# Keyboard: set a fast repeat rate
defaults write -globalDomain KeyRepeat -int 2

# Keyboard: set a short delay until key repeat
defaults write -globalDomain InitialKeyRepeat -int 12

# Keyboard: use F1, F2, etc. as standard function keys
defaults write -globalDomain com.apple.keyboard.fnState -bool true


###############################################################################
# Energy Saving                                                               #
###############################################################################

echo "Configuring Energy Saving"

# Sleep the display after 2 minutes on battery, 10 minutes on charger
sudo pmset -b displaysleep 2
sudo pmset -c displaysleep 10


###############################################################################
# Dock and Hot Corners                                                        #
###############################################################################

echo "Configuring Dock and Hot Corners"

# Dock: automatically hide and show
defaults write com.apple.dock autohide -bool true

# Dock: reduce the auto-hiding delay (default 0.2)
defaults write com.apple.dock autohide-delay -float 0.1

# Hot Corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
# Top right screen corner → Desktop
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0


###############################################################################
# Finder and Desktop                                                          #
###############################################################################

echo "Configuring Finder and Desktop"

# Finder: show all filename extensions
defaults write -globalDomain AppleShowAllExtensions -bool true

# Finder: enable spring loading for directories
defaults write -globalDomain com.apple.springing.enabled -bool true

# Finder: reduce the spring loading delay for directories
defaults write -globalDomain com.apple.springing.delay -float 0.25

# Finder: avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# # Finder: show hidden files (toggle on/off with command+shift+period)
# defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Finder: keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Finder: search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Finder: disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Finder: expand the following File Info panes:
# “General”, "Name", “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  Name -bool true \
  OpenWith -bool true \
  Privileges -bool true

# # Finder: use list view in all windows by default
# # Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
# defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Finder: set home as the default location for new windows
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Finder: customize the toolbar
# Back / Path / View / Group / Preview / Flexible Space / Get Info / Action / Flexible Space / Search
/usr/libexec/PlistBuddy -c "Set :'NSToolbar Configuration Browser':'TB Display Mode' 2" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :'NSToolbar Configuration Browser':'TB Item Identifiers':0 com.apple.finder.BACK"  ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :'NSToolbar Configuration Browser':'TB Item Identifiers':1 com.apple.finder.PATH"  ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :'NSToolbar Configuration Browser':'TB Item Identifiers':2 com.apple.finder.SWCH"  ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :'NSToolbar Configuration Browser':'TB Item Identifiers':3 com.apple.finder.ARNG"  ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :'NSToolbar Configuration Browser':'TB Item Identifiers':4 com.apple.finder.PTGL"  ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :'NSToolbar Configuration Browser':'TB Item Identifiers':5 NSToolbarFlexibleSpaceItem"  ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :'NSToolbar Configuration Browser':'TB Item Identifiers':6 com.apple.finder.INFO"  ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :'NSToolbar Configuration Browser':'TB Item Identifiers':7 com.apple.finder.ACTN"  ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :'NSToolbar Configuration Browser':'TB Item Identifiers':8 NSToolbarFlexibleSpaceItem"  ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :'NSToolbar Configuration Browser':'TB Item Identifiers':9 com.apple.finder.SRCH"  ~/Library/Preferences/com.apple.finder.plist

# # Finder: automatically open a new window when a volume is mounted
# defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
# defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
# defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# # Finder: show status bar
# defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show icons on the desktop for hard drives, servers, and removable media
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# # Finder: show item info near icons on the desktop and in other icon views
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Finder: enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Finder: show the ~/Library folder
chflags nohidden ~/Library

# # Finder: show the /Volumes folder
# sudo chflags nohidden /Volumes


###############################################################################
# Screenshots                                                                 #
###############################################################################

echo "Configuring Screenshots"

# Screenshots: save to ~/Documents/Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Documents/Screenshots"


###############################################################################
# Sublime Text                                                                #
###############################################################################

# Sublime Text: sync settings using Google Drive
subl_local_dir="$HOME/Library/Application Support/Sublime Text/Packages/User"
subl_sync_dir="$HOME/Gdrive/computers/settings/sublime/User"
if [ -d "$HOME/Library/Application Support/Sublime Text" ]; then
  if [ -d $subl_sync_dir ]; then
    echo "Syncing Sublime Text settings with Google Drive."
    if [ -d $subl_local_dir ]; then
      rm -r $subl_local_dir
    fi
    ln -is $subl_sync_dir $subl_local_dir
  else
    echo "Could not sync Sublime Text settings. No such folder: $subl_sync_dir"
  fi
fi

# Sublime Text: set as default app for public.plain-text and public.data files
defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add '{LSHandlerContentType=public.plain-text;LSHandlerRoleAll=com.sublimetext.4;}'


###############################################################################
# TextEdit                                                                    #
###############################################################################

echo "Configuring TextEdit"

# TextEdit: use plain text as default format
defaults write com.apple.TextEdit RichText -bool false

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4


###############################################################################
# Kill affected applications                                                  #
###############################################################################

echo "Restarting apps"

for app in "Activity Monitor" \
  "Address Book" \
  "Calendar" \
  "cfprefsd" \
  "Contacts" \
  "Dock" \
  "Finder" \
  "Google Chrome" \
  "Mail" \
  "Messages" \
  "Photos" \
  "Safari" \
  "SystemUIServer" \
  "Terminal" \
  "Transmission" \
  "iCal"; do
  killall "${app}" &> /dev/null
done

echo "Done. Note that some of these changes require a logout/restart to take effect."
