# WMAutoScrollView
An infinite loop ScrollView

How to use WMAutoScrollView?
==
First,you need to be initialized.
if you want to make images with image name.
```objective-c
- (instancetype _Nullable )initWMAutoScrollViewWithFrame:(CGRect)rect imageArray:(NSArray * _Nonnull)imageArray;
```
if you want to make images with url.
```objective-c
- (instancetype _Nullable )initWMAutoScrollViewWithFrame:(CGRect)rect imageUrlArray:(NSArray * _Nonnull)imageUrlArray;
```
If you want to a pageController<br/>
-
You need make the parameter `isPageController` be `YES`<br/>

If you want to Automatic rolling
-
You need make the parameter `isAuto` be `YES`<br/>

imageBlock
-
After Clicking on the image,What you want to do here,the "index" is the image subscript.<br/>
