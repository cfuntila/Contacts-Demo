# AvatarView

Easy to use view for displaying avatars.

### Usage

```swift
import AvatarView

override func viewDidLoad {
  super.viewDidLoad()

  // Create the avatar view
  avatarView = AvatarView(image: UIImage(named: "avatar")!)
  avatarView.center = view.center
  view.addSubview(avatarView)
}
```

#### Demo
To get a grasp you can download the [zip](https://github.com/chrene/AvatarView/archive/master.zip) and tryout the demo

![Demo](http://i.imgur.com/jTvMjIz.png "Demo Screenshot")

## Installation

### Manual
1. Download the [zip](https://github.com/chrene/AvatarView/archive/master.zip)
2. Unpack
3. Drag `AvatarView/AvatarView.swift` into your project

### Carthage

If you are new to [Carthage](https://github.com/Carthage/Carthage) you can find info [here](https://github.com/Carthage/Carthage)

*from 1.0.0 and upwards swift 2.0 is needed*

1. insert `github "chrene/AvatarView" ~> 1.0.0` into the **Cartfile**
2. run `carthage update`
3. copy the `AvatarView.framework` into your project. Make sure to uncheck 'Copy items if needed'
4. Update your build phases to copy the framework. If in doubt on how to do this, please check the [carthage documentation](https://github.com/Carthage/Carthage)

### LICENSE
[The MIT License](https://github.com/chrene/AvatarView/blob/master/LICENSE)
