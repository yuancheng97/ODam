# Description
* Aimed to work as a reminder for things people store in the fridge.
* Has default expiration date for common food.
* Automatically detects object in photo taken or existing photos in the library.
* Project for LA Hacks 2019, honorary mention for the use of Google Vision API.
* video demo: https://devpost.com/software/odam-jauypb

## Design Ideas
* front end: swift
* back end: firebase
* Image recognition: Google Vision API

## Environment
You need to install cocoapods.

```
$ sudo gem install cocoapods
$ pod setup --verbose
$ cd [directory name]
$ pod init
$ open -a Xcode Podfile

$ pod --version // make sure it's newer than 1.1.1
$ pod install // install dependencies
```

## Features
* scan images from photo library.
* scan images taken using camera.
* default expiration date estimation for common food.
* Customize and add food at ease.

## Contributors
Iris Jiang, Tony Liao, Chenglai Huang, Yuan Cheng, Andy Liu.

