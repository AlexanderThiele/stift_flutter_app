#!/bin/bash
echo "Upload symbols manually"
./ios/Pods/FirebaseCrashlytics/upload-symbols -gsp ./ios/Runner/GoogleService-Info.plist -p ios ./build/ios/archive/Runner.xcarchive/dSYMs

