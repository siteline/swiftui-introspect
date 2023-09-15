xcodebuild -scheme "SimulatorStatusMagicDlib" -sdk iphonesimulator -derivedDataPath build
xcrun simctl spawn $1 launchctl debug system/com.apple.SpringBoard --environment DYLD_INSERT_LIBRARIES="$PWD/build/Build/Products/Debug-iphonesimulator/libSimulatorStatusMagicDlib.dylib"
xcrun simctl spawn $1 launchctl stop com.apple.SpringBoard
